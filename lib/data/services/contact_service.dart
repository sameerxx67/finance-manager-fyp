import 'package:zenthory/zenthory.dart';

class ContactService {
  static final ContactService _instance = ContactService._internal();

  factory ContactService() => _instance;

  ContactService._internal();

  final ContactDao _dao = ContactDao(AppDatabase.instance);

  Future<List<ContactModel>> fetchAll() async =>
      (await _dao.getAll()).map(ContactModel.fromEntity).toList();

  Future<bool> nameExists(String name, {int? excludeId}) =>
      _dao.existsByName(name, excludeId: excludeId);

  Future<int> create(ContactModel contact) =>
      _dao.insertContact(contact.toInsertCompanion());

  Future<void> update(ContactModel contact) async =>
      await _dao.updateContact(contact.toEntity());

  Future<int> delete(int id) => _dao.deleteContact(id);

  Future<void> insertAll(List<ContactModel> data) async => _dao.insertAll(data);
}
