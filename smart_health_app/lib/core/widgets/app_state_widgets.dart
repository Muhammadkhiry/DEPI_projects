import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Shared visual states used by Home, blood requests, and notification flows.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
  });

  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (actionText != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 36),
            ),
            child: Text(actionText!),
          ),
      ],
    );
  }
}

class AppStatusChip extends StatelessWidget {
  const AppStatusChip({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  final String label;
  final Color color;
  final IconData? icon;

  factory AppStatusChip.upcoming() => const AppStatusChip(
        label: 'Upcoming',
        color: Color(0xFF2D777A),
        icon: Icons.circle,
      );

  factory AppStatusChip.completed() => const AppStatusChip(
        label: 'Completed',
        color: Color(0xFF307849),
        icon: Icons.check_circle,
      );

  factory AppStatusChip.cancelled() => const AppStatusChip(
        label: 'Cancelled',
        color: Color(0xFF626D70),
        icon: Icons.circle,
      );

  factory AppStatusChip.critical() => const AppStatusChip(
        label: 'Critical',
        color: AppColors.secondary,
        icon: Icons.warning,
      );

  factory AppStatusChip.urgent() => const AppStatusChip(
        label: 'Urgent',
        color: Color(0xFFB33D49),
        icon: Icons.circle,
      );

  factory AppStatusChip.scheduled() => const AppStatusChip(
        label: 'Scheduled',
        color: Color(0xFFB17A1E),
        icon: Icons.schedule,
      );

  factory AppStatusChip.offered() => const AppStatusChip(
        label: 'Offered',
        color: Color(0xFF2D777A),
        icon: Icons.circle,
      );

  factory AppStatusChip.accepted() => const AppStatusChip(
        label: 'Accepted',
        color: Color(0xFF307849),
        icon: Icons.check,
      );

  factory AppStatusChip.donated() => const AppStatusChip(
        label: 'Donated',
        color: AppColors.secondary,
        icon: Icons.favorite,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class BloodTypeChip extends StatelessWidget {
  const BloodTypeChip({
    super.key,
    required this.bloodType,
    this.selected = false,
    this.onTap,
  });

  final String bloodType;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(bloodType),
      selected: selected,
      onSelected: onTap == null ? null : (_) => onTap!(),
      selectedColor: AppColors.secondary,
      backgroundColor: AppColors.white,
      labelStyle: TextStyle(
        color: selected ? AppColors.white : AppColors.textDark,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(
        color: selected ? AppColors.secondary : AppColors.border,
      ),
      shape: const StadiumBorder(),
      showCheckmark: false,
    );
  }
}

class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onTap == null ? null : (_) => onTap!(),
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.white,
      labelStyle: TextStyle(
        color: selected ? AppColors.white : AppColors.textDark,
        fontWeight: FontWeight.w500,
      ),
      side: BorderSide(
        color: selected ? AppColors.primary : AppColors.border,
      ),
      shape: const StadiumBorder(),
      showCheckmark: false,
    );
  }
}

class AppConfirmDialog {
  const AppConfirmDialog._();

  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Keep',
    bool destructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: CircleAvatar(
          backgroundColor: (destructive ? AppColors.secondary : AppColors.primary)
              .withValues(alpha: 0.10),
          child: Icon(
            destructive ? Icons.warning_amber_rounded : Icons.help_outline,
            color: destructive ? AppColors.secondary : AppColors.primary,
          ),
        ),
        title: Text(title, textAlign: TextAlign.center),
        content: Text(message, textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(cancelText),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor:
                  destructive ? AppColors.secondary : AppColors.primary,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

class AppToast {
  const AppToast._();

  static void show(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF102124),
          action: actionLabel == null
              ? null
              : SnackBarAction(
                  label: actionLabel,
                  onPressed: onAction ?? () {},
                ),
        ),
      );
  }
}
