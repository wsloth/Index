import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/article-model.dart';

class ArticleService {
  final baseUrl = 'https://hacker-news.firebaseio.com/v0/';

  Future<List<ArticleModel>> fetchFrontPage() async {
    final response = await http.get(baseUrl + 'topstories.json');
    final List<dynamic> articleIds = jsonDecode(response.body);

    List<Future<ArticleModel>> apiCalls = [];
    for (int articleId in articleIds.take(50)) {
      apiCalls.add(fetchArticle(articleId));
    }
    return await Future.wait(apiCalls);
  }

  Future<ArticleModel> fetchArticle(int articleId) async {
    final articleResponse =
        await http.get(baseUrl + 'item/' + articleId.toString() + '.json');
    return ArticleModel.fromJson(jsonDecode(articleResponse.body));
  }
}
