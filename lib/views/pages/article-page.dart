import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Title
            Text(_article.title, style: Theme.of(context).textTheme.headline5),

            // Infobar
            Container(
              margin: EdgeInsets.only(top: 8),
              child: Row(children: [
                Container(child: getArticleScoreStylizedText(context, _article.score), margin: EdgeInsets.only(right: 8)),
                Container(child: Text("${timeago.format(_article.time)} ago"),margin: EdgeInsets.only(right: 8)),
              ]),
            ),

            // Optional text content
            Html(data: _article.text),
            
            // Action bar
            Row(children: [
              Icon(Icons.open_in_browser),
              Icon(Icons.share),
              Icon(Icons.bookmark),
            ])
          ]
        )
      )
    );
  }
}
