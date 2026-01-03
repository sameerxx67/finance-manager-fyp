import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:zenthory/data/database/database.dart';

class ContactModel {
  final int id;
  final String name;
  final String color;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  ContactModel({
    required this.id,
    required this.name,
    required this.color,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContactModel.fromEntity(Contact entity) {
    return ContactModel(
      id: entity.id,
      name: entity.name,
      color: entity.color,
      note: entity.note,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Contact toEntity() {
    return Contact(
      id: id,
      name: name,
      color: color,
      note: note,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  ContactModel copyWith({
    int? id,
    String? name,
    String? color,
    String? phone,
    String? note,
    DateTime? updatedAt,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      note: note ?? this.note,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  ContactsCompanion toInsertCompanion() {
    return ContactsCompanion(
      name: Value(name),
      color: Value(color),
      note: Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  Color get nativeColor => Color(int.parse("0XFF$color"));
}
