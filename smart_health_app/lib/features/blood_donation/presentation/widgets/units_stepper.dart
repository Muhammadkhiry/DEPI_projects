import 'package:flutter/material.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';

class UnitsStepper extends StatelessWidget {
  final int units;
  final int minUnits;
  final int maxUnits;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<int> onPreset;

  const UnitsStepper({
    super.key,
    required this.units,
    required this.onIncrement,
    required this.onDecrement,
    required this.onPreset,
    this.minUnits = 1,
    this.maxUnits = 10,
  });

  static const _presets = [
    (1, '1 unit', 'Single dose'),
    (2, '2 units', 'Standard'),
    (4, '4 units', 'Massive'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _RoundButton(
                icon: Icons.remove,
                filled: false,
                onTap: units > minUnits ? onDecrement : null,
              ),
              Column(
                children: [
                  Text('$units units',
                      style: AppTextStyles.headlineMedium
                          .copyWith(color: AppColors.secondary, fontSize: 24)),
                  const SizedBox(height: 2),
                  Text('Approx. ${units * 450} ml packed red cells',
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 11)),
                ],
              ),
              _RoundButton(
                icon: Icons.add,
                filled: true,
                onTap: units < maxUnits ? onIncrement : null,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text('Standard protocols:',
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 11)),
              const SizedBox(width: 8),
              ..._presets.map((p) {
                final selected = p.$1 == units;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => onPreset(p.$1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary
                            : AppColors.neutralBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(p.$2,
                              style: AppTextStyles.bodyMedium.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: selected
                                      ? AppColors.white
                                      : AppColors.textDark)),
                          Text(p.$3,
                              style: AppTextStyles.bodyMedium.copyWith(
                                  fontSize: 9,
                                  color: selected
                                      ? AppColors.white
                                      : AppColors.textMuted)),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final bool filled;
  final VoidCallback? onTap;

  const _RoundButton({required this.icon, required this.filled, this.onTap});

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Opacity(
        opacity: disabled ? 0.4 : 1,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? AppColors.primary : AppColors.neutralBg,
          ),
          child: Icon(icon,
              color: filled ? AppColors.white : AppColors.primary),
        ),
      ),
    );
  }
}
