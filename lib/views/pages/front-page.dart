import 'package:flutter/material.dart';
import 'package:index/widgets/frontpage-header.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:index/widgets/article.dart';
import 'package:index/widgets/article-category-separator.dart';

import 'package:index/widgets/url.dart';
import 'package:index/widgets/error.dart';
import 'article-page.dart';
import '../../services/article-service.dart';
import '../../models/article-model.dart';

class FrontPage extends StatefulWidget {
  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  Future<List<ArticleModel>> futureArticles;

  @override
  void initState() {
    super.initState();
    final service = ArticleService();
    futureArticles = service.fetchFrontPage();
  }

  Widget _buildArticle(ArticleModel article) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(24, 8, 24, 8),
      title: Text(
        article.title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Container(
        margin: EdgeInsets.only(top: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.baseline, children: [
          Container(
              child: getArticleScoreStylizedText(context, article.score),
              margin: EdgeInsets.only(right: 8)),
          Container(
              child: Text(timeago.format(article.time), style: Theme.of(context).textTheme.subtitle2),
              margin: EdgeInsets.only(right: 8)),
          getReadableUrlWidget(context, article.url),
        ]),
      ),
      trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.message_outlined),
            Text(article.descendants.toString())
          ]),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return ArticlePage(article: article);
      })),
    );
  }

  Widget _buildArticlesList() {
    return FutureBuilder(
      future: futureArticles,
      builder: (context, snapshot) {
        // Detemine whether to render the loading/error state or the list
        final int childCount = snapshot.hasData ? snapshot.data.length : 1;

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (ctx, i) {
              if (snapshot.hasError) {
                return getGenericErrorWidget(context);
              }
              if (snapshot.hasData == false || snapshot.hasData == null) {
                return Center(child: CircularProgressIndicator());
              }

              final List<Widget> childrenToRender = [
                _buildArticle(snapshot.data[i]),
              ];

              // TODO: Add different categories
              if (i == 0) {
                childrenToRender.insert(
                    0, ArticleCategorySeparator(title: 'THE FRONTPAGE.', showSeparator: false));
              }

              if (i == 5) {
                childrenToRender.insert(
                    0, ArticleCategorySeparator(title: 'AROUND THE WEB.'));
              }

              return Column(
                children: [...childrenToRender]
              );
            },
            childCount: childCount,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        FrontpageHeader(),
        // SliverPadding(padding: EdgeInsets.all(5)),
        _buildArticlesList()
      ],
    ));
  }
}
