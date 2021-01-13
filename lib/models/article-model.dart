class ArticleModel {
  final String author;
  final String title;
  final String url;
  final DateTime time;
  final int score;
  final String text;
  final String type;
  final int descendants;
  final List<dynamic> kids;

  ArticleModel({
    this.author,
    this.title,
    this.url,
    this.time,
    this.score,
    this.text,
    this.type,
    this.descendants,
    this.kids,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final int time = json['time'] as int;
    return ArticleModel(
      author: json['by'],
      title: json['title'],
      url: json['url'],
      time: DateTime.fromMillisecondsSinceEpoch(time * 1000, isUtc: true),
      score: json['score'],
      text: json['text'] != null ? json['text'] : "",
      type: json['type'],
      descendants: json['descendants'],
      // TODO: Cast to List<int> or some sort of observable
      kids: json['kids'],
    );
  }
}
