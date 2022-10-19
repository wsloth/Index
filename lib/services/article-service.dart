import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:index/models/article-details-model.dart';
import 'package:index/models/articles-data-hive_model.dart';
import 'package:index/models/articles-model.dart';

import '../models/article-model.dart';

class ArticleService {
  final baseUrl = 'https://hacker-news.firebaseio.com/v0/';
  Box<ArticlesDataHiveModel>? articlesBox;

  /// Fetches article IDs from the HN API and stores it in Hive box.
  Future<List<int>> _getDataFromAPI() async {
    // fetch news feed
    final response = await http.get(Uri.parse(baseUrl + 'topstories.json'));
    List<dynamic> tempData = json.decode(response.body);
    List<int> articleIds = tempData.cast<int>();

    // store news feed in Hive box
    ArticlesDataHiveModel newArticlesData = ArticlesDataHiveModel(
      lastUpdated: DateTime.now(),
      idList: articleIds,
    );
    articlesBox!.put('data', newArticlesData);
    return articleIds;
  }

  /// Fetches the "front page" of the app: the 50 top stories on
  /// hacker news currently.
  Future<ArticlesModel> fetchFrontPage({bool forceRefresh = false}) async {
    bool getCachedData = false;
    List<int>? articleIds;

    articlesBox = Hive.box<ArticlesDataHiveModel>('articlesData');
    ArticlesDataHiveModel? articlesData;

    if (!forceRefresh && articlesBox!.isNotEmpty) {
      // stored data is available
      articlesData = articlesBox!.get('data');

      DateTime currentTime = DateTime.now();
      // 7 AM
      DateTime startTime =
          DateTime(currentTime.year, currentTime.month, currentTime.day, 7);
      // 10 PM
      DateTime endTime =
          DateTime(currentTime.year, currentTime.month, currentTime.day, 20);

      if (articlesData!.lastUpdated.isAfter(startTime) &&
          articlesData.lastUpdated.isBefore(endTime)) {
        getCachedData = true;
      }

      articleIds =
          (getCachedData) ? articlesData.idList : await _getDataFromAPI();
    } else {
      // News Feed data is not stored in Hive box.
      // when - App is opened for the first time after install or cleaning app-data.
      articleIds = await _getDataFromAPI();
    }

    articlesData = articlesBox!.get('data');

    List<Future<ArticleModel>> apiCalls = [];
    for (int articleId in articleIds!.take(50)) {
      apiCalls.add(fetchArticle(articleId));
    }

    // Fetch all & sort by most popular
    List<ArticleModel> articles = await Future.wait(apiCalls);
    articles.sort((a, b) => b.score!.compareTo(a.score!));

    return ArticlesModel(
      lastUpdated: articlesData!.lastUpdated,
      articles: articles,
    );
  }

  /// Fetches a single story by their id
  Future<ArticleModel> fetchArticle(int articleId) async {
    final articleResponse = await http
        .get(Uri.parse(baseUrl + 'item/' + articleId.toString() + '.json'));
    return ArticleModel.fromJson(jsonDecode(articleResponse.body));
  }

  /// Fetches the article details: for now just the comment section
  Future<ArticleDetailsModel> fetchArticleDetails(ArticleModel article) async {
    var comments = await fetchChildObjectsRecursively(article.responseIds!);
    return ArticleDetailsModel(article: article, comments: comments);
  }

  /// Fetches the data of each response child, and then recursively fetches
  /// their children too
  Future<List<ArticleCommentModel>> fetchChildObjectsRecursively(
      List<int> childIds) async {
    // Fetch all comments in the array
    List<Future<ArticleCommentModel>> apiCalls = [];
    for (int articleChildId in childIds) {
      apiCalls.add(fetchChildObject(articleChildId));
    }
    List<ArticleCommentModel> comments = await Future.wait(apiCalls);

    // Fetch all comment responses
    List<Future<void>> responseCalls = [];
    for (var comment in comments) {
      responseCalls.add(fetchChildObjectsRecursively(comment.responseIds!)
          .then((value) => comment.responses = value));
    }
    await Future.wait(responseCalls);

    return comments;
  }

  Future<ArticleCommentModel> fetchChildObject(int childId) async {
    final articleResponse = await http
        .get(Uri.parse(baseUrl + 'item/' + childId.toString() + '.json'));
    return ArticleCommentModel.fromJson(jsonDecode(articleResponse.body));
  }

  Stream<List<ArticleCommentModel>> streamCommentSectionAsync(
      ArticleModel article) async* {
    List<ArticleCommentModel> allComments = [];
    for (int articleChildId in article.responseIds!) {
      var topLevelComment = await fetchCommentThread(articleChildId);
      allComments.add(topLevelComment);
      yield allComments;
    }
  }

  Future<ArticleCommentModel> fetchCommentThread(int topLevelCommentId) async {
    var recurse = (List<int> childIds) async {
      List<Future<ArticleCommentModel>> apiCalls = [];
      for (int articleChildId in childIds) {
        apiCalls.add(fetchChildObject(articleChildId));
      }
      List<ArticleCommentModel> comments = await Future.wait(apiCalls);

      // Fetch all comment responses
      List<Future<void>> responseCalls = [];
      for (var comment in comments) {
        responseCalls.add(fetchChildObjectsRecursively(comment.responseIds!)
            .then((value) => comment.responses = value));
      }
      await Future.wait(responseCalls);

      return comments;
    };

    // Fetch the entire comment thread for the top level comment
    var commentThread = await recurse([topLevelCommentId]);
    return commentThread[0]; // There is only one toplevel comment
  }
}
