import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_health_app/core/config/app_config.dart';
import 'package:smart_health_app/core/routing/routes.dart';
import 'package:smart_health_app/core/services/service_locator.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';
import 'package:smart_health_app/features/auth/presentation/domain/repos/auth_repo.dart';

void showDeleteAccountDialog(BuildContext context) {
  bool isPasswordObscured = true;
  final TextEditingController passwordController = TextEditingController();
  bool isDeleting = false;
  String? errorText;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: AppColors.white,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. Red Warning Icon Badge
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.secondary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Title & Description
                  Text(
                    'Delete Account?',
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This action is permanent and cannot be undone. All your health records, scheduled appointments, and donor history will be permanently erased.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 12,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // 3. Password Input Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Enter your password to confirm',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordController,
                    enabled: !isDeleting,
                    obscureText: isPasswordObscured,
                    style: AppTextStyles.bodyLarge,
                    decoration: InputDecoration(
                      errorText: errorText,
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        size: 20,
                        color: AppColors.textMuted,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordObscured
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordObscured = !isPasswordObscured;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: AppColors.neutralBg,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.secondary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. Delete Confirm Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: isDeleting
                          ? null
                          : () async {
                              final password = passwordController.text;
                              if (password.isEmpty) {
                                setState(
                                  () => errorText =
                                      'Enter your password to continue',
                                );
                                return;
                              }
                              setState(() {
                                isDeleting = true;
                                errorText = null;
                              });

                              final navigator = Navigator.of(
                                context,
                                rootNavigator: true,
                              );
                              final router = GoRouter.of(context);
                              final result = await getIt<AuthRepo>()
                                  .deleteAccount(password: password);

                              result.fold(
                                (failure) => setState(() {
                                  isDeleting = false;
                                  errorText = failure.errMessage;
                                }),
                                (_) {
                                  if (navigator.mounted && navigator.canPop()) {
                                    navigator.pop(); // close the dialog
                                  }
                                  // The router sends the user to the login
                                  // screen by itself once the account is
                                  // gone. BYPASS_AUTH turns the guards off.
                                  if (AppConfig.bypassAuth) {
                                    router.go(Routes.login);
                                  }
                                },
                              );
                            },
                      child: isDeleting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                          : Text(
                              'Delete account',
                              style: AppTextStyles.buttonText.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 5. Cancel Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.neutralBg,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: isDeleting ? null : () => context.pop(),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}