import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:index/widgets/separator.dart';
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

  bool webviewIsLoading = false;

  _ArticlePageState(this.article);

  Widget _constructPageBody() {
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
    final articleHasUrl = article.url != null;
    final articleHasBody = article.text != null;
    return Container(
      padding: EdgeInsets.all(20),
      height: 1000,
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
                // TODO: Show toast/alert/popup
              }
            },
          ),
        ],
      ),
      body: LoadingOverlay(
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
