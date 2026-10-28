import 'package:flutter/material.dart';
import 'package:smart_health_app/core/theme/app_colors.dart';
import 'package:smart_health_app/core/theme/app_text_styles.dart';
/// Debug-only chips to preview each screen state (mirrors the design's
/// "Preview state" switcher). Wrap in `if (kDebugMode)` where used.
class DebugStateSwitcher extends StatelessWidget {
  final String title;
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;

  const DebugStateSwitcher({
    super.key,
    required this.title,
    required this.labels,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTextStyles.bodyMedium
                  .copyWith(fontSize: 11, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (var i = 0; i < labels.length; i++)
                ChoiceChip(
                  label: Text(labels[i], style: const TextStyle(fontSize: 11)),
                  selected: i == selected,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                      color: i == selected
                          ? AppColors.white
                          : AppColors.textDark),
                  showCheckmark: false,
                  onSelected: (_) => onSelected(i),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
