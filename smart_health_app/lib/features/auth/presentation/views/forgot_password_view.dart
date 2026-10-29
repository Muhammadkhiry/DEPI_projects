import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_health_app/core/routing/routes.dart';
import 'package:smart_health_app/core/services/service_locator.dart';
import 'package:smart_health_app/core/utils/app_validators.dart';
import 'package:smart_health_app/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:smart_health_app/features/auth/presentation/auth_cubit/auth_state.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();

  late final AuthCubit _authCubit = getIt<AuthCubit>();
  StreamSubscription<AuthState>? _authSubscription;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authSubscription = _authCubit.stream.listen((state) {
      if (!mounted) return;
      setState(() => _isLoading = state is AuthLoading);
      if (state is AuthFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errMessage),
            backgroundColor: AppColors.secondary,
          ),
        );
      } else if (state is AuthSuccess) {
        // Pass the email along so the next screen can show it.
        context.push(Routes.resetSent, extra: _emailController.text.trim());
      }
    });
  }

  @override
  void dispose() {
    unawaited(_authSubscription?.cancel());
    unawaited(_authCubit.close());
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _emailController.text.trim();
    final error = AppValidators.validateEmail(email);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    _authCubit.sendPasswordReset(email: email);
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
              const SizedBox(height: 20),

              // 2. Lock & Shield Circular Badge
              Center(
                child: SvgPicture.asset(
                  "assets/auth/forgot_icon.svg",
                  width: 125,
                  height: 125,
                ),
              ),
              const SizedBox(height: 28),

              // 3. Title & Subtitle
              Text(
                'Forgot password?',
                style: AppTextStyles.headlineLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Padding(
                padding:  EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Enter the email associated with your account and we'll send you a secure link to reset your password.",
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),

              // 4. White Form Card Box
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email Address',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      style: AppTextStyles.bodyLarge,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColors.textMuted,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.cancel_outlined,
                            color: AppColors.textMuted,
                            size: 18,
                          ),
                          onPressed: () => _emailController.clear(),
                        ),
                        filled: true,
                        fillColor: AppColors.neutralBg,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Submit Button inside Card
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
                        onPressed: _isLoading ? null : _submit,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Send reset link',
                              style: AppTextStyles.buttonText.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.send_rounded,
                              size: 18,
                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 5. Back to Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Remember your password? ',
                    style: AppTextStyles.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () => context.go(Routes.login),
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // 6. Security Footer Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Stored securely in your private account.',
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
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
