import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class LockedAppScreen extends StatefulWidget {
  const LockedAppScreen({super.key});

  @override
  State<LockedAppScreen> createState() => _LockedAppScreenState();
}

class _LockedAppScreenState extends State<LockedAppScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<LockedAppCubit>().unlock(context.tr!.app_locked_description);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: BlocListener<LockedAppCubit, LockedAppState>(
          listener: (context, state) {
            if (state is UnlockedApp) {
              Navigator.pop(context);
            }
          },
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.padding * 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset(
                      AppImages.logo,
                      width: MediaQuery.of(context).size.width * 0.60,
                    ),
                    SizedBox(height: 20),
                    Text(
                      context.tr!.app_locked(context.tr!.app_name),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      context.tr!.app_locked_description,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 0),
                    onPressed: () => context.read<LockedAppCubit>().unlock(
                      context.tr!.app_locked_description,
                    ),
                    child: Text(context.tr!.unlock.toUpperCase()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
