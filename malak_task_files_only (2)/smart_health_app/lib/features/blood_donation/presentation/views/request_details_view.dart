import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_state_widgets.dart';

enum RequestDetailsRole { requester, donor }

class RequestDetailsView extends StatelessWidget {
  const RequestDetailsView({
    super.key,
    required this.role,
  });

  final RequestDetailsRole role;

  bool get _isRequester => role == RequestDetailsRole.requester;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBg,
      appBar: AppBar(
        backgroundColor: AppColors.neutralBg,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: true,
        title: Text(_isRequester ? 'My Blood Request' : 'Blood Request Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          _RequestSummaryCard(isRequester: _isRequester),
          const SizedBox(height: 17),
          _DetailsSection(
            title: 'Patient & Request Information',
            children: [
              _DetailRow(label: 'Patient name', value: 'Sarah Jenkins'),
              _DetailRow(label: 'Blood type', value: 'O−'),
              _DetailRow(label: 'Units required', value: '2 units'),
              _DetailRow(label: 'Request date', value: 'Oct 7, 2026'),
              _DetailRow(label: 'Required by', value: 'As soon as possible'),
              _DetailRow(label: 'Request ID', value: 'BR-2026-0108'),
            ],
          ),
          const SizedBox(height: 14),
          _DetailsSection(
            title: 'Hospital Information',
            children: const [
              Text(
                'St. Jude General Hospital',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Emergency Trauma Center • Contact on arrival',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              SizedBox(height: 12),
              _DetailRow(label: 'Location', value: '0.8 km away'),
              _DetailRow(label: 'Contact person', value: 'Hospital reception'),
            ],
          ),
          const SizedBox(height: 14),
          _DetailsSection(
            title: _isRequester ? 'Request Notes' : 'Before You Respond',
            children: [
              Text(
                _isRequester
                    ? 'This is a sample request summary. Keep the hospital team updated if the required units or timing change.'
                    : 'Please confirm your blood type and eligibility with the medical team before donating. The hospital will guide you through the next steps.',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  height: 1.5,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_isRequester)
            _RequesterActions(requestId: 'BR-2026-0108')
          else
            _DonorActions(requestId: 'BR-2026-0108'),
          const SizedBox(height: 10),
          const Text(
            'Demo screen: request information and actions are local UI examples and are not connected to a live donation service.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted, fontSize: 10.5),
          ),
        ],
      ),
    );
  }
}

class _RequestSummaryCard extends StatelessWidget {
  const _RequestSummaryCard({required this.isRequester});

  final bool isRequester;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8BFC3), width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.secondary,
                child: Text(
                  'O−',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2 Units Needed',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      '0.8 km away',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              AppStatusChip.critical(),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: AppColors.neutralBg,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Row(
              children: [
                Icon(Icons.local_hospital_outlined, color: AppColors.primary),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'St. Jude General Hospital',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isRequester) ...[
            const SizedBox(height: 10),
            const Text(
              'Your response can help a patient receive urgent care.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequesterActions extends StatelessWidget {
  const _RequesterActions({required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: () => AppToast.show(
              context,
              'Editing request $requestId is not connected yet.',
            ),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit Request'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton.icon(
            onPressed: () async {
              final confirmed = await AppConfirmDialog.show(
                context: context,
                title: 'Cancel blood request?',
                message: 'Are you sure you want to cancel this request?',
                confirmText: 'Yes, cancel',
                destructive: true,
              );
              if (confirmed && context.mounted) {
                AppToast.show(context, 'Demo: request cancellation confirmed.');
              }
            },
            icon: const Icon(Icons.close),
            label: const Text('Cancel Request'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DonorActions extends StatelessWidget {
  const _DonorActions({required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton.icon(
        onPressed: () async {
          final confirmed = await AppConfirmDialog.show(
            context: context,
            title: 'Respond to blood request?',
            message:
                'Confirm that you are interested in donating O− blood for request $requestId.',
            confirmText: 'I can donate',
          );
          if (confirmed && context.mounted) {
            AppToast.show(context, 'Demo: your donation offer has been recorded.');
          }
        },
        icon: const Icon(Icons.water_drop),
        label: const Text('I Can Donate (O−)'),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
