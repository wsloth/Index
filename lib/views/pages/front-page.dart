import 'package:flutter/material.dart';
import 'package:index/widgets/article.dart';
import 'package:index/widgets/separator.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:customizable_space_bar/customizable_space_bar.dart';

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
        child: Row(crossAxisAlignment: CrossAxisAlignment.baseline, children: [
          Container(
              child: getArticleScoreStylizedText(context, article.score),
              margin: EdgeInsets.only(right: 8)),
          Container(
              child: Text(timeago.format(article.time)),
              margin: EdgeInsets.only(right: 8)),
          getReadableUrlWidget(article.url),
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

              return Column(children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: _buildRow(snapshot.data[i])
                ),
                Separator()
              ]);
            },
            childCount: childCount,
          ),
        );

        // if (snapshot.hasData) {
        // return ListView.separated(
        //     padding: EdgeInsets.all(15.0),
        //     itemCount: snapshot.data.length,
        //     separatorBuilder: (BuildContext context, int index) =>
        //         Divider(height: 1),
        //     itemBuilder: (context, i) {
        //       return _buildRow(snapshot.data[i]);
        //     });
        // } else if (snapshot.hasError) {
        //   return getGenericErrorWidget(context);
        // }

        // // By default, show a loading spinner.
        // return Center(child: CircularProgressIndicator());
      },
    );
  }

  SliverAppBar _buildAppHeader(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      // leading: IconButton(icon: Icon(Icons.settings)),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      expandedHeight: 200,
      flexibleSpace: CustomizableSpaceBar(
        builder: (context, scrollingRate) {
          var collapsedOpacity = 1 - (scrollingRate * 1.25);
          if (collapsedOpacity < 0) collapsedOpacity = 0;

          // Render the collapsed state, containing just the app title
          if (collapsedOpacity <= 0.15) {
            double calculatedSlowedOpacity = 1 - (collapsedOpacity * 25);
            if (calculatedSlowedOpacity < 0) calculatedSlowedOpacity = 0;
            return AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                opacity: calculatedSlowedOpacity,
                child: Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 15),
                    // padding: EdgeInsets.only(bottom: 13, left: 52),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Index _",
                        style: TextStyle(
                            fontSize: 42 - 18 * scrollingRate,
                            fontWeight: FontWeight.bold),
                      ),
                    )));
          }

          // Render the opened state
          return Opacity(
            opacity: collapsedOpacity,
            child: Card(
              elevation: 8,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  SizedBox(height: 25),
                  Text('The Index',
                      style: TextStyle(
                          // color: Colors.white,
                          fontSize: 48.0)),
                  SizedBox(height: 10),
                  Text('Last updated at 17:45'),
                  // Row(
                  //   mainAxisSize: MainAxisSize.max,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     TextButton(
                  //       child: Text('SETTINGS'),
                  //       onPressed: () => {},
                  //     ),
                  //     SizedBox(width: 16),
                  //     TextButton(
                  //       child: Text('REFRESH'),
                  //       onPressed: () => {},
                  //     ),
                  //     SizedBox(width: 16),
                  //     TextButton(
                  //       child: Text('REFRESH'),
                  //       onPressed: () => {},
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [_buildAppHeader(context), SliverPadding(padding: EdgeInsets.all(10)), _buildArticlesList()],
    ));
  }
}
