import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:index/widgets/separator.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:index/models/article-model.dart';
import 'package:index/widgets/article.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticlePage extends StatefulWidget {
  final ArticleModel article;

  ArticlePage({this.article});

  @override
  _ArticlePageState createState() => _ArticlePageState(article);
}

class _ArticlePageState extends State<ArticlePage> {
  final ArticleModel _article;

  _ArticlePageState(this._article);

  Widget _constructPageBody() {
    if (_article.url != null) {
      return WebView(
        initialUrl: _article.url,
      );
    }

    return Html(data: _article.text);
  }

  Widget _constructSlidingSheet() {
    final articleHasUrl = _article.url != null;
    final articleHasBody = _article.text != null;
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // Title
          Text(_article.title, style: Theme.of(context).textTheme.headline5),
          SizedBox(height: 12),

          // Full URL
          articleHasUrl
              ? Text(_article.url, style: TextStyle(fontSize: 14))
              : Container(),
          articleHasUrl ? SizedBox(height: 12) : Container(),

          // Infobar
          Container(
            child: Row(children: [
              Container(
                  child: getArticleScoreStylizedText(context, _article.score),
                  margin: EdgeInsets.only(right: 8)),
              Container(
                  child: Text(timeago.format(_article.time)),
                  margin: EdgeInsets.only(right: 8)),
              Container(
                  child: Text("${_article.descendants} comments"),
                  margin: EdgeInsets.only(right: 8)),
              Container(
                  child: Text("By: ${_article.author}"),
                  margin: EdgeInsets.only(right: 8)),
            ]),
          ),

          // Optional text content
          articleHasBody ? SizedBox(height: 8) : Container(),
          articleHasBody ? Html(data: _article.text) : Container(),
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
        title: Text('Comments'),
      ),
      body: SlidingSheet(
        elevation: 10,
        cornerRadius: 20,
        snapSpec: const SnapSpec(
          // Enable snapping. This is true by default.
          snap: true,
          // Set custom snapping points.
          snappings: [0.15, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        // The widget "below" the sliding sheet
        body: _constructPageBody(),
        // Content of the sliding sheet
        builder: (context, state) {
          // This is the content of the sheet that will get
          // scrolled, if the content is bigger than the available
          // height of the sheet.
          return Container(
            height: 1000,
            child: _constructSlidingSheet()
          );
        },
      ),
    );
  }
}
