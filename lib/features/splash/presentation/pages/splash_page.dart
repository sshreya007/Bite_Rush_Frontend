import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Splash screen — fork/knife icon + "BiteRush" logo, centered.
/// Navigates to Welcome/Login after a short delay.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // TODO: replace with your actual route (Welcome or Login)
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Fork/knife icon — swap for the SVG asset from Figma:
            // SvgPicture.asset('assets/icons/fork_knife.svg', height: 120)
            Icon(
              Icons.restaurant_outlined,
              size: 120,
              color: AppColors.splashIcon,
            ),
            const SizedBox(height: 24),
            Text('BiteRush', style: AppTextStyles.logoStyle(fontSize: 44)),
          ],
        ),
      ),
    );
  }
}
