import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  final int activeIndex;
  final Function(int) onTap;
  final List<String> icons;

  const HomeBottomNavigationBar({
    super.key,
    required this.activeIndex,
    required this.onTap,
    this.icons = const [
      AppIcons.home,
      AppIcons.transaction,
      AppIcons.report,
      AppIcons.settings,
    ],
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar.builder(
      itemCount: icons.length,
      backgroundColor: context.colors.bottomNavigationBar,
      splashColor: context.colors.splashColor.withValues(alpha: 0.1),
      tabBuilder: (int index, bool isActive) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: SvgIcon(
            icon: icons[index],
            color: isActive
                ? context.colors.primary
                : context.colors.textPrimary,
          ),
        );
      },
      activeIndex: activeIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.verySmoothEdge,
      leftCornerRadius: 32,
      rightCornerRadius: 32,
      onTap: onTap,
    );
  }
}
