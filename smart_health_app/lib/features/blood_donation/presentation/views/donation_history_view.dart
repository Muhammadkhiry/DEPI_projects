import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_health_app/core/routing/routes.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';
import 'package:smart_health_app/core/widgets/custom_button.dart';
import 'package:smart_health_app/core/widgets/custom_text_field.dart';
import 'package:smart_health_app/features/blood_donation/presentation/donation_history_cubit/donation_history_cubit.dart';
import 'package:smart_health_app/features/blood_donation/presentation/donation_history_cubit/donation_history_state.dart';
import 'package:smart_health_app/features/blood_donation/presentation/models/donor_models.dart';
import 'package:smart_health_app/features/blood_donation/presentation/utils/date_formatter.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/donation_record_card.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/info_banner.dart';

/// Donation History. Needs a DonationHistoryCubit above it (call load()
/// when creating it in the router).
class DonationHistoryView extends StatelessWidget {
  const DonationHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBg,
      appBar: AppBar(
        backgroundColor: AppColors.neutralBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go(Routes.bloodDonation),
        ),
        title: Text(
          'Donation History',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 18),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 18, color: AppColors.white),
            ),
          ),
        ],
      ),
      body: BlocBuilder<DonationHistoryCubit, DonationHistoryState>(
        builder: (context, state) {
          switch (state.status) {
            case DonationHistoryStatus.loading:
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            case DonationHistoryStatus.failure:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Couldn't load your donations.",
                        style: AppTextStyles.bodyLarge,
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        text: 'Retry',
                        width: 160,
                        onPressed: () =>
                            context.read<DonationHistoryCubit>().load(),
                      ),
                    ],
                  ),
                ),
              );
            case DonationHistoryStatus.loaded:
              return _Loaded(state: state);
          }
        },
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  final DonationHistoryState state;
  const _Loaded({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.verified_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Certified Donor Record',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PDF export coming soon')),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
                label: const Text('Export PDF'),
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _ProfileHeader(state: state),
          const SizedBox(height: 14),
          _StatsRow(state: state),
          const SizedBox(height: 14),
          if (state.records.isNotEmpty) _NextEligibleCard(state: state),
          const SizedBox(height: 14),
          CustomButton(
            type: ButtonType.primary,
            text: '+ Add donation',
            onPressed: () => _showAddSheet(context),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Past Donations',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Text(
                'Most Recent',
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (state.records.isEmpty)
            const _EmptyState()
          else
            ...state.records.map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: DonationRecordCard(record: r),
              ),
            ),
          const SizedBox(height: 6),
          const InfoBanner(
            icon: Icons.info_outline,
            color: AppColors.tertiary,
            title: 'Whole Blood Recovery Protocol',
            message: 'Minimum 84 days (12 weeks) between whole blood donations to ensure adequate iron stores and complete hemoglobin replenishment before subsequent draws.',
          ),
        ],
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    final cubit = context.read<DonationHistoryCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutralBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _AddDonationSheet(cubit: cubit),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final DonationHistoryState state;
  const _ProfileHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.neutralBg,
            child: Text(
              state.initials,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.donorName,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isUniversalRedCellDonor(state.bloodType)
                        ? '${state.bloodType} Universal Donor'
                        : '${state.bloodType} Donor',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.water_drop,
              color: AppColors.secondary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final DonationHistoryState state;
  const _StatsRow({required this.state});

  @override
  Widget build(BuildContext context) {
    Widget tile(String value, String label) => Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );

    return Row(
      children: [
        tile('${state.totalDonations}', 'Whole Blood\nDonations'),
        const SizedBox(width: 10),
        tile('${state.totalMl}', 'Milliliters\nDonated'),
        const SizedBox(width: 10),
        tile('${state.livesImpacted}', 'Potential Lives\nImpacted'),
      ],
    );
  }
}

class _NextEligibleCard extends StatelessWidget {
  final DonationHistoryState state;
  const _NextEligibleCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final days = state.daysUntilEligible;
    final canDonate = days <= 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.event_available, color: AppColors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  canDonate
                      ? 'You can donate now'
                      : 'Next eligible date: ${DateFormatter.short(state.nextEligibleDate!)}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  canDonate
                      ? 'Your 84-day recovery window has passed.'
                      : '$days days until next eligible whole blood donation window.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.water_drop_outlined,
            size: 40,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 10),
          Text(
            'No donations yet',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your confirmed and self-reported donations will appear here.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _AddDonationSheet extends StatefulWidget {
  final DonationHistoryCubit cubit;
  const _AddDonationSheet({required this.cubit});

  @override
  State<_AddDonationSheet> createState() => _AddDonationSheetState();
}

class _AddDonationSheetState extends State<_AddDonationSheet> {
  final _location = TextEditingController();
  DateTime? _date;
  bool _showError = false;

  @override
  void dispose() {
    _location.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: now,
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _save() {
    if (_date == null) {
      setState(() => _showError = true);
      return;
    }
    widget.cubit.addSelfReported(date: _date!, location: _location.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add past donation', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 4),
          Text(
            'It will be marked "Self-reported" until a facility confirms it.',
            style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 16),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _showError && _date == null
                      ? Colors.red
                      : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _date == null
                        ? 'Select donation date *'
                        : DateFormatter.long(_date!),
                    style: AppTextStyles.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          CustomTextField(
            label: 'Location (optional)',
            hintText: 'e.g. Red Crescent Mobile Blood Drive',
            controller: _location,
          ),
          const SizedBox(height: 18),
          CustomButton(text: 'Save donation', onPressed: _save),
        ],
      ),
    );
  }
}
