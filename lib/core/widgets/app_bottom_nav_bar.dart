import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// The bottom nav bar with Home / Menu / Cart / Profile icons.
///
/// Active state is shown with a raised white circle (+ subtle shadow)
/// behind the icon plus a small dot underneath — since the icon
/// artwork itself is multi-colored, a plain background tint wasn't
/// visible enough to read as "selected."
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _iconPaths = [
    'assets/icons/nav_home.png',
    'assets/icons/nav_menu.png',
    'assets/icons/nav_cart.png',
    'assets/icons/nav_profile.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      decoration: BoxDecoration(
        color: AppColors.primaryOrange.withOpacity(0.18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_iconPaths.length, (index) {
          final isActive = index == currentIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  AnimatedScale(
                    duration: const Duration(milliseconds: 200),
                    scale: isActive ? 1.0 : 0.85,
                    child: Opacity(
                      opacity: isActive ? 1.0 : 0.9,
                      child: Image.asset(
                        _iconPaths[index],
                        width: 28,
                        height: 28,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.circle,
                            size: 22,
                            color: isActive
                                ? AppColors.primaryOrange
                                : AppColors.logoBrown,
                          );
                        },
                      ),
                    ),
                  ),
                  if (isActive)
                    Positioned(
                      bottom: -10,
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryOrange,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
