import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// The pill-shaped search bar used on Home and Search screens.
/// Pass [onTap] if you want tapping it to navigate to a dedicated
/// Search screen instead of searching inline (common pattern —
/// Home's bar is often just a shortcut into the real Search screen).
class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final bool readOnly;

  const CustomSearchBar({
    super.key,
    this.controller,
    this.hint = 'Search food/restaurant',
    this.onTap,
    this.onSubmitted,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.headerOrange.withOpacity(0.35),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.primaryOrange, width: 1.2),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        onSubmitted: onSubmitted,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.hintText, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(6),
            child: CircleAvatar(
              backgroundColor: AppColors.primaryOrange,
              child: const Icon(Icons.search, color: Colors.white, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}
