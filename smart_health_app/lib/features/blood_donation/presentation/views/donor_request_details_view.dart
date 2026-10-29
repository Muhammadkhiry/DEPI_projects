import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_health_app/core/routing/routes.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';
import 'package:smart_health_app/core/widgets/custom_button.dart';
import 'package:smart_health_app/features/blood_donation/presentation/donor_request_details_cubit/donor_request_details_cubit.dart';
import 'package:smart_health_app/features/blood_donation/presentation/donor_request_details_cubit/donor_request_details_state.dart';
import 'package:smart_health_app/features/blood_donation/presentation/models/request_details_models.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/bottom_action_bar.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/debug_state_switcher.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/info_banner.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/request_summary_card.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/status_pill.dart';

class DonorRequestDetailsView extends StatelessWidget {
  final String requestId;
  const DonorRequestDetailsView({super.key, required this.requestId});

  void _snack(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

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
          'Request Details',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share_outlined,
              color: AppColors.textDark,
              size: 20,
            ),
            onPressed: () => _snack(context, 'Share link copied'),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 18, color: AppColors.white),
            ),
          ),
        ],
      ),
      body: BlocBuilder<DonorRequestDetailsCubit, DonorRequestDetailsState>(
        builder: (context, state) {
          switch (state.status) {
            case DonorRequestStatus.loading:
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            case DonorRequestStatus.failure:
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                   const Text(
                      "Couldn't load this request.",
                      style: AppTextStyles.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      text: 'Retry',
                      width: 160,
                      onPressed: () => context
                          .read<DonorRequestDetailsCubit>()
                          .load(requestId),
                    ),
                  ],
                ),
              );
            case DonorRequestStatus.loaded:
              return Column(
                children: [
                  Expanded(
                    child: _Body(
                      state: state,
                      onSnack: (t) => _snack(context, t),
                    ),
                  ),
                  _BottomBar(state: state, onSnack: (t) => _snack(context, t)),
                ],
              );
          }
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final DonorRequestDetailsState state;
  final ValueChanged<String> onSnack;
  const _Body({required this.state, required this.onSnack});

  @override
  Widget build(BuildContext context) {
    final req = state.request!;
    final cubit = context.read<DonorRequestDetailsCubit>();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (kDebugMode) ...[
          DebugStateSwitcher(
            title: 'DEBUG · Interactive donor simulator',
            labels: const ['Default', 'Offer Sent', 'Accepted by Requester'],
            selected: state.offer.index,
            onSelected: (i) => cubit.debugSetOffer(DonorOfferStatus.values[i]),
          ),
          const SizedBox(height: 12),
        ],

        RequestSummaryCard(
          request: req,
          donorMode: true,
          matchesProfile: state.matchesProfile,
          donorBloodType: state.donorBloodType,
          onDirections: () => onSnack('Opening directions...'),
          onCall: () => onSnack('Calling ${req.phone}...'),
        ),
        const SizedBox(height: 14),

        // Contact details: locked until the requester accepts.
        if (state.offer == DonorOfferStatus.accepted)
          _UnlockedContact(request: req, onSnack: onSnack)
        else
          const InfoBanner(
            icon: Icons.lock_outline,
            color: AppColors.primary,
            title:
                'Contact details are shared only if the requester accepts you.',
            message: 'To protect patient privacy, full direct contact numbers and room coordination details unlock once your offer is accepted by the requester.',
          ),
        const SizedBox(height: 14),

        // Patient + note
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.badge_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Patient: ${req.patientInitials}',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Initials only · Privacy protected',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusPill(text: req.careArea, color: AppColors.tertiary),
                ],
              ),
              if (req.note.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.neutralBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.notes,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Requester Medical Note',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '"${req.note}"',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 12,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),

        const _PrerequisitesCard(),
        const SizedBox(height: 14),
        const _ProtocolCard(),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _UnlockedContact extends StatelessWidget {
  final BloodRequestDetails request;
  final ValueChanged<String> onSnack;
  const _UnlockedContact({required this.request, required this.onSnack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_open, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Offer accepted · Contact unlocked',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _line(Icons.phone_outlined, request.phone),
          const SizedBox(height: 6),
          _line(
            Icons.meeting_room_outlined,
            '${request.ward} · ${request.triagePoint}',
          ),
          const SizedBox(height: 12),
          CustomButton(
            type: ButtonType.outlined,
            text: 'Call coordinator',
            height: 44,
            onPressed: () => onSnack('Calling ${request.phone}...'),
          ),
        ],
      ),
    );
  }

  Widget _line(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 16, color: AppColors.textMuted),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 12,
            color: AppColors.textDark,
          ),
        ),
      ),
    ],
  );
}

class _PrerequisitesCard extends StatelessWidget {
  const _PrerequisitesCard();

  static const _items = [
    'Must be healthy, well-hydrated, and have eaten within 3 hours.',
    'Body weight strictly 50 kg (110 lbs) or above.',
    'At least 3 months since your last whole blood donation.',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Donation Pre-requisites',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          for (final item in _items)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
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

class _ProtocolCard extends StatelessWidget {
  const _ProtocolCard();

  static const _steps = [
    (
      'Volunteer availability',
      'Tap "I can donate" below to notify the requester of your first name and blood match.',
    ),
    (
      'Proceed after manual acceptance',
      'Once approved, head directly to the hospital main blood bank intake desk.',
    ),
    (
      'Physical verification',
      'Hospital staff checks government ID, runs a rapid hemoglobin test, and logs the donation manually.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.directions_walk,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Protocol for In-Person Donors',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < _steps.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == _steps.length - 1 ? 0 : 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: Text(
                      '${i + 1}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _steps[i].$1,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _steps[i].$2,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
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

class _BottomBar extends StatelessWidget {
  final DonorRequestDetailsState state;
  final ValueChanged<String> onSnack;
  const _BottomBar({required this.state, required this.onSnack});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DonorRequestDetailsCubit>();
    final req = state.request!;

    Widget caption(String left, String right, {Color? rightColor}) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12)),
          Text(
            right,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: rightColor ?? AppColors.secondary,
            ),
          ),
        ],
      ),
    );

    Widget content;
    if (!req.isOpen) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          caption(
            'This request is closed',
            'No longer accepting offers',
            rightColor: AppColors.textMuted,
          ),
          CustomButton(
            type: ButtonType.outlined,
            text: 'Back to blood requests',
            onPressed: () => context.go(Routes.bloodDonation),
          ),
        ],
      );
    } else {
      switch (state.offer) {
        case DonorOfferStatus.none:
          content = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              caption('Requires in-person attendance', 'Immediate triage'),
              CustomButton(
                type: ButtonType.secondary,
                text: state.isSubmitting ? 'Sending offer...' : 'I can donate',
                onPressed: state.isSubmitting
                    ? () {}
                    : () async {
                        final error = await cubit.sendOffer();
                        if (!context.mounted) return;
                        onSnack(
                          error ??
                              'Offer sent. The requester has been notified.',
                        );
                      },
              ),
            ],
          );
        case DonorOfferStatus.sent:
          content = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              caption(
                'Offer sent',
                'Waiting for requester',
                rightColor: kAmber,
              ),
              CustomButton(
                type: ButtonType.outlined,
                text: state.isSubmitting ? 'Withdrawing...' : 'Withdraw offer',
                onPressed: state.isSubmitting ? () {} : cubit.withdrawOffer,
              ),
            ],
          );
        case DonorOfferStatus.accepted:
          content = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              caption(
                'Accepted by requester',
                'Head to the triage desk',
                rightColor: AppColors.primary,
              ),
              CustomButton(
                text: 'Get directions',
                onPressed: () => onSnack('Opening directions...'),
              ),
            ],
          );
      }
    }

    return BottomActionBar(child: content);
  }
}
