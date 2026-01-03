import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class TagsSummary extends StatelessWidget {
  final List<TagSummaryModel> tags;

  const TagsSummary({super.key, required this.tags});

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
                icon: AppIcons.tags,
                width: 22,
                color: context.colors.primary,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr!.top_tags,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      context.tr!.top_tags_subtitle,
                      style: TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          if (tags.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                context.tr!.no_data_available,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          if (tags.isNotEmpty)
            ListView.separated(
              itemCount: tags.length,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) => TagSummaryTile(tag: tags[index]),
              separatorBuilder: (BuildContext context, int index) =>
                  ListViewSeparatorDivider(height: 0.6),
            ),
        ],
      ),
    );
  }
}
