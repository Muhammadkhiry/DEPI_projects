import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_health_app/core/routing/routes.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';
import 'package:smart_health_app/core/widgets/custom_button.dart';
import 'package:smart_health_app/features/blood_donation/presentation/models/request_details_mock.dart';
import 'package:smart_health_app/features/blood_donation/presentation/models/request_details_models.dart';
import 'package:smart_health_app/features/blood_donation/presentation/request_details_cubit/request_details_cubit.dart';
import 'package:smart_health_app/features/blood_donation/presentation/request_details_cubit/request_details_state.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/debug_state_switcher.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/info_banner.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/request_summary_card.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/response_card.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/status_log_timeline.dart';
import 'package:smart_health_app/features/blood_donation/presentation/widgets/status_pill.dart';

class RequesterRequestDetailsView extends StatelessWidget {
  final String requestId;
  const RequesterRequestDetailsView({super.key, required this.requestId});

  void _snack(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _confirmCancel(BuildContext context) async {
    final cubit = context.read<RequestDetailsCubit>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel this request?'),
        content: const Text(
          'Cancelling immediately frees committed donors for other clinical emergencies. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep request'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Cancel request',
              style: TextStyle(color: AppColors.secondary),
            ),
          ),
        ],
      ),
    );
    if (ok == true) cubit.cancelRequest();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestDetailsCubit, RequestDetailsState>(
      listenWhen: (p, c) => !p.isCancelled && c.isCancelled,
      listener: (context, state) {
        _snack(context, 'Request cancelled');
        context.go(Routes.bloodDonation);
      },
      builder: (context, state) {
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
                // TODO: share_plus
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
          body: switch (state.status) {
            RequestDetailsStatus.loading => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            RequestDetailsStatus.failure => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Couldn't load this request.",
                    style: AppTextStyles.bodyLarge,
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Retry',
                    width: 160,
                    onPressed: () =>
                        context.read<RequestDetailsCubit>().load(requestId),
                  ),
                ],
              ),
            ),
            RequestDetailsStatus.loaded => _Body(
              state: state,
              onSnack: (t) => _snack(context, t),
              onCancel: () => _confirmCancel(context),
            ),
          },
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  final RequestDetailsState state;
  final ValueChanged<String> onSnack;
  final VoidCallback onCancel;

  const _Body({
    required this.state,
    required this.onSnack,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RequestDetailsCubit>();
    final req = state.request!;
    final canAct = req.isOpen;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (kDebugMode) ...[
          DebugStateSwitcher(
            title: 'DEBUG · Preview state',
            labels: const ['Default', 'No Responses', 'Expired'],
            selected: state.preview.index,
            onSelected: (i) => cubit.debugPreview(RequestPreview.values[i]),
          ),
          const SizedBox(height: 12),
        ],

        RequestSummaryCard(
          request: req,
          // TODO: url_launcher (maps / tel:)
          onDirections: () => onSnack('Opening directions...'),
          onCall: () => onSnack('Calling ${req.phone}...'),
        ),
        const SizedBox(height: 12),

        if (req.status == RequestStatus.fulfilled)
          const InfoBanner(
            icon: Icons.check_circle_outline,
            color: AppColors.primary,
            title: 'Request fulfilled',
            message: 'All required units have been secured. Thank you!',
          )
        else if (req.isExpired)
          const InfoBanner(
            icon: Icons.timer_off_outlined,
            color: AppColors.textMuted,
            title: 'Request expired',
            message: 'This request is closed to new offers. You can post a new request if blood is still needed.',
          )
        else
          const InfoBanner(
            icon: Icons.verified_user_outlined,
            color: AppColors.primary,
            title: 'Manual Verification Protocol',
            message: 'Statuses are recorded manually by requesters and donors. Verify donor identity and coordinate in person upon arrival at the hospital donor triage desk.',
          ),
        const SizedBox(height: 22),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Responses (${state.responses.length})',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            StatusPill(
              text: '${req.unitsSecured} of ${req.units} Complete',
              color: AppColors.primary,
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          'Donors who stepped forward',
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
        ),
        const SizedBox(height: 10),
        if (state.responses.isEmpty)
          _NoResponses(
            canAct: canAct,
            onShare: () => onSnack('Share link copied'),
          )
        else
          ...state.responses.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ResponseCard(
                response: r,
                canAct: canAct,
                onAccept: () {
                  final error = cubit.acceptResponse(r.id);
                  if (error != null) onSnack(error);
                },
                onDecline: () => cubit.declineResponse(r.id),
                onMarkDonated: () => cubit.markDonated(r.id),
              ),
            ),
          ),
        const SizedBox(height: 14),

        Text(
          'Status Log',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Manual audit trail of verified updates',
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
        ),
        const SizedBox(height: 10),
        StatusLogTimeline(entries: state.log),
        const SizedBox(height: 20),

        if (canAct) ...[
          OutlinedButton.icon(
            onPressed: state.isCancelling ? null : onCancel,
            icon: const Icon(Icons.cancel_outlined, size: 18),
            label: Text(
              state.isCancelling ? 'Cancelling...' : 'Cancel Blood Request',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.secondary,
              side: const BorderSide(color: AppColors.secondary),
              minimumSize: const Size.fromHeight(52),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cancelling immediately frees committed donors for other clinical emergencies.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(fontSize: 11),
          ),
        ] else if (req.isExpired)
          CustomButton(
            type: ButtonType.secondary,
            text: 'Post a new request',
            onPressed: () =>
                context.push('${Routes.bloodDonation}/${Routes.requestBlood}'),
          ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _NoResponses extends StatelessWidget {
  final bool canAct;
  final VoidCallback onShare;
  const _NoResponses({required this.canAct, required this.onShare});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.hourglass_empty,
            size: 36,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 10),
          Text(
            'No responses yet',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            canAct
                ? 'Donors who offer to help will appear here. Sharing the request directly helps find matches faster.'
                : 'No donors responded before this request closed.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
          ),
          if (canAct) ...[
            const SizedBox(height: 14),
            CustomButton(
              type: ButtonType.outlined,
              text: 'Share request',
              width: 180,
              onPressed: onShare,
            ),
          ],
        ],
      ),
    );
  }
}
