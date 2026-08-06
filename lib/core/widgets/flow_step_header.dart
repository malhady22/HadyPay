import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Small "Step X of N" progress header shared by the multi-step
/// Send Money flow (Country -> Recipient -> Amount).
class FlowStepHeader extends StatelessWidget {
  final int step;
  final int total;
  final String label;

  const FlowStepHeader({
    super.key,
    required this.step,
    required this.total,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step $step of $total',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.teal,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Row(
          children: List.generate(total, (i) {
            final active = i < step;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i == total - 1 ? 0 : 6),
                height: 4,
                decoration: BoxDecoration(
                  color: active ? AppColors.teal : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
