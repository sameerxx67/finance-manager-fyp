import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class MenuModalBottomSheet extends StatelessWidget {
  final GestureTapCallback refresh;

  const MenuModalBottomSheet({super.key, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 95),
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: TransactionType.values.map((TransactionType type) {
                    return MenuTile(
                      title: context.tr!.add_with_resource(
                        type.toTrans(context),
                      ),
                      subtitle: type.toDescriptionTrans(context),
                      icon: type.icon,
                      iconColor: type.color,
                      hasDivider: type != TransactionType.debts,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (_) =>
                                  TransactionFormCubit()..init(type: type),
                              child: TransactionFormScreen(),
                            ),
                          ),
                        );
                        if (result != null && result['refresh']) {
                          refresh();
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            Positioned(
              bottom: 28,
              left: MediaQuery.of(context).size.width / 2 - 28,
              child: CustomFloatingActionButton(
                onPressed: () => Navigator.pop(context),
                iconData: Icons.close_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
