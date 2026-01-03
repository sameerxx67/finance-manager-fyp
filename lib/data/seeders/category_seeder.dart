import 'package:zenthory/zenthory.dart';

import 'seeder.dart';

class CategorySeeder extends Seeder {
  final CategoryService service = CategoryService();

  final List<Map<String, dynamic>> items = [
    {
      "identifier": "salary",
      "name": "Salary",
      "type": TransactionType.income,
      "color": "1e90ff",
    },
    {
      "identifier": "bonuses",
      "name": "Bonuses",
      "type": TransactionType.income,
      "color": "16a085",
    },
    {
      "identifier": "gifts",
      "name": "Gifts",
      "type": TransactionType.income,
      "color": "e67e22",
    },
    {
      "identifier": "sales",
      "name": "Sales",
      "type": TransactionType.income,
      "color": "9b59b6",
    },
    {
      "identifier": "overtime",
      "name": "Overtime",
      "type": TransactionType.income,
      "color": "34495e",
    },
    {
      "identifier": "income_other",
      "name": "Other",
      "type": TransactionType.income,
      "color": "6c5ce7",
    },
    {
      "identifier": "add_balance",
      "name": "Add Balance",
      "type": TransactionType.income,
      "builtIn": true,
      "color": "2ecc71",
    },
    {
      "identifier": "paying_debts_and_installments",
      "name": "Paying debts and installments",
      "description":
          "borrowing a new debt from someone or paying off a debt or installments you owe",
      "type": TransactionType.debts,
      "builtIn": true,
      "color": "2980b9",
    },
    {
      "identifier": "receiving_debts_and_installments",
      "name": "Receiving debts and installments",
      "description":
          "receiving a new debt or collecting a debt or installments from someone.",
      "type": TransactionType.debts,
      "builtIn": true,
      "color": "6c5ce7",
    },
    {
      "identifier": "balance_transfer",
      "name": "Balance transfer",
      "type": TransactionType.expenses,
      "builtIn": true,
      "color": "e84393",
    },
    {
      "identifier": "withdraw_balance",
      "name": "Withdraw balance",
      "type": TransactionType.expenses,
      "builtIn": true,
      "color": "00b894",
    },
    {
      "identifier": "food",
      "name": "Food",
      "type": TransactionType.expenses,
      "color": "eb3b5a",
      "categories": [
        {
          "identifier": "cafes",
          "name": "Cafes",
          "type": TransactionType.expenses,
          "color": "FDA7DF",
        },
        {
          "identifier": "restaurants",
          "name": "Restaurants",
          "type": TransactionType.expenses,
          "color": "0fb9b1",
        },
      ],
    },
    {
      "identifier": "transportation",
      "name": "Transportation",
      "type": TransactionType.expenses,
      "color": "34ace0",
      "categories": [
        {
          "identifier": "gasoline",
          "name": "Gasoline",
          "type": TransactionType.expenses,
          "color": "33d9b2",
        },
        {
          "identifier": "maintenance",
          "name": "Maintenance",
          "type": TransactionType.expenses,
          "color": "ff793f",
        },
        {
          "identifier": "garage",
          "name": "Garage",
          "type": TransactionType.expenses,
          "color": "ff3f34",
        },
        {
          "identifier": "taxis",
          "name": "Taxis",
          "type": TransactionType.expenses,
          "color": "0fbcf9",
        },
      ],
    },
    {
      "identifier": "bills",
      "name": "Bills",
      "type": TransactionType.expenses,
      "color": "f53b57",
      "categories": [
        {
          "identifier": "electricity",
          "name": "Electricity",
          "type": TransactionType.expenses,
          "color": "3c40c6",
        },
        {
          "identifier": "gas",
          "name": "Gas",
          "type": TransactionType.expenses,
          "color": "c44569",
        },
        {
          "identifier": "internet",
          "name": "Internet",
          "type": TransactionType.expenses,
          "color": "f19066",
        },
        {
          "identifier": "telecommunications",
          "name": "Telecommunications",
          "type": TransactionType.expenses,
          "color": "303952",
        },
        {
          "identifier": "rent",
          "name": "Rent",
          "type": TransactionType.expenses,
          "color": "60a3bc",
        },
        {
          "identifier": "tv",
          "name": "TV",
          "type": TransactionType.expenses,
          "color": "b71540",
        },
        {
          "identifier": "water",
          "name": "Water",
          "type": TransactionType.expenses,
          "color": "2d98da",
        },
      ],
    },
    {
      "identifier": "family",
      "name": "Family",
      "type": TransactionType.expenses,
      "color": "A3CB38",
      "categories": [
        {
          "identifier": "children",
          "name": "Children",
          "type": TransactionType.expenses,
          "color": "78e08f",
        },
        {
          "identifier": "home_maintenance",
          "name": "Home Maintenance",
          "type": TransactionType.expenses,
          "color": "22a6b3",
        },
        {
          "identifier": "services",
          "name": "Services",
          "type": TransactionType.expenses,
          "color": "be2edd",
        },
        {
          "identifier": "pets",
          "name": "Pets",
          "type": TransactionType.expenses,
          "color": "4834d4",
        },
      ],
    },
    {
      "identifier": "education",
      "name": "Education",
      "type": TransactionType.expenses,
      "color": "130f40",
      "categories": [
        {
          "identifier": "textbooks",
          "name": "Textbooks",
          "type": TransactionType.expenses,
          "color": "eb4d4b",
        },
        {
          "identifier": "training_courses",
          "name": "Training Courses",
          "type": TransactionType.expenses,
          "color": "6ab04c",
        },
      ],
    },
    {
      "identifier": "investment",
      "name": "Investment",
      "type": TransactionType.expenses,
      "color": "341f97",
    },
    {
      "identifier": "entertainment",
      "name": "Entertainment",
      "type": TransactionType.expenses,
      "color": "c23616",
      "categories": [
        {
          "identifier": "games",
          "name": "Games",
          "type": TransactionType.expenses,
          "color": "0097e6",
        },
        {
          "identifier": "movies_and_audio",
          "name": "Movies and Audio",
          "type": TransactionType.expenses,
          "color": "8c7ae6",
        },
      ],
    },
    {
      "identifier": "fees_and_subscriptions",
      "name": "Fees and Subscriptions",
      "type": TransactionType.expenses,
      "color": "e1b12c",
    },
    {
      "identifier": "donations_and_gifts",
      "name": "Donations and Gifts",
      "type": TransactionType.expenses,
      "color": "44bd32",
      "categories": [
        {
          "identifier": "charity",
          "name": "Charity",
          "type": TransactionType.expenses,
          "color": "40739e",
        },
        {
          "identifier": "zakat",
          "name": "Zakat",
          "type": TransactionType.expenses,
          "color": "f368e0",
        },
        {
          "identifier": "expenses_gifts",
          "name": "Gifts",
          "type": TransactionType.expenses,
          "color": "ff9f43",
        },
      ],
    },
    {
      "identifier": "health_and_fitness",
      "name": "Health and Fitness",
      "type": TransactionType.expenses,
      "color": "ee5253",
      "categories": [
        {
          "identifier": "doctors",
          "name": "Doctors",
          "type": TransactionType.expenses,
          "color": "0abde3",
        },
        {
          "identifier": "medicines",
          "name": "Medicines",
          "type": TransactionType.expenses,
          "color": "10ac84",
        },
        {
          "identifier": "personal_care",
          "name": "Personal Care",
          "type": TransactionType.expenses,
          "color": "01a3a4",
        },
        {
          "identifier": "sports",
          "name": "Sports",
          "type": TransactionType.expenses,
          "color": "2e86de",
        },
      ],
    },
    {
      "identifier": "insurance",
      "name": "Insurance",
      "type": TransactionType.expenses,
      "color": "fa8231",
    },
    {
      "identifier": "shopping",
      "name": "Shopping",
      "type": TransactionType.expenses,
      "color": "20bf6b",
      "categories": [
        {
          "identifier": "accessories",
          "name": "Accessories",
          "type": TransactionType.expenses,
          "color": "8854d0",
        },
        {
          "identifier": "clothing",
          "name": "Clothing",
          "type": TransactionType.expenses,
          "color": "4b6584",
        },
        {
          "identifier": "electronics",
          "name": "Electronics",
          "type": TransactionType.expenses,
          "color": "ccae62",
        },
        {
          "identifier": "shoes",
          "name": "Shoes",
          "type": TransactionType.expenses,
          "color": "cd6133",
        },
      ],
    },
    {
      "identifier": "travel",
      "name": "Travel",
      "type": TransactionType.expenses,
      "color": "05c46b",
    },
    {
      "identifier": "cash_withdrawal",
      "name": "Cash Withdrawal",
      "type": TransactionType.expenses,
      "color": "00d8d6",
    },
    {
      "identifier": "expenses_other",
      "name": "Other",
      "type": TransactionType.expenses,
      "color": "8e44ad",
    },
  ];

  @override
  Future<void> seed() async {
    final now = DateTime.now();
    for (final category in items) {
      final parentId = await _create(category: category, now: now);
      for (final subcategory in (category['categories'] ?? [])) {
        await _create(category: subcategory, parentId: parentId, now: now);
      }
    }
  }

  Future<int> _create({
    required Map<String, dynamic> category,
    int? parentId,
    required DateTime now,
  }) async {
    final CategoryModel? modelCategory = await service.findByName(
      category['name'],
      type: category['type'],
    );
    if (modelCategory == null) {
      return await service.create(
        CategoryModel(
          id: 0,
          identifier: category['identifier'],
          categoryId: parentId,
          name: category['name'],
          description: category['description'],
          type: category['type'],
          icon: "assets/icons/${category['identifier']}.svg",
          color: category['color'],
          builtIn: category['builtIn'] ?? false,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
    return modelCategory.id;
  }
}
