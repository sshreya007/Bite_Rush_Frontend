import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'curved_header_clipper.dart';

/// The orange domed header with the "BiteRush" logo, shared by
/// Login and Signup so the shape/logo styling only lives in one place.
class AuthHeader extends StatelessWidget {
  final double height;

  const AuthHeader({super.key, this.height = 300});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: const CurvedHeaderClipper(),
      child: Container(
        height: height,
        width: double.infinity,
        color: AppColors.headerOrange,
        alignment: const Alignment(0, -0.2),
        child: Text(
          'BiteRush',
          style: AppTextStyles.logoStyle(fontSize: 40, color: AppColors.logoBrown),
        ),
      ),
    );
  }
}
