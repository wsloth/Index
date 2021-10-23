import "package:hive/hive.dart";

part "articles-data-hive_model.g.dart";

@HiveType(typeId: 1)
class ArticlesDataHiveModel {
  @HiveField(0)
  final DateTime lastUpdated;

  @HiveField(1)
  final List<int> idList;

  ArticlesDataHiveModel({this.idList, this.lastUpdated});
}
