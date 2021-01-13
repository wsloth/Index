import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:index/widgets/article.dart';
import 'package:timeago/timeago.dart' as timeago;

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
  final _biggerFont = TextStyle(fontSize: 18.0);

  Future<List<ArticleModel>> futureArticles;

  @override
  void initState() {
    super.initState();
    final service = ArticleService();
    futureArticles = service.fetchFrontPage();
  }

  Widget _buildRow(ArticleModel article) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),

      title: Text(
        article.title,
        style: _biggerFont,
      ),

      subtitle: Container(
        margin: EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Container(child: getArticleScoreStylizedText(context, article.score), margin: EdgeInsets.only(right: 8)),
            Container(child: Text(timeago.format(article.time)), margin: EdgeInsets.only(right: 8)),
            getReadableUrlWidget(article.url),
          ]
        ),
      ),

      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.message_outlined),
          Text(article.descendants.toString())
        ]
      ),

      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return ArticlePage(article: article);
      })),
    );
  }

  Widget _buildArticlesList() {
    return FutureBuilder<List<ArticleModel>>(
      future: futureArticles,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            padding: EdgeInsets.all(15.0),
            itemCount: snapshot.data.length,
            separatorBuilder: (BuildContext context, int index) => Divider(height: 1),
            itemBuilder: (context, i) {
              return _buildRow(snapshot.data[i]);
            }
          );
        } else if (snapshot.hasError) {
          return getGenericErrorWidget(context);
        }

        // By default, show a loading spinner.
        return Center(
          child: CircularProgressIndicator()
        );
      },
    );
  }

  List<Widget> _buildFrontPageHeader(
      BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        expandedHeight: 125.0,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text("The Index",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                shadows: [Shadow(color: Colors.black, blurRadius: 2)]
              )
            ),
            background: Stack(fit: StackFit.expand, children: [
              Image.network(
                'https://images.pexels.com/photos/5699665/pexels-photo-5699665.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260',
                fit: BoxFit.cover,
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.0, 0.5),
                    end: Alignment(0.0, 0.0),
                    colors: <Color>[
                      Color(0x60000000),
                      Color(0x00000000),
                    ],
                  ),
                ),
              ),
            ])),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            _buildFrontPageHeader(context, innerBoxIsScrolled),
        body: _buildArticlesList(),
      )
    );
  }
}
