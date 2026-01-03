import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().updateAllCurrencyRates();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      context.read<HomeCubit>().redirectToLockScreenIfRequired();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<HomeCubit>().redirectToLockScreenIfRequired();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: _blocListener,
      buildWhen: (previous, current) => current.runtimeType == HomeInitial,
      builder: (BuildContext context, HomeState state) {
        if (state is HomeInitial) {
          return Scaffold(
            body: HomePageView(
              key: state.timestamp == null ? null : ValueKey(state.timestamp),
              activeIndex: state.activeIndex,
              refresh: () => context.read<HomeCubit>().onPageChanged(
                index: state.activeIndex,
                force: true,
              ),
              goToTransactions: () =>
                  context.read<HomeCubit>().onPageChanged(index: 1),
            ),
            floatingActionButton: HomeFloatingActionButton(
              refresh: () => context.read<HomeCubit>().onPageChanged(
                index: state.activeIndex,
                force: true,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: HomeBottomNavigationBar(
              activeIndex: state.activeIndex,
              onTap: (int index) =>
                  context.read<HomeCubit>().onPageChanged(index: index),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  void _blocListener(BuildContext context, HomeState state) async {
    if (state is LockedApp && state.locked) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => LockedAppCubit(),
            child: LockedAppScreen(),
          ),
        ),
      );
      if (!context.mounted) return;
      context.read<HomeCubit>().unLocked();
    }
  }
}
