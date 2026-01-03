import 'dart:math';

import 'package:faker/faker.dart';
import 'package:zenthory/zenthory.dart';

import 'category_seeder.dart';
import 'seeder.dart';

class DameDataSeeder extends Seeder {
  final AppDatabase db = AppDatabase.instance;
  final WalletService walletService = WalletService();
  final CategoryService categoryService = CategoryService();
  final TransactionService transactionService = TransactionService();
  final ContactService contactService = ContactService();
  final TagService tagService = TagService();
  final SharedPreferencesService preferencesService =
      SharedPreferencesService();
  final BudgetService budgetService = BudgetService();

  final List<Map<String, dynamic>> wallets = [
    {"id": 1, "name": "Demo Cash", "type": WalletType.cash, "balance": 1987.28},
    {"id": 2, "name": "Demo Bank", "type": WalletType.bank, "balance": 4245.0},
    {
      "id": 3,
      "name": "Demo Credit Card",
      "type": WalletType.creditCard,
      "balance": 5000.0,
    },
    {
      "id": 4,
      "name": "Demo E-Wallet",
      "type": WalletType.eWallet,
      "balance": 2800.00,
    },
    {
      "id": 5,
      "name": "Demo Investment",
      "type": WalletType.investment,
      "balance": 3800.0,
    },
    {
      "id": 6,
      "name": "Demo Other",
      "type": WalletType.other,
      "balance": 6000.0,
    },
  ];
  final List<String> tags = [
    'Food',
    'Transportation',
    'Shopping',
    'Bills',
    'Travel',
    'Entertainment',
    'Health',
    'Salary',
    'Investment',
    'Education',
    'Groceries',
    'Gift',
    'Pet',
    'Loan',
  ];

  @override
  Future<void> seed() async {
    await db.truncate();
    await preferencesService.clear();
    Money.setDefaultCurrency = AppStrings.defaultCurrency;
    await CategorySeeder().seed();
    await _seedWallets();
    await _seedTags();
    await _seedContacts();
    await _seedTransactions();
    await walletService.recalculateWalletsBalance();
    await _seedBudgets();
  }

  Future<void> _seedWallets() async {
    final List<TransactionModel> transactionItems = [];
    final List<WalletModel> walletItems = [];

    for (var wallet in wallets) {
      DateTime now = DateTime.now().subtract(Duration(days: 20));
      walletItems.add(
        WalletModel(
          id: wallet['id'],
          name: wallet['name'],
          type: wallet['type'],
          currency: Money.defaultCurrency,
          balance: wallet['balance'],
          isLocked: false,
          isHidden: false,
          createdAt: now,
          updatedAt: now,
        ),
      );
      transactionItems.add(
        TransactionModel(
          id: 0,
          amount: wallet['balance'],
          type: TransactionType.income,
          walletId: wallet['id'],
          currency: Money.defaultCurrency,
          categoryId: 7,
          date: now,
          currencyRate: 1.0,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
    await walletService.insertAll(walletItems);
    await transactionService.insertAll(transactionItems);
  }

  Future<void> _seedTags() async {
    final now = DateTime.now();

    await tagService.insertAll(
      tags.map((name) {
        return TagModel(
          id: 0,
          name: name,
          color: AppStrings
              .knownColors[Random().nextInt(AppStrings.knownColors.length)],
          createdAt: now,
          updatedAt: now,
        );
      }).toList(),
    );
  }

  Future<void> _seedContacts({int count = 50}) async {
    final faker = Faker();
    final now = DateTime.now();

    for (int i = 0; i < count; i++) {
      await contactService.create(
        ContactModel(
          id: 0,
          name: faker.person.name(),
          note: faker.phoneNumber.us(),
          color: ColorUtils.generateRandomColorHex(),
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
  }

  Future<void> _seedTransactions({int count = 300}) async {
    final now = DateTime.now();
    final random = Random();
    final List<TransactionModel> generatedTransactions = [];
    final Map<int, CategoryModel> categories = {};

    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));

    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));

      final incomeCategoryId = random.nextInt(7) + 1;
      final incomeCategory =
          categories[incomeCategoryId] ??
          await categoryService.find(incomeCategoryId);
      if (incomeCategory != null) {
        categories[incomeCategoryId] = incomeCategory;
        generatedTransactions.add(
          _generateTransaction(incomeCategory, date, random),
        );
      }

      final expenseCategoryId = random.nextInt(51) + 8;
      final expenseCategory =
          categories[expenseCategoryId] ??
          await categoryService.find(expenseCategoryId);
      if (expenseCategory != null) {
        categories[expenseCategoryId] = expenseCategory;
        generatedTransactions.add(
          _generateTransaction(expenseCategory, date, random),
        );
      }
    }

    while (generatedTransactions.length < count) {
      final categoryId = random.nextInt(58) + 1;
      final category =
          categories[categoryId] ?? await categoryService.find(categoryId);
      if (category == null) continue;

      categories[categoryId] = category;

      final randomDate = now.subtract(Duration(days: random.nextInt(150)));

      generatedTransactions.add(
        _generateTransaction(category, randomDate, random),
      );
    }

    if (generatedTransactions.isNotEmpty) {
      await transactionService.insertAll(generatedTransactions);
    }
  }

  Future<void> _seedBudgets({int count = 10}) async {
    final now = DateTime.now();
    final random = Random();
    final List<BudgetModel> budgets = [];

    for (int i = 0; i < count; i++) {
      final categoryId = 12 + random.nextInt(20);

      final category = await categoryService.find(categoryId);

      if (category == null) continue;

      final startDate = now.subtract(Duration(days: random.nextInt(150)));
      final endDate = startDate.add(const Duration(days: 30));
      final amount = double.parse(
        (random.nextDouble() * 200 + 50).toStringAsFixed(2),
      );

      budgets.add(
        BudgetModel(
          id: 0,
          name: '${category.name} Budget',
          startDate: startDate,
          endDate: endDate,
          amount: amount,
          categoryId: category.id,
          note: 'Demo budget for ${category.name.toLowerCase()}',
          category: category,
          createdAt: startDate,
          updatedAt: startDate,
        ),
      );
    }

    if (budgets.isNotEmpty) {
      await budgetService.insertAll(budgets);
    }
  }

  TransactionModel _generateTransaction(
    CategoryModel category,
    DateTime date,
    Random random,
  ) {
    final amount = double.parse(
      (random.nextDouble() * (100) + 10).toStringAsFixed(2),
    );
    final walletId = random.nextInt(6) + 1;

    DateTime? startDate;
    DateTime? endDate;
    int? contactId;

    if (category.type == TransactionType.debts) {
      final startOffset = random.nextInt(60) - 30;
      startDate = date.add(Duration(days: startOffset));

      final endOffset = random.nextInt(30) + 1;
      endDate = startDate.add(Duration(days: endOffset));
    }

    if (category.type == TransactionType.debts || random.nextBool()) {
      contactId = random.nextInt(50) + 1;
    }

    return TransactionModel(
      id: 0,
      amount: amount,
      type: category.type,
      walletId: walletId,
      categoryId: category.id,
      currency: Money.defaultCurrency,
      currencyRate: 1.0,
      date: date,
      contactId: contactId,
      startDate: startDate,
      endDate: endDate,
      note: "Auto generated ${category.name.toLowerCase()}",
      createdAt: date,
      updatedAt: date,
    );
  }
}
