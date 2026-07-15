import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../features/categories/presentation/pages/categories_page.dart';
import '../../features/restaurant_details/presentation/pages/restaurants_list_page.dart';
import '../../features/offers/presentation/pages/offers_page.dart';

/// The "All | Restaurants | Categories | Offers" row shown at the
/// top of Home, Restaurants, Categories, and Offers screens.
/// Tapping a tab actually navigates to that screen — this is a
/// shared nav pattern across those 4 pages, not just decoration.
class FilterTabsBar extends StatelessWidget {
  final String selected;

  const FilterTabsBar({super.key, required this.selected});

  static const _tabs = ['All', 'Restaurants', 'Categories', 'Offers'];

  void _handleTap(BuildContext context, String tab) {
    if (tab == selected) return; // already on this screen

    if (tab == 'All') {
      // "All" means Home. Since Home is the app's root after login,
      // pop back to it instead of pushing a new instance.
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    late final Widget page;
    switch (tab) {
      case 'Restaurants':
        page = const RestaurantsListPage();
        break;
      case 'Categories':
        page = const CategoriesPage();
        break;
      case 'Offers':
        page = const OffersPage();
        break;
      default:
        return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _tabs.map((tab) {
        final isActive = tab == selected;
        return GestureDetector(
          onTap: () => _handleTap(context, tab),
          child: Column(
            children: [
              Text(
                tab,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? AppColors.labelText : AppColors.hintText,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 2,
                width: 28,
                color: isActive ? AppColors.labelText : Colors.transparent,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
