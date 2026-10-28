import 'package:flutter/material.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';
import 'package:flutter/services.dart';
import 'package:smart_health_app/features/blood_donation/presentation/models/donor_models.dart';

class WeightInput extends StatefulWidget {
  final double? value;
  final double? valueKg;
  final WeightUnit unit;
  final ValueChanged<String> onChanged;
  final ValueChanged<WeightUnit> onUnitChanged;

  const WeightInput({
    super.key,
    required this.value,
    required this.valueKg,
    required this.unit,
    required this.onChanged,
    required this.onUnitChanged,
  });

  @override
  State<WeightInput> createState() => _WeightInputState();
}

class _WeightInputState extends State<WeightInput> {
  late final TextEditingController _controller;

  static String _fmt(double? v) {
    if (v == null) return '';
    return v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _fmt(widget.value));
  }

  @override
  void didUpdateWidget(covariant WeightInput old) {
    super.didUpdateWidget(old);

    if (old.unit != widget.unit) _controller.text = _fmt(widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kg = widget.valueKg;
    final safe = kg != null && kg >= 50;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.monitor_weight_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: widget.onChanged,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    LengthLimitingTextInputFormatter(5),
                  ],
                  style: AppTextStyles.headlineMedium,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
              Text(
                widget.unit == WeightUnit.kg ? 'kg' : 'lb',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(width: 8),
              if (kg != null)
                Row(
                  children: [
                    Icon(
                      safe ? Icons.check_circle : Icons.error,
                      size: 16,
                      color: safe ? AppColors.primary : Colors.red,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      safe ? 'Safe' : 'Too low',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: safe ? AppColors.primary : Colors.red,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Minimum clinical requirement: 50 kg (110 lbs) for blood volume safety.',
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 11),
        ),
      ],
    );
  }
}

class WeightUnitToggle extends StatelessWidget {
  final WeightUnit unit;
  final ValueChanged<WeightUnit> onChanged;

  const WeightUnitToggle({
    super.key,
    required this.unit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    Widget seg(WeightUnit u, String label) {
      final selected = unit == u;
      return InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onChanged(u),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: selected ? AppColors.white : AppColors.textDark,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.neutralBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [seg(WeightUnit.kg, 'kg'), seg(WeightUnit.lb, 'lb')],
      ),
    );
  }
}
