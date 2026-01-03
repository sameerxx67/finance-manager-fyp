import 'package:drift/drift.dart';
import 'package:zenthory/data/database/tables/contacts_table.dart';
import 'package:zenthory/zenthory.dart';

part 'contact_dao.g.dart';

@DriftAccessor(tables: [Contacts])
class ContactDao extends DatabaseAccessor<AppDatabase> with _$ContactDaoMixin {
  ContactDao(super.db);

  Future<List<Contact>> getAll() {
    return (select(
      contacts,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  Future<int> insertContact(ContactsCompanion contact) {
    return into(contacts).insert(contact);
  }

  Future<bool> updateContact(Contact contact) {
    return update(contacts).replace(contact);
  }

  Future<int> deleteContact(int id) {
    return (delete(contacts)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<bool> existsByName(String name, {int? excludeId}) async {
    final query = select(contacts)
      ..where((t) {
        final nameCondition = t.name.equals(name.trim());
        final excludeIdCondition = excludeId != null
            ? t.id.isNotIn([excludeId])
            : const Constant(true);
        return nameCondition & excludeIdCondition;
      });

    return await query.getSingleOrNull() != null;
  }

  Future<void> insertAll(List<ContactModel> data) async {
    await batch((batch) {
      batch.insertAll(
        contacts,
        data.map((tx) => tx.toInsertCompanion()).toList(),
      );
    });
  }
}
