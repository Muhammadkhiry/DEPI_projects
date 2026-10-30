import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_health_app/core/config/app_config.dart';
import 'package:smart_health_app/core/routing/routes.dart';
import 'package:smart_health_app/core/services/auth_session.dart';
import 'package:smart_health_app/core/services/service_locator.dart';
import 'package:smart_health_app/features/auth/presentation/domain/repos/auth_repo.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class VerifyEmailView extends StatefulWidget {
  /// Optional override. By default the signed-in user's email is shown.
  final String? email;

  const VerifyEmailView({super.key, this.email});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  static const int _resendCooldownSeconds = 60;

  Timer? _pollTimer;
  Timer? _cooldownTimer;
  int _secondsLeft = 0;

  @override
  void initState() {
    super.initState();
    // Check every 3 seconds so the screen moves on by itself once the user
    // has tapped the link in the email.
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      final verified = await getIt<AuthSession>().refreshEmailVerified();
      if (verified && mounted) {
        _pollTimer?.cancel();
        context.go(Routes.completeProfile);
      }
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _secondsLeft = _resendCooldownSeconds);
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) timer.cancel();
    });
  }

  Future<void> _resend() async {
    final error = await getIt<AuthSession>().sendVerificationEmail();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error ?? 'Verification email sent again!')),
    );
    if (error == null) _startCooldown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Back Arrow Button
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
                ),
              ),
              const SizedBox(height: 30),

              // 2. Circle Animated / Mail Icon Badge
              SvgPicture.asset(
                "assets/auth/verify_icon.svg",
                width: 125,
                height: 125,
              ),
              const SizedBox(height: 32),

              // 3. Title & Subtitle
              Text(
                'Check your inbox',
                style: AppTextStyles.headlineLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Padding(
                padding:  EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'Tap the link we sent, then come back here to continue setting up your account.',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),

              // 4. User Email Chip Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.mark_email_unread,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.email ?? getIt<AuthSession>().email ?? '',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Colors.tealAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // 5. Action Buttons
              // Primary Button with Arrow Icon
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final verified = await getIt<AuthSession>()
                        .refreshEmailVerified();
                    if (!context.mounted) return;

                    if (verified || AppConfig.bypassAuth) {
                      context.go(Routes.completeProfile);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please verify your email first.'),
                        ),
                      );
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "I've verified my email",
                        style: AppTextStyles.buttonText,
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        size: 20,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Resend Secondary Button
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                  minimumSize: const Size(double.infinity, 52),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: _secondsLeft > 0 ? null : _resend,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.refresh,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _secondsLeft > 0
                          ? 'Resend in ${_secondsLeft}s'
                          : 'Resend email',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Change Email Text Link
              GestureDetector(
                onTap: () async {
                  // The unverified account is signed out so a different email
                  // can be used. Capture the router first: this screen is
                  // disposed as soon as the router redirects.
                  final router = GoRouter.of(context);
                  await getIt<AuthRepo>().logout();
                  router.go(Routes.signUp);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Change email address',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 6. Private & HIPAA Security Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        size: 20,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Private & HIPAA-Conscious',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Stored securely in your private account.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.verified_outlined,
                      size: 20,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
