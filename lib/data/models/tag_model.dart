import 'package:drift/drift.dart';
import 'package:flutter/animation.dart';
import 'package:zenthory/zenthory.dart';

class TagModel {
  final int id;
  final String name;
  final String color;
  final DateTime createdAt;
  final DateTime updatedAt;

  TagModel({
    required this.id,
    required this.name,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TagModel.fromEntity(Tag tag) {
    return TagModel(
      id: tag.id,
      name: tag.name,
      color: tag.color,
      createdAt: tag.createdAt,
      updatedAt: tag.updatedAt,
    );
  }

  Tag toEntity() {
    return Tag(
      id: id,
      name: name,
      color: color,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  TagModel copyWith({
    int? id,
    String? name,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TagModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  TagsCompanion toInsertCompanion() {
    return TagsCompanion(
      name: Value(name),
      color: Value(color),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  Color get nativeColor => Color(int.parse("0XFF$color"));
}
