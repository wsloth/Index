import 'article-model.dart';

class ArticlesModel {
  DateTime lastUpdated;
  List<ArticleModel> articles;

  ArticlesModel({
    this.lastUpdated,
    this.articles,
  });
}
