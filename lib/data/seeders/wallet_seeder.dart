import 'package:zenthory/zenthory.dart';

import 'seeder.dart';

class WalletSeeder extends Seeder {
  final WalletService service = WalletService();

  @override
  Future<void> seed() async {
    final now = DateTime.now();
    final String name = "Default Account";
    if (!await service.nameExists(name)) {
      await service.create(
        WalletModel(
          id: 0,
          name: name,
          type: WalletType.cash,
          currency: AppStrings.defaultCurrency,
          balance: 0,
          isLocked: false,
          isHidden: false,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
  }
}
