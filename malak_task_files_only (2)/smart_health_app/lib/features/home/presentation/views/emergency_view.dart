import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_state_widgets.dart';

class EmergencyNumbersSheet {
  const EmergencyNumbersSheet._();

  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _EmergencyNumbersContent(isSheet: true),
    );
  }
}

/// Full-page version is also registered as a deep link from the Home branch.
class EmergencyNumbersView extends StatelessWidget {
  const EmergencyNumbersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBg,
      appBar: AppBar(
        title: const Text('Emergency Numbers'),
        centerTitle: true,
        backgroundColor: AppColors.neutralBg,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: const _EmergencyNumbersContent(isSheet: false),
    );
  }
}

class _EmergencyNumbersContent extends StatelessWidget {
  const _EmergencyNumbersContent({required this.isSheet});

  final bool isSheet;

  static const _priorityContacts = <_EmergencyContact>[
    _EmergencyContact(
      title: 'Ambulance',
      subtitle: 'Medical emergency and urgent patient transport',
      number: '123',
      icon: Icons.medical_services_outlined,
      color: AppColors.secondary,
    ),
    _EmergencyContact(
      title: 'Emergency Police',
      subtitle: 'Police assistance and urgent safety concerns',
      number: '122',
      icon: Icons.local_police_outlined,
      color: AppColors.primary,
    ),
    _EmergencyContact(
      title: 'Fire & Civil Protection',
      subtitle: 'Fire and civil protection emergencies',
      number: '180',
      icon: Icons.local_fire_department_outlined,
      color: Color(0xFFCB6D2E),
    ),
  ];

  static const _otherContacts = <_EmergencyContact>[
    _EmergencyContact(
      title: 'Tourist Police',
      subtitle: 'Tourist-related assistance',
      number: '126',
      icon: Icons.support_agent_outlined,
      color: AppColors.tertiary,
    ),
    _EmergencyContact(
      title: 'Traffic Police',
      subtitle: 'Road and traffic emergencies',
      number: '128',
      icon: Icons.directions_car_outlined,
      color: AppColors.primary,
    ),
    _EmergencyContact(
      title: 'Electricity Emergency',
      subtitle: 'Electricity fault or outage reporting',
      number: '121',
      icon: Icons.electrical_services_outlined,
      color: AppColors.tertiary,
    ),
    _EmergencyContact(
      title: 'Natural Gas Emergency',
      subtitle: 'Gas leak or gas-related emergency',
      number: '129',
      icon: Icons.local_gas_station_outlined,
      color: Color(0xFFB17A1E),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isSheet ? MediaQuery.sizeOf(context).height * 0.84 : null,
      padding: EdgeInsets.fromLTRB(20, isSheet ? 12 : 8, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.neutralBg,
        borderRadius: isSheet
            ? const BorderRadius.vertical(top: Radius.circular(24))
            : BorderRadius.zero,
      ),
      child: SafeArea(
        top: !isSheet,
        child: Column(
          mainAxisSize: isSheet ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (isSheet) ...[
              Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFBEC9C9),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 18),
            ],
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Emergency Numbers',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (isSheet)
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
              ],
            ),
            const SizedBox(height: 5),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Emergency contacts in Egypt. Tap a number to copy it.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const _EmergencySectionLabel(label: 'URGENT HELP'),
                  ..._priorityContacts.map(
                    (contact) => _EmergencyContactCard(contact: contact),
                  ),
                  const SizedBox(height: 10),
                  const _EmergencySectionLabel(label: 'OTHER SERVICES'),
                  ..._otherContacts.map(
                    (contact) => _EmergencyContactCard(contact: contact),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'For a life-threatening emergency, contact the relevant emergency service directly.',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencySectionLabel extends StatelessWidget {
  const _EmergencySectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9, top: 3),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _EmergencyContact {
  const _EmergencyContact({
    required this.title,
    required this.subtitle,
    required this.number,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String number;
  final IconData icon;
  final Color color;
}

class _EmergencyContactCard extends StatelessWidget {
  const _EmergencyContactCard({required this.contact});

  final _EmergencyContact contact;

  Future<void> _copyNumber(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: contact.number));
    if (context.mounted) {
      AppToast.show(context, '${contact.title} number copied.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: contact.color.withValues(alpha: 0.10),
            child: Icon(contact.icon, color: contact.color, size: 21),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.title,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  contact.subtitle,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                contact.number,
                style: TextStyle(
                  color: contact.color,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () => _copyNumber(context),
                child: const Text(
                  'COPY',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
