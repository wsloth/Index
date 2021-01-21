class ArticleModel {
  // TODO: Add more friendly property names that can be used with multiple news sources
  final String author;
  final String title;
  final String url;
  final DateTime time;
  final int score;
  final String text;
  final String type;
  final int descendants;
  final List<int> responseIds;

  ArticleModel({
    this.author,
    this.title,
    this.url,
    this.time,
    this.score,
    this.text,
    this.type,
    this.descendants,
    this.responseIds,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final int time = json['time'] as int;
    
    List<int> responseIds = List<int>();
    if (json['kids'] != null)
      responseIds = List<int>.from(json['kids'].map((x) => x));

    return ArticleModel(
      author: json['by'],
      title: json['title'],
      url: json['url'],
      time: DateTime.fromMillisecondsSinceEpoch(time * 1000, isUtc: true),
      score: json['score'],
      text: json['text'],
      type: json['type'],
      descendants: json['descendants'],
      responseIds: responseIds,
    );
  }
}
