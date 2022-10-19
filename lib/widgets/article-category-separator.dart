import 'package:flutter/material.dart';
import 'package:index/widgets/separator.dart';

class ArticleCategorySeparator extends StatelessWidget {
  final String? title;
  final bool showSeparator;

  ArticleCategorySeparator({this.title, this.showSeparator = true});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      this.showSeparator ? Separator() : Container(),
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.fromLTRB(24, this.showSeparator ? 24 : 0, 24, 12),
          child: Text(
            this.title!,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ),
    ]);
  }
}
