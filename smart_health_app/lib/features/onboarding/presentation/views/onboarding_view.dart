import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';

class OnboardingModel {
  final String title;
  final String description;

  OnboardingModel({required this.title, required this.description});
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
      title: 'Easy Doctor Booking',
      description: 'Book appointments with top medical specialists quickly and seamlessly.',
    ),
    OnboardingModel(
      title: 'Blood Donation Network',
      description: 'Connect with nearby donors or request blood urgently whenever needed.',
    ),
    OnboardingModel(
      title: 'Smart Medical Records',
      description: 'Scan, save, and access all your medical prescriptions and reports in one place.',
    ),
  ];

  void _onNextPressed() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
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
                  onPressed: () => context.go('/login'),
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
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
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.health_and_safety_outlined,
                            size: 100,
                            color: AppColors.primary,
                          ),
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
                      color: _currentIndex == index ? AppColors.primary : AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: _currentIndex == _pages.length - 1 ? 'Get Started' : 'Next',
                onPressed: _onNextPressed,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}