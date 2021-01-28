import 'article-model.dart';

class ArticleCommentModel {
  String author;
  int id;
  List<int> responseIds;
  List<ArticleCommentModel> responses;
  int parent;
  String text;
  DateTime time;
  String type;

  ArticleCommentModel({
    this.author,
    this.id,
    this.responseIds,
    this.parent,
    this.text,
    this.time,
    this.type,
  });

  factory ArticleCommentModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    final int time = json['time'] as int;
    List<int> responseIds = List<int>();
    if (json['kids'] != null)
      responseIds = List<int>.from(json['kids'].map((x) => x));

    return ArticleCommentModel(
      author: json['by'],
      text: json['text'],
      time: DateTime.fromMillisecondsSinceEpoch(time * 1000, isUtc: true),
      type: json['type'],
      responseIds: responseIds,
    );
  }
}

class ArticleDetailsModel {
  ArticleModel article;
  List<ArticleCommentModel> comments;

  ArticleDetailsModel({
    this.article,
    this.comments,
  });
}
