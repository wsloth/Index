import 'package:flutter/material.dart';
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
      subtitle: getReadableUrlWidget(article.url),
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
                )),
            background: Stack(fit: StackFit.expand, children: [
              Image.network(
                "https://images.pexels.com/photos/102152/pexels-photo-102152.jpeg?cs=srgb&dl=pexels-markus-spiske-102152.jpg&fm=jpg",
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
    ));
  }
}
