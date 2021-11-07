import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:index/models/article-details-model.dart';
import 'package:index/widgets/error.dart';
import 'package:index/widgets/shimmer.dart';

import 'comment.dart';

/// Constructs the asyncronously streamed comment section
class IndexCommentSection extends StatelessWidget {
  final Stream<List<ArticleCommentModel>> commentSectionStream;

  const IndexCommentSection({
    Key key,
    this.commentSectionStream,
  });

  Widget _buildLoadingState() {
    return Column(children: [
      // Ehh, this could probably be improved
      const ShimmerArticle(),
      const ShimmerArticle(),
      const ShimmerArticle(),
      const ShimmerArticle(),
      const ShimmerArticle(),
      const ShimmerArticle(),
      const ShimmerArticle(),
      const ShimmerArticle(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ArticleCommentModel>>(
      stream: commentSectionStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<ArticleCommentModel>> snapshot) {
        if (snapshot.hasError) {
          return getGenericErrorWidget(context);
        }
        if (snapshot.hasData == null || snapshot.hasData == false) {
          return _buildLoadingState();
        }

        // Efficiently construct list of all comments
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            if (snapshot.data[index].author == null && snapshot.data[index].text == null) {
              return ShimmerArticle();
            } else {
              return IndexComment(comment: snapshot.data[index]);
            }
          });
      },
    );
  }
}
