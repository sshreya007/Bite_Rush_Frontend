import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// The peach bottom nav bar with Home / Menu / Cart / Profile icons.
/// Shared across every screen that shows bottom navigation, so the
/// active-tab styling only lives in one place.
///
/// Uses your own icon images from assets/icons/ (exported from
/// Figma) rather than built-in Material icons, since the design
/// uses custom flat-illustration style icons.
///
/// Usage: wrap your Scaffold's bottomNavigationBar with this,
/// passing which index is currently active.
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // Drop your exported PNG/SVG files at these exact paths, or edit
  // the paths below to match whatever you name/place them.
  static const _iconPaths = [
    'assets/icons/nav_home.png',
    'assets/icons/nav_menu.png',
    'assets/icons/nav_cart.png',
    'assets/icons/nav_profile.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: AppColors.headerOrange,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_iconPaths.length, (index) {
          final isActive = index == currentIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              child: Image.asset(
                _iconPaths[index],
                width: 30,
                height: 30,
                // Dims inactive icons slightly so the active one
                // stands out. Remove this if your icon set already
                // has separate active/inactive art from Figma.
                opacity: isActive
                    ? const AlwaysStoppedAnimation(1.0)
                    : const AlwaysStoppedAnimation(0.55),
                errorBuilder: (context, error, stackTrace) {
                  // Shows a placeholder icon instead of crashing
                  // if you haven't added the asset file yet.
                  return Icon(
                    Icons.circle,
                    size: 24,
                    color: isActive
                        ? AppColors.primaryOrange
                        : AppColors.logoBrown,
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}
