// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'articles-data-hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArticlesDataHiveModelAdapter extends TypeAdapter<ArticlesDataHiveModel> {
  @override
  final int typeId = 1;

  @override
  ArticlesDataHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArticlesDataHiveModel(
      idList: (fields[1] as List).cast<int>(),
      lastUpdated: fields[0] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ArticlesDataHiveModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.lastUpdated)
      ..writeByte(1)
      ..write(obj.idList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticlesDataHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
