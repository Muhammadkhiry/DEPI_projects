import 'package:flutter/material.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';

/// Shown for a moment after sign-in while the user's profile is loading, so
/// the router knows whether to open Home or "Complete your profile".
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.neutralBg,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
