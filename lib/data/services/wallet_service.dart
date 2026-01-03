import 'package:zenthory/zenthory.dart';

class WalletService {
  static final WalletService _instance = WalletService._internal();

  factory WalletService() => _instance;

  WalletService._internal();

  final WalletDao _dao = WalletDao(AppDatabase.instance);

  Future<List<WalletModel>> fetchAll({bool? isLocked, bool? isHidden}) async {
    final data = await _dao.getAll(isLocked: isLocked, isHidden: isHidden);
    return data.map(WalletModel.fromEntity).toList();
  }

  Future<int> create(WalletModel wallet) {
    return _dao.insertWallet(wallet.toInsertCompanion());
  }

  Future<void> update(WalletModel wallet) async {
    await _dao.updateWallet(wallet.toEntity());
  }

  Future<bool> nameExists(String name, {int? excludeId}) {
    return _dao.existsByName(name, excludeId: excludeId);
  }

  Future<void> insertAll(List<WalletModel> data) async => _dao.insertAll(data);

  Future<WalletModel?> find(int id) async {
    final Wallet? wallet = await _dao.find(id);
    return wallet != null ? WalletModel.fromEntity(wallet) : null;
  }

  Future<void> recalculateWalletBalance({WalletModel? wallet, int? id}) async {
    if (id != null || wallet != null) {
      final WalletModel? walletAccount = wallet ?? await find(id!);
      if (walletAccount != null) {
        await update(
          walletAccount.copyWith(
            balance: await _dao.recalculateWalletBalance(walletAccount.id),
          ),
        );
      }
    }
  }

  Future<void> recalculateWalletsBalance() async {
    for (var wallet in (await fetchAll())) {
      await recalculateWalletBalance(wallet: wallet);
    }
  }

  Future<void> updateBalance(int walletId, double newBalance) async =>
      _dao.updateBalance(walletId, newBalance);
}
