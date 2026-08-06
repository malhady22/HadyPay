import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Small pill reminding the tester this is a mock/demo environment.
/// Shown on screens where money or identity actions happen.
class DemoBadge extends StatelessWidget {
  const DemoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.warning.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.info_outline_rounded, size: 13, color: AppColors.warning),
          SizedBox(width: 5),
          Text(
            'DEMO',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.warning,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
