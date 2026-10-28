import 'package:flutter/material.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';
import 'dart:async';

import 'package:smart_health_app/features/blood_donation/presentation/utils/time_helpers.dart';

/// "Expires in 23h 40m" - refreshes itself every 30 seconds.
class ExpiryChip extends StatefulWidget {
  final DateTime expiresAt;
  final bool closed; // cancelled / fulfilled / expired
  const ExpiryChip({super.key, required this.expiresAt, this.closed = false});

  @override
  State<ExpiryChip> createState() => _ExpiryChipState();
}

class _ExpiryChipState extends State<ExpiryChip> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
        const Duration(seconds: 30), (_) => mounted ? setState(() {}) : null);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final left = TimeHelpers.timeLeft(widget.expiresAt);
    final expired = left == 'Expired' || widget.closed;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.timer_outlined,
            size: 14, color: expired ? AppColors.textMuted : AppColors.secondary),
        const SizedBox(width: 4),
        Text(
          expired ? 'Closed' : 'Expires in $left',
          style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark),
        ),
      ],
    );
  }
}
