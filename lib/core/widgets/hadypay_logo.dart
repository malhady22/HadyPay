import 'package:flutter/material.dart';

/// Displays the HadyPay icon mark from assets, with a graceful fallback
/// if the asset somehow fails to load.
class HadyPayLogo extends StatelessWidget {
  final double size;
  const HadyPayLogo({super.key, this.size = 96});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.22),
      child: Image.asset(
        'assets/images/logo.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(size * 0.22),
          ),
          child: Icon(Icons.bolt, color: Colors.white, size: size * 0.5),
        ),
      ),
    );
  }
}
