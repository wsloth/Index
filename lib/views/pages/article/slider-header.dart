import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:index/models/article-model.dart';
import 'package:index/widgets/article.dart';
import 'package:timeago/timeago.dart' as timeago;

const double HEADER_HEIGHT = 60;
const double HEADER_X_PADDING = 24;

/// Widget for the sliding sheet header, displaying some
/// basic information about the article's discussion.
class IndexSlidingSheetHeader extends StatelessWidget {
  final ArticleModel? article;

  const IndexSlidingSheetHeader({
    Key? key,
    this.article,
  });

  Widget _buildRowLeftSide(context) {
    return Row(
      children: [
        Container(
          child: getArticleScoreStylizedText(context, article!.score!),
          margin: EdgeInsets.only(right: 8),
        ),
        Container(
            child: Text(timeago.format(article!.time!)),
            margin: EdgeInsets.only(right: 8)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: HEADER_HEIGHT,
      width: double.infinity,
      color: Get.isDarkMode ? Colors.black : Colors.white,
      //  decoration: BoxDecoration(
      //   border: Border( bottom: BorderSide(width: 1, color: Colors.grey))
      // ),
      alignment: Alignment.center,
      child: Stack(children: [
        Positioned(
            left: HEADER_X_PADDING,
            height: HEADER_HEIGHT,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildRowLeftSide(context),
            )),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 20,
            margin: EdgeInsets.only(top: 8),
            height: 5,
            color: Colors.grey.withOpacity(.5),
          ),
        ),
        Positioned(
          right: HEADER_X_PADDING,
          height: HEADER_HEIGHT,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: Text("${article!.descendants} comments"),
              margin: EdgeInsets.only(right: 8),
            ),
          ),
        ),
      ]),
    );
  }
}
