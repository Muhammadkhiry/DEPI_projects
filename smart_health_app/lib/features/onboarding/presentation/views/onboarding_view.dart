import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_health_app/core/constants/app_assets.dart';
import 'package:smart_health_app/core/routing/routes.dart';
import 'package:smart_health_app/core/utils/cache_helper.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';

class OnboardingModel {
  final String title;
  final String description;
  final String imagePath;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingModel> _pages = [
    OnboardingModel(
      title: "Book Top Doctors Easily",
      description: """Find specialists near you and book a visit in 
      a few taps.""",
      imagePath: AppAssets.bookDoc,
    ),
    OnboardingModel(
      title: 'Save Lives by Donating Blood',
      description: '''See open blood requests near you and 
      offer to donate.''',
      imagePath: AppAssets.donatingBlood,
    ),
    OnboardingModel(
      title: 'Scan & Keep Health Records',
      description: '''Scan prescriptions and lab reports and 
      keep them in one private place.''',
      imagePath: AppAssets.scanRecord,
    ),
  ];

  Future<void> _finishOnboarding() async {
    // Must save the flag first: the router sends users back to onboarding
    // until it is set (this is why "Skip" used to do nothing).
    await CacheHelper.saveData(key: 'isOnboardingSeen', value: true);
    if (mounted) {
      context.go(Routes.login);
    }
  }

  Future<void> _onNextPressed() async {
    if (_currentIndex < _pages.length - 1) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await _finishOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // Skip Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Page View Section
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final item = _pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Placeholder for Onboarding Illustration Image
                        Container(
                          height: 260,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            // color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SvgPicture.asset(_pages[index].imagePath),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          item.title,
                          style: AppTextStyles.headlineLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item.description,
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Indicators & Action Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentIndex == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? AppColors.primary
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: _currentIndex == _pages.length - 1
                    ? 'Get Started'
                    : 'Next',
                onPressed: _onNextPressed,
              ),
              const SizedBox(height: 95),
            ],
          ),
        ),
      ),
    );
  }
}
