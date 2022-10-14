import 'package:customizable_space_bar/customizable_space_bar.dart';
import 'package:flutter/material.dart';
import 'package:index/models/articles-model.dart';
import 'package:index/widgets/separator.dart';
import 'package:index/widgets/shimmer.dart';
import 'package:intl/intl.dart';

class FrontPageHeader extends StatefulWidget {
  final Future<ArticlesModel>? articles;
  final Key? key;

  FrontPageHeader({@required this.articles, this.key});

  @override
  _FrontPageHeaderState createState() => _FrontPageHeaderState();
}

class _FrontPageHeaderState extends State<FrontPageHeader> {
  _buildHeaderAsyncContent() {
    return FutureBuilder<ArticlesModel>(
        future: widget.articles,
        builder: (context, AsyncSnapshot<ArticlesModel> snapshot) {
          if (snapshot.connectionState != ConnectionState.done ||
              !snapshot.hasData) {
            // return CircularProgressIndicator(strokeWidth: 2);
            return Column(
              children: [
                ShimmerText(
                    width: 225, marginBottom: 10, alignment: Alignment.center),
                ShimmerText(
                    width: 100, marginBottom: 16, alignment: Alignment.center),
                ShimmerText(
                    width: 150, marginBottom: 16, alignment: Alignment.center),
              ],
            );
          }

          var formatter = DateFormat("EEEE',' d MMMM',' H':'m 'Edition'");
          return Column(children: [
            Text(formatter.format(snapshot.data!.lastUpdated!),
                style: Theme.of(context).textTheme.headline2),
            SizedBox(height: 10),
            // TODO: Add volume name that increments every day
            // Text('Vol. No. 00013',
            //     style: Theme.of(context).textTheme.headline2),
            SizedBox(height: 16),

            // TODO: Add icon row for additional filters & settings
            // Row(
            //   mainAxisSize: MainAxisSize.max,
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     IconButton(icon: Icon(Icons.refresh)),
            //     SizedBox(width: 16),
            //     IconButton(icon: Icon(Icons.sort)),
            //     SizedBox(width: 16),
            //     IconButton(icon: Icon(Icons.settings)),
            //   ],
            // ),
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      key: widget.key,
      pinned: true,
      // leading: IconButton(icon: Icon(Icons.settings)),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      expandedHeight: 275,
      elevation: 3,
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
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 25),
                Text('The Index.',
                    style: Theme.of(context).textTheme.headline1),
                SizedBox(height: 10),
                _buildHeaderAsyncContent(),
                SizedBox(height: 20),
                Separator(),
              ],
            ),
          );
        },
      ),
    );
  }
}
