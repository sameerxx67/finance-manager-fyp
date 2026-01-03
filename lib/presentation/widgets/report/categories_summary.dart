import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class CategoriesSummary extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<CategorySummaryModel> categories;
  final String icon;
  final Color? color;

  const CategoriesSummary({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.categories,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SvgIcon(
                icon: icon,
                width: 22,
                color: color ?? context.colors.primary,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(subtitle, style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          if (categories.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                context.tr!.no_data_available,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          if (categories.isNotEmpty)
            ListView.separated(
              itemCount: categories.length,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) =>
                  CategorySummaryTile(category: categories[index]),
              separatorBuilder: (BuildContext context, int index) =>
                  ListViewSeparatorDivider(height: 0.6),
            ),
        ],
      ),
    );
  }
}
