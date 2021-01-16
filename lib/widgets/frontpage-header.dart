import 'package:customizable_space_bar/customizable_space_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:index/widgets/separator.dart';

class FrontpageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      // leading: IconButton(icon: Icon(Icons.settings)),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      expandedHeight: 300,
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
                Text('The Index.', style: Theme.of(context).textTheme.headline1),
                SizedBox(height: 10),
                Text('Thursday, 12 September, 17:45 Edition',
                    style: Theme.of(context).textTheme.headline2),
                SizedBox(height: 10),
                Text('Vol. No. 00013',
                    style: Theme.of(context).textTheme.headline2),
                SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.refresh)),
                    SizedBox(width: 16),
                    IconButton(icon: Icon(Icons.sort)),
                    SizedBox(width: 16),
                    IconButton(icon: Icon(Icons.settings)),
                  ],
                ),
                SizedBox(height:20),
                Separator(),
              ],
            ),
          );
        },
      ),
    );
  }
}
