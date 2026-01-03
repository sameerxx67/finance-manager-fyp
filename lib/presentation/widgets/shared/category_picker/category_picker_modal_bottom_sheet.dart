import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class CategoryPickerModalBottomSheet extends StatelessWidget {
  final List<CategoryModel> categories;
  final Function(CategoryModel category) onPicked;

  const CategoryPickerModalBottomSheet({
    super.key,
    required this.onPicked,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      heightFactor: 0.6,
      padding: EdgeInsets.zero,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.56,
          child: ListView.separated(
            padding: EdgeInsets.only(top: 3),
            itemCount: categories.length,
            itemBuilder: (context, index) => CategoryPickerTile(
              category: categories[index],
              onPicked: onPicked,
            ),
            separatorBuilder: (BuildContext context, int index) =>
                ListViewSeparatorDivider(height: 0.6),
          ),
        ),
      ],
    );
  }
}
