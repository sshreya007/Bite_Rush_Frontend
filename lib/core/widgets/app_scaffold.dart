import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'app_bottom_nav_bar.dart';
import '../../features/restaurant_details/presentation/pages/restaurants_list_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';

/// Wraps a page's body with the app's persistent bottom nav bar and
/// centralizes what each icon does, so individual pages don't each
/// re-implement the same _navIndex/_onNavTap boilerplate.
///
/// Usage: return AppScaffold(currentIndex: 0, body: yourContent);
///
/// currentIndex meaning:
///   0 = Home        1 = Menu (Restaurants)
///   2 = Cart         3 = Profile
/// Pass -1 if this screen isn't one of the 4 primary destinations
/// (e.g. Categories, Offers, Category Items, Restaurant Menu) —
/// none of the icons will show as active, which matches the Figma
/// design for those "drill-down" screens.
class AppScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    this.backgroundColor,
  });

  void _handleNavTap(BuildContext context, int index) {
    if (index == currentIndex) return; // already there

    if (index == 0) {
      // Home is the app's root after login — pop back to it rather
      // than pushing a new instance on top.
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const RestaurantsListPage()));
      return;
    }

    if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()));
      return;
    }

    // TODO: index == 3 -> Profile page, once built. Wire it here.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      body: body,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => _handleNavTap(context, index),
      ),
    );
  }
}
