import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_search_input.dart';
import 'app_state_widgets.dart';
import 'custom_button.dart';

/// A visual reference page for the shared states used across the app.
class SharedWidgetsStatesSheet extends StatefulWidget {
  const SharedWidgetsStatesSheet({super.key});

  @override
  State<SharedWidgetsStatesSheet> createState() =>
      _SharedWidgetsStatesSheetState();
}

class _SharedWidgetsStatesSheetState extends State<SharedWidgetsStatesSheet> {
  String _selectedBloodType = 'O−';
  String _selectedFilter = 'All Doctors';

  static const _bloodTypes = ['A+', 'A−', 'B+', 'B−', 'AB+', 'AB−', 'O+', 'O−'];
  static const _filters = [
    'All Doctors',
    'Cardiology',
    'Neurology',
    'Pediatrics',
    'Dermatology',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBg,
      appBar: AppBar(title: const Text('Shared Widgets & States')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
        children: [
          _SheetSection(
            title: '01. SEARCH COMPONENT',
            child: const AppSearchInput(),
          ),
          _SheetSection(
            title: '02. FILTER CHIPS',
            child: Wrap(
              spacing: 8,
              runSpacing: 2,
              children: _filters
                  .map(
                    (filter) => AppFilterChip(
                      label: filter,
                      selected: _selectedFilter == filter,
                      onTap: () => setState(() => _selectedFilter = filter),
                    ),
                  )
                  .toList(),
            ),
          ),
          _SheetSection(
            title: '03. BLOOD TYPE CHIPS',
            child: Wrap(
              spacing: 8,
              runSpacing: 2,
              children: _bloodTypes
                  .map(
                    (type) => BloodTypeChip(
                      bloodType: type,
                      selected: _selectedBloodType == type,
                      onTap: () => setState(() => _selectedBloodType = type),
                    ),
                  )
                  .toList(),
            ),
          ),
          _SheetSection(
            title: '04. STATUS CHIPS',
            child: Wrap(
              spacing: 7,
              runSpacing: 8,
              children: [
                AppStatusChip.upcoming(),
                AppStatusChip.completed(),
                AppStatusChip.cancelled(),
                AppStatusChip.critical(),
                AppStatusChip.urgent(),
                AppStatusChip.scheduled(),
                AppStatusChip.offered(),
                AppStatusChip.accepted(),
                AppStatusChip.donated(),
              ],
            ),
          ),
          _SheetSection(
            title: '05. BUTTON STATES',
            child: Column(
              children: [
                CustomButton(
                  text: 'Primary Filled',
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Outlined',
                  type: ButtonType.outlined,
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Blood Action',
                  type: ButtonType.secondary,
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Disabled',
                  isDisabled: true,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          _SheetSection(
            title: '06. CONFIRMATION & TOAST',
            child: Column(
              children: [
                CustomButton(
                  text: 'Show Confirmation Dialog',
                  type: ButtonType.outlined,
                  onPressed: () async {
                    final confirmed = await AppConfirmDialog.show(
                      context: context,
                      title: 'Confirm action?',
                      message: 'This is a shared confirmation dialog example.',
                    );
                    if (confirmed && context.mounted) {
                      AppToast.show(context, 'Action confirmed.');
                    }
                  },
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Show Toast Notification',
                  onPressed: () => AppToast.show(
                    context,
                    'Record uploaded successfully',
                    actionLabel: 'View',
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

class _SheetSection extends StatelessWidget {
  const _SheetSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 11),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
