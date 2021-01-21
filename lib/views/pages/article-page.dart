import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:index/models/article-details-model.dart';
import 'package:index/services/article-service.dart';
import 'package:index/widgets/error.dart';
import 'package:index/widgets/separator.dart';
import 'package:index/widgets/shimmer.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:index/models/article-model.dart';
import 'package:index/widgets/article.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticlePage extends StatefulWidget {
  final ArticleModel article;

  ArticlePage({this.article});

  @override
  _ArticlePageState createState() => _ArticlePageState(article);
}

class _ArticlePageState extends State<ArticlePage> {
  final ArticleModel article;
  Future<ArticleDetailsModel> articleDetails;
  bool webviewIsLoading = false;

  _ArticlePageState(this.article);

  @override
  void initState() {
    super.initState();
    _fetchArticleDetails();
  }

  _fetchArticleDetails() async {
    final service = ArticleService();
    articleDetails = service.fetchArticleDetails(article);
  }

  /// Constructs the page body, which is shown "below" the sliding panel
  Widget _constructPageBody() {
    // TODO: Default padding on the bottom where the slider overlaps
    if (article.url != null) {
      return WebView(
        initialUrl: article.url,
        onPageStarted: (url) {
          setState(() {
            webviewIsLoading = true;
          });
        },
        onPageFinished: (url) {
          setState(() {
            webviewIsLoading = false;
          });
        },
        javascriptMode: JavascriptMode.unrestricted,
      );
    }

    return Html(data: article.text);
  }

  /// Recursively builds comments, with their responses
  Widget _constructComment(ArticleCommentModel comment, bool hasParent) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The reply depth indicator
          hasParent
              ? Container(
                  width: 4,
                  // height: 100,
                  margin: EdgeInsets.only(right: 5),
                  color: Colors.grey.withOpacity(.5),
                )
              : Container(),

          // The actual comment content
          Expanded(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      comment.author,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Html(data: comment.text),
                Column(
                    children: comment.responses
                        .map((r) => _constructComment(r, true))
                        .toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _constructCommentSection() {
    return FutureBuilder<ArticleDetailsModel>(
      future: articleDetails,
      builder:
          (BuildContext context, AsyncSnapshot<ArticleDetailsModel> snapshot) {
        if (snapshot.hasError) {
          return getGenericErrorWidget(context);
        }
        if (snapshot.hasData == null || snapshot.hasData == false) {
          return Stack(children: [
            const ShimmerArticle(),
            const ShimmerArticle(),
            const ShimmerArticle(),
          ]);
        }

        List<Widget> topLevelComments = snapshot.data.comments
            .map((c) => _constructComment(c, false))
            .toList();
        return Column(children: [
          ...topLevelComments,
        ]);
      },
    );
  }

  Widget _constructSlidingSheet() {
    final articleHasUrl = article.url != null;
    final articleHasBody = article.text != null;
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 20,
              height: 5,
              color: Colors.grey.withOpacity(.5),
            ),
          ),

          // Title
          const SizedBox(height: 12),
          Text(article.title, style: Theme.of(context).textTheme.headline5),
          const SizedBox(height: 12),

          // Full URL
          articleHasUrl
              ? Text(article.url, style: TextStyle(fontSize: 14))
              : Container(),
          articleHasUrl ? SizedBox(height: 12) : Container(),

          // Infobar
          Container(
            child: Row(children: [
              Container(
                  child: getArticleScoreStylizedText(context, article.score),
                  margin: EdgeInsets.only(right: 8)),
              Container(
                  child: Text(timeago.format(article.time)),
                  margin: EdgeInsets.only(right: 8)),
              Container(
                  child: Text("${article.descendants} comments"),
                  margin: EdgeInsets.only(right: 8)),
              Container(
                  child: Text("By: ${article.author}"),
                  margin: EdgeInsets.only(right: 8)),
            ]),
          ),

          // Optional text content
          articleHasBody ? SizedBox(height: 8) : Container(),
          articleHasBody ? Html(data: article.text) : Container(),
          SizedBox(height: 8),

          // Action bar
          Separator(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.keyboard_arrow_up),
              Icon(Icons.keyboard_arrow_down),
              Icon(Icons.share),
              Icon(Icons.star_border),
              Icon(Icons.open_in_browser),
            ],
          ),
          Separator(),
          _constructCommentSection(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            tooltip: 'Open in browser',
            onPressed: () async {
              if (await canLaunch(article.url)) {
                await launch(article.url);
              } else {
                Get.snackbar('Error',
                    'Unable to open url. Please try again later or contact the developer.');
              }
            },
          ),
        ],
      ),
      body: LoadingOverlay(
        // TODO: Don't block slidingsheet, if possible
        isLoading: webviewIsLoading,
        child: SlidingSheet(
          elevation: 10,
          // Configure snapping the overlay to the bottom of the screen
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [0.15, 0.4, 1.0],
            positioning: SnapPositioning.relativeToAvailableSpace,
          ),
          // The widget "below" the sliding sheet
          body: _constructPageBody(),
          // Content of the sliding sheet
          builder: (context, state) {
            return _constructSlidingSheet();
          },
        ),
      ),
    );
  }
}
