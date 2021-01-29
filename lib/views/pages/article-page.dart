import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:index/models/article-details-model.dart';
import 'package:index/services/article-service.dart';
import 'package:index/views/pages/article/comment-section.dart';
import 'package:index/widgets/error.dart';
import 'package:index/widgets/separator.dart';
import 'package:index/widgets/shimmer.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import 'package:index/models/article-model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'article/slider-header.dart';

class ArticlePage extends StatefulWidget {
  final ArticleModel article;

  ArticlePage({this.article});

  @override
  _ArticlePageState createState() => _ArticlePageState(article);
}

class _ArticlePageState extends State<ArticlePage> {
  final ArticleModel article;
  Stream<List<ArticleCommentModel>> commentSectionStream;
  bool webviewIsLoading = false;

  _ArticlePageState(this.article);

  @override
  void initState() {
    super.initState();
    _fetchArticleDetails();
  }

  _fetchArticleDetails() async {
    final service = ArticleService();
    commentSectionStream = service.streamCommentSectionAsync(article);
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


  Widget _constructSlidingSheet() {
    final articleHasBody = article.text != null;
    return Container(
      color: Get.isDarkMode ? Colors.black : Colors.white,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 40),
      child: Column(
        children: [
          // Title
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: AutoSizeText(article.title,
                maxLines: 3,
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 40)),
          ),
          const SizedBox(height: 12),

          // Infobar
          Container(
            child: Row(children: [
              Container(
                  child: Text("Submitted by ${article.author}"),
                  margin: EdgeInsets.only(right: 8)),
            ]),
          ),

          // Optional text content
          articleHasBody ? SizedBox(height: 8) : Container(),
          articleHasBody ? Html(data: article.text) : Container(),
          SizedBox(height: 12),
          Separator(),
          SizedBox(height: 12),

          IndexCommentSection(commentSectionStream: commentSectionStream),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Article"),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
        actions: [
          // Share
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share',
            onPressed: () async {
              Get.snackbar('Sorry...', 'Sharing is not supported yet.');
            },
          ),
          // Open in browser
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
      body: SlidingSheet(
        elevation: 8,
        liftOnScrollHeaderElevation: 8,
        cornerRadius: 32,
        cornerRadiusOnFullscreen: 0,
        // Configure snapping the overlay to the bottom of the screen
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [SnapSpec.headerSnap, SnapSpec.expanded],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        // The widget "below" the sliding sheet
        body: _constructPageBody(),
        // Sliding sheet header
        headerBuilder: (_, __) => IndexSlidingSheetHeader(article: article),

        // Sliding sheet content
        builder: (context, state) {
          return _constructSlidingSheet();
        },
      ),
    );
  }
}
