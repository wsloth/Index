import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:index/widgets/separator.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:index/models/article-model.dart';
import 'package:index/widgets/article.dart';

class ArticlePage extends StatefulWidget {
  final ArticleModel article;

  ArticlePage({this.article});

  @override
  _ArticlePageState createState() => _ArticlePageState(article);
}

class _ArticlePageState extends State<ArticlePage> {
  final ArticleModel _article;

  _ArticlePageState(this._article);

  Widget _buildComment() {
    // TODO: Recurse
    // if (comment.children) {
    //   for (final child in comment.children) {
    //     _buildComment(child, depth++);
    //   }
    // }
    return Text('');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Abstract away, probably generate link to HN post if URL not available
    final bool articleHasUrl = _article.url != null;
    final bool articleHasBody = _article.text != null;

    return Scaffold(
        appBar: AppBar(
          title: Text('Comments'),
        ),
        body: Container(
            padding: EdgeInsets.all(20),
            child: Column(children: [
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
                      child:
                          getArticleScoreStylizedText(context, _article.score),
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
      ),
    );
  }
}
