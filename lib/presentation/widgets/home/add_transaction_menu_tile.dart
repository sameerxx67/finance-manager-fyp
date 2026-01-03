import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class AddTransactionMenuTile extends StatelessWidget {
  const AddTransactionMenuTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: TransactionType.values.map((TransactionType type) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (_) => TransactionFormCubit()..init(type: type),
                  child: TransactionFormScreen(),
                ),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.265,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                SvgIcon(icon: type.icon, color: type.color),
                SizedBox(height: 10),
                Text(
                  context.tr!.add_with_resource(type.toTrans(context)),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
