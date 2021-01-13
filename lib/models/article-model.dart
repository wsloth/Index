class ArticleModel {
  final String author;
  final String title;
  final String url;

  ArticleModel({this.author, this.title, this.url});

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      author: json['by'],
      title: json['title'],
      url: json['url'],
    );
  }
}
