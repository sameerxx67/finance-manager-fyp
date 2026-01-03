import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class TagService {
  static final TagService _instance = TagService._internal();

  factory TagService() => _instance;

  TagService._internal();

  final TagDao _dao = TagDao(AppDatabase.instance);

  Future<List<TagModel>> fetchAll() async =>
      (await _dao.getAll()).map(TagModel.fromEntity).toList();

  Future<bool> nameExists(String name, {int? excludeId}) =>
      _dao.existsByName(name, excludeId: excludeId);

  Future<int> create(TagModel tag) => _dao.insertTag(tag.toInsertCompanion());

  Future<void> update(TagModel tag) async =>
      await _dao.updateTag(tag.toEntity());

  Future<int> delete(int id) => _dao.deleteTag(id);

  Future<void> insertAll(List<TagModel> data) async => _dao.insertAll(data);

  Future<List<TagSummaryModel>> getTopTags({
    int? categoryId,
    int? contactId,
    int? walletId,
    DateTimeRange? dateRange,
    TransactionType? type,
    List<int>? tagIds,
    int limit = 5,
  }) async => _dao.getTopTags(
    categoryId: categoryId,
    contactId: contactId,
    walletId: walletId,
    dateRange: dateRange,
    type: type,
    tagIds: tagIds,
  );
}
