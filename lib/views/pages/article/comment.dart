import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:index/models/article-details-model.dart';

/// Widget for a comment thread - a parent comment and all it's
/// child comments (and their responses, on and on).
class IndexComment extends StatelessWidget {
  final ArticleCommentModel comment;

  const IndexComment({
    Key key,
    this.comment,
  });

  /// Recursively builds comments, with their responses
  Widget _buildComment(ArticleCommentModel comment, bool hasParent) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The reply depth indicator
          hasParent
              ? Container(
                  width: 4,
                  // height: 100,
                  margin: EdgeInsets.only(right: 5),
                  color: Colors.grey.withOpacity(.5),
                )
              : Container(),

          // The actual comment content
          Expanded(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      comment.author != null ? comment.author : '<NULL>',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Html(data: comment.text != null ? comment.text : "<NULL>"),
                Column(
                    children: comment.responses
                        .map((r) => _buildComment(r, true))
                        .toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildComment(comment, false);
  }
}
