import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// The "All | Restaurants | Categories | Offers" filter row under
/// the search bar on Home. Purely presentational for now — wire
/// [onChanged] to actually filter the sections below once the real
/// restaurant/category data is connected.
class HomeFilterTabs extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const HomeFilterTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _tabs = ['All', 'Restaurants', 'Categories', 'Offers'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _tabs.map((tab) {
        final isActive = tab == selected;
        return GestureDetector(
          onTap: () => onChanged(tab),
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
