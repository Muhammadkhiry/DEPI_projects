import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
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

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final AuthCubit _authCubit = getIt<AuthCubit>();
  StreamSubscription<AuthState>? _authSubscription;
  bool _isLoading = false;

  bool isObscurePassword = true;
  bool isObscureConfirmPassword = true;
  bool isAgreed = false;

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
        // New account is signed in but not verified yet. The router also
        // redirects here; this covers BYPASS_AUTH mode.
        context.go(Routes.verifyEmail);
      }
    });
  }

  @override
  void dispose() {
    unawaited(_authSubscription?.cancel());
    unawaited(_authCubit.close());
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms of Service to continue.'),
        ),
      );
      return;
    }
    _authCubit.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Smart Health Header Badge
              Row(
                children: [
                  SvgPicture.asset(AppAssets.authIcon_2, width: 20, height: 20),
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

              // 2. Headings
              const Text('Create your account', style: AppTextStyles.headlineLarge),
              const SizedBox(height: 6),
              const Text(
                'Join Smart Health to manage appointments and records.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 28),

              // 3. Full Name
              CustomTextField(
                controller: _nameController,
                label: 'Full Name',
                hintText: 'e.g. Sarah Jenkins',
                validator: AppValidators.validateName,
              ),
              const SizedBox(height: 16),

              // 4. Email Address
              CustomTextField(
                controller: _emailController,
                label: 'Email Address',
                hintText: 'e.g. sarah.jenkins@email.com',
                validator: AppValidators.validateEmail,
              ),
              const SizedBox(height: 16),

              // 5. Phone Number with Country Code (Badge & Field)
              Text(
                'Phone Number',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Country Code Badge
                  Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // علم مصر كرمز أو SVG (يمكن استبداله بـ Asset لو متوفر)
                        const Text('🇪🇬', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 6),
                        Text(
                          '+20',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Phone input field
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      style: AppTextStyles.bodyLarge,
                      decoration: InputDecoration(
                        hintText: '102 345 6789',
                        hintStyle: AppTextStyles.bodyMedium,
                        filled: true,
                        fillColor: AppColors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
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
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 6. Password with Security Rating
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                hintText: 'Create a strong password',
                validator: AppValidators.validatePassword,
                isPassword: isObscurePassword,
                suffixIcon: IconButton(
                  color: AppColors.textMuted,
                  onPressed: () {
                    setState(() {
                      isObscurePassword = !isObscurePassword;
                    });
                  },
                  icon: Icon(
                    isObscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Security Rating Indicators
              Row(
                children: [
                  ...List.generate(
                    3,
                    (index) => Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(right: index < 2 ? 6.0 : 0),
                        decoration: BoxDecoration(
                          color: AppColors
                              .border, // تتغير ألوانها بناء على القوة لاحقاً
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Empty',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 7. Confirm Password
              CustomTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                hintText: 'Re-enter your password',
                validator: (value) => value != _passwordController.text
                    ? 'Passwords do not match'
                    : null,
                isPassword: isObscureConfirmPassword,
                suffixIcon: IconButton(
                  color: AppColors.textMuted,
                  onPressed: () {
                    setState(() {
                      isObscureConfirmPassword = !isObscureConfirmPassword;
                    });
                  },
                  icon: Icon(
                    isObscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 8. Terms Checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      value: isAgreed,
                      onChanged: (val) {
                        setState(() {
                          isAgreed = val ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
                        children: [
                          const TextSpan(text: 'I agree to the '),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: GestureDetector(
                              onTap: () => context.push(Routes.publicTerms),
                              child: const Text(
                                'Terms of Service',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: GestureDetector(
                              onTap: () {}, // Privacy policy route later
                              child: const Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 9. Sign Up button
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(text: 'Sign up', onPressed: _submit),
              const SizedBox(height: 24),

              // 10. OR Divider
              Row(
                children: [
                  const Expanded(
                    child: Divider(color: AppColors.border, thickness: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                    child: Divider(color: AppColors.border, thickness: 1),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 11. Google Button
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
                      errorBuilder: (context, error, stackTrace) => const Icon(
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

              // 12. Redirect to Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: AppTextStyles.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.go(Routes.login),
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
              const SizedBox(height: 24),

              // 13. Secure footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppAssets.lock, width: 16, height: 16),
                  const SizedBox(width: 8),
                  Text(
                    "Stored securely in your private account.",
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
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
  }
}
