import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_health_app/core/config/app_config.dart';
import 'package:smart_health_app/core/constants/app_assets.dart';
import 'package:smart_health_app/core/routing/routes.dart';
import 'package:smart_health_app/core/services/service_locator.dart';
import 'package:smart_health_app/core/utils/app_validators.dart';
import 'package:smart_health_app/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:smart_health_app/features/auth/presentation/auth_cubit/auth_state.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logged in successfully!')),
            );
            context.go(Routes.home);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errMessage),
                backgroundColor: AppColors.secondary,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Scaffold(
            backgroundColor: AppColors.neutralBg,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Smart Health Badge
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SvgPicture.asset(
                              AppAssets.authIcon_1,
                              width: 20,
                              height: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Smart Health',
                            style: AppTextStyles.headlineMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      const Text('Welcome back', style: AppTextStyles.headlineLarge),
                      const SizedBox(height: 6),
                      const Text(
                        'Log in to manage your appointments and records.',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 28),

                      // Email Field with Validation
                      CustomTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        hintText: 'e.g. sarah.jenkins@email.com',
                        validator: AppValidators.validateEmail,
                        suffixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password Field with Validation
                      CustomTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hintText: '••••••••••••',
                        isPassword: isObscure,
                        validator: AppValidators.validatePassword,
                        suffixIcon: IconButton(
                          color: AppColors.textMuted,
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          icon: Icon(
                            isObscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Forgot Password Link
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => context.push(Routes.forgotPassword),
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Submit Button with Loading State
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : CustomButton(
                              text: 'Log in',
                              onPressed: () {
                                // Dev shortcut: --dart-define=BYPASS_AUTH=true
                                if (AppConfig.bypassAuth) {
                                  context.go(Routes.home);
                                  return;
                                }
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthCubit>().login(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                  );
                                }
                              },
                            ),
                      const SizedBox(height: 24),

                      // OR Divider
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: AppColors.border,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: Text(
                              'OR',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              color: AppColors.border,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Google Sign-In Button
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          minimumSize: const Size(double.infinity, 52),
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
                              height: 20,
                              width: 20,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.g_mobiledata,
                                    size: 24,
                                    color: Colors.red,
                                  ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Continue with Google',
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Privacy Notice
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppAssets.lock,
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Your health data stays private to your account.",
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Sign Up Redirect
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: AppTextStyles.bodyMedium,
                          ),
                          GestureDetector(
                            onTap: () => context.push(Routes.signUp),
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
