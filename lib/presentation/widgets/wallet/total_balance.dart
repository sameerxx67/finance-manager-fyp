import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class TotalBalance extends StatelessWidget {
  final Money total;

  const TotalBalance({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.tr!.total_balance.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            total.format(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
