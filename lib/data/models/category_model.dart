import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class CategoryModel {
  final int id;
  final String? identifier;
  final int? categoryId;
  final String name;
  final String? description;
  final TransactionType type;
  final String icon;
  final String color;
  final bool builtIn;
  List<CategoryModel>? categories;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel({
    required this.id,
    this.identifier,
    this.categoryId,
    required this.name,
    this.description,
    required this.type,
    required this.icon,
    required this.color,
    this.builtIn = false,
    this.categories,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      identifier: category.identifier,
      categoryId: category.categoryId,
      name: category.name,
      description: category.description,
      type: category.type,
      icon: category.icon,
      color: category.color,
      builtIn: category.builtIn,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
    );
  }

  Category toEntity() {
    return Category(
      id: id,
      identifier: identifier,
      categoryId: categoryId,
      name: name,
      description: description,
      type: type,
      icon: icon,
      color: color,
      builtIn: builtIn,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  CategoryModel copyWith({
    int? categoryId,
    String? name,
    String? description,
    TransactionType? type,
    String? icon,
    String? color,
    List<CategoryModel>? categories,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id,
      identifier: identifier,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      builtIn: builtIn,
      categories: categories ?? this.categories,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  CategoriesCompanion toInsertCompanion() {
    return CategoriesCompanion(
      identifier: Value(identifier),
      categoryId: Value(categoryId),
      name: Value(name),
      description: Value(description),
      type: Value(type),
      icon: Value(icon),
      color: Value(color),
      builtIn: Value(builtIn),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  Color get nativeColor => Color(int.parse("0XFF$color"));

  bool get hasSub => categories != null && categories!.isNotEmpty;

  bool get isRoot => categoryId == null;
}
