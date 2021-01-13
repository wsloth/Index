import 'package:flutter/material.dart';
import 'package:index/models/article-model.dart';

class ArticlePage extends StatefulWidget {
  final ArticleModel article;

  ArticlePage({this.article});

  @override
  _ArticlePageState createState() => _ArticlePageState(article);
}

class _ArticlePageState extends State<ArticlePage> {
  final _suggestions = <String>[];
  final _biggerFont = TextStyle(fontSize: 18.0);
  final ArticleModel _article;

  _ArticlePageState(this._article);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The Index'),
      ),
      body: Text(_article.title),
    );
  }
}
