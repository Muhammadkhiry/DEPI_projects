import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';
import 'package:smart_health_app/core/widgets/custom_button.dart';
import 'package:smart_health_app/core/widgets/custom_text_field.dart';
import 'package:smart_health_app/features/blood_donation/presentation/request_blood_cubit/request_blood_cubit.dart';
import 'package:smart_health_app/features/blood_donation/presentation/request_blood_cubit/request_blood_state.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/bottom_action_bar.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/info_banner.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/step_progress_bar.dart';

class RequestBloodStep2View extends StatefulWidget {
  const RequestBloodStep2View({super.key});

  @override
  State<RequestBloodStep2View> createState() => _RequestBloodStep2ViewState();
}

class _RequestBloodStep2ViewState extends State<RequestBloodStep2View> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _initials;
  late final TextEditingController _hospital;
  late final TextEditingController _ward;
  late final TextEditingController _phone;
  late final TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    final s = context.read<RequestBloodCubit>().state;
    _initials = TextEditingController(text: s.patientInitials);
    _hospital = TextEditingController(text: s.hospitalName);
    _ward = TextEditingController(text: s.ward);
    _phone = TextEditingController(text: s.phone);
    _notes = TextEditingController(text: s.notes);
  }

  @override
  void dispose() {
    _initials.dispose();
    _hospital.dispose();
    _ward.dispose();
    _phone.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _onPost() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<RequestBloodCubit>().submit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RequestBloodCubit>();

    return BlocBuilder<RequestBloodCubit, RequestBloodState>(
      buildWhen: (p, c) =>
          p.status != c.status ||
          p.bloodType != c.bloodType ||
          p.units != c.units ||
          p.hospitalName != c.hospitalName,
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const StepProgressBar(
                        current: 2,
                        title: 'Hospital & Contact Details',
                      ),
                      const SizedBox(height: 16),
                      _SummaryCard(
                        bloodType: state.bloodType ?? '-',
                        units: state.units,
                        onChange: cubit.previousStep,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Patient initials *',
                        hintText: 'e.g. S. J.',
                        controller: _initials,
                        onChanged: cubit.patientInitialsChanged,
                        maxLength: 6,
                        textCapitalization: TextCapitalization.characters,
                        suffixIcon: const Icon(
                          Icons.verified_user_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        validator: (v) {
                          final value = v?.trim() ?? '';
                          if (value.isEmpty) return 'Patient initials required';
                          if (!RegExp(r'^[A-Za-z .]+$').hasMatch(value)) {
                            return 'Use letters only (no full names)';
                          }
                          return null;
                        },
                      ),
                      Text(
                        "Don't enter full names. Protects patient medical privacy.",
                        style: AppTextStyles.bodyMedium.copyWith(fontSize: 11),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Hospital name *',
                        hintText: 'e.g. St. Jude General Hospital',
                        controller: _hospital,
                        onChanged: cubit.hospitalChanged,
                        prefixIcon: const Icon(
                          Icons.local_hospital_outlined,
                          color: AppColors.primary,
                        ),
                        validator: (v) => (v?.trim().isEmpty ?? true)
                            ? 'Hospital name required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Ward or room number (optional)',
                        hintText: 'e.g. ICU Wing B, Room 314',
                        controller: _ward,
                        onChanged: cubit.wardChanged,
                      ),
                      const SizedBox(height: 16),
                      _MapPlaceholder(hospitalName: state.hospitalName),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Contact phone number *',
                        hintText: '+20 (010) 9876-5432',
                        controller: _phone,
                        onChanged: cubit.phoneChanged,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9+\-\s()]'),
                          ),
                        ],
                        prefixIcon: const Icon(
                          Icons.phone_outlined,
                          color: AppColors.primary,
                        ),
                        validator: (v) {
                          final digits = (v ?? '').replaceAll(
                            RegExp(r'[\s\-()]'),
                            '',
                          );
                          if (digits.isEmpty) return 'Phone number required';
                          if (!RegExp(r'^\+?[0-9]{8,15}$').hasMatch(digits)) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Additional notes (optional)',
                        hintText: 'e.g. Contact coordinator at desk.',
                        controller: _notes,
                        onChanged: cubit.notesChanged,
                        maxLines: 3,
                        maxLength: 160,
                      ),
                      const SizedBox(height: 16),
                      const InfoBanner(
                        icon: Icons.public,
                        title: 'Public Community Board',
                        message:
                            'Anyone using Smart Health can view this request on the public board. '
                            'No personal health records or file attachments are stored.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BottomActionBar(
              child: CustomButton(
                type: ButtonType.secondary,
                text: state.isSubmitting ? 'Posting...' : 'Post request',
                onPressed: state.isSubmitting ? () {} : _onPost,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String bloodType;
  final int units;
  final VoidCallback onChange;

  const _SummaryCard({
    required this.bloodType,
    required this.units,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              bloodType,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$units Units Needed',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Whole Blood · Immediate',
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onChange,
            child: Text(
              'Change',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  final String hospitalName;
  const _MapPlaceholder({required this.hospitalName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pick location on map *',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.tertiary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.secondary,
                size: 36,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.place_outlined,
                        size: 16,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          hospitalName.isEmpty
                              ? 'Hospital location'
                              : hospitalName,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      Text(
                        'Change',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
