import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_health_app/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:smart_health_app/features/auth/presentation/auth_cubit/auth_state.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class PersonalInfoView extends StatefulWidget {
  const PersonalInfoView({super.key});

  @override
  State<PersonalInfoView> createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends State<PersonalInfoView> {
  String selectedGender = 'Male';
  final List<String> genderOptions = ['Male', 'Female', 'Prefer not to say'];

  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _dobController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _dobController = TextEditingController();

    // جلب بيانات المستخدم الحالية فور فتح الشاشة
    context.read<AuthCubit>().fetchUserData();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // ميثود اختيار تاريخ الميلاد
  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 1, 1),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBg,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is UserDataLoaded) {
            _fullNameController.text = state.userModel.name ?? '';
            _emailController.text = state.userModel.email;
            _phoneController.text = state.userModel.phoneNumber ?? '';
          } else if (state is ProfileUpdatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Personal info updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Back Arrow & Header Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.textDark,
                            ),
                            onPressed: () {
                              if (context.canPop()) {
                                context.pop();
                              }
                            },
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Personal Info',
                            style: AppTextStyles.headlineMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primary,
                        child: Icon(
                          Icons.person,
                          size: 20,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 2. Avatar & Change Photo Section
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 44,
                              backgroundColor: AppColors.primary,
                              child: Text(
                                _fullNameController.text.isNotEmpty
                                    ? _fullNameController.text
                                          .substring(0, 1)
                                          .toUpperCase()
                                    : 'MK',
                                style: AppTextStyles.headlineLarge.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 14,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Change photo',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'JPG, PNG or WebP · Max 5MB',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. Main Details Form Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Full Name Field
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Full Name',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            Text(
                              'Legal name',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _fullNameController,
                          style: AppTextStyles.bodyLarge,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.neutralBg,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Email Address Disabled Field
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Email Address',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.help_outline,
                                  size: 14,
                                  color: AppColors.textMuted,
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Primary ID',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          enabled: false,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textMuted,
                          ),
                          decoration: InputDecoration(
                            suffixIcon: const Icon(
                              Icons.lock_outline,
                              size: 18,
                              color: AppColors.textMuted,
                            ),
                            filled: true,
                            fillColor: AppColors.neutralBg,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 12,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Managed by Firebase Authentication. Cannot be changed here.',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontSize: 10,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Phone Number Input
                        Text(
                          'Phone Number',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.neutralBg,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child:const Row(
                                children:  [
                                  Text('🇪🇬', style: TextStyle(fontSize: 16)),
                                  SizedBox(width: 4),
                                  Text(
                                    '+20',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 16,
                                    color: AppColors.textMuted,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: AppTextStyles.bodyLarge,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.neutralBg,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Date of Birth Input
                        Text(
                          'Date of Birth',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _dobController,
                          readOnly: true,
                          onTap: _selectDateOfBirth,
                          style: AppTextStyles.bodyLarge,
                          decoration: InputDecoration(
                            suffixIcon: const Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            filled: true,
                            fillColor: AppColors.neutralBg,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Used for dosage calculation and lab ranges',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Gender 2x2 Grid Options
                        Text(
                          'Gender',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 3.2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                          itemCount: genderOptions.length,
                          itemBuilder: (context, index) {
                            final gender = genderOptions[index];
                            final isSelected = selectedGender == gender;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => selectedGender = gender),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.neutralBg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      gender,
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        color: isSelected
                                            ? AppColors.white
                                            : AppColors.textDark,
                                        fontSize: 13,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_circle_outline,
                                        size: 16,
                                        color: AppColors.white,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 4. HIPAA Security Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shield_outlined,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'HIPAA Protected Profile',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Your personal details are encrypted and stored in your private Firestore user profile.',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // 5. Submit Button with Dynamic Loading
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
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<AuthCubit>().updateProfile(
                                name: _fullNameController.text.trim(),
                                phone: _phoneController.text.trim(),
                              );
                            },
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Save Changes',
                              style: AppTextStyles.buttonText.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
