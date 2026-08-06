import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/router/app_routes.dart';
import '../../core/widgets/hadypay_logo.dart';
import '../providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/wallet_provider.dart';

/// Screen 10: Settings — standalone push (not a bottom-nav tab).
/// Notifications / biometric toggles, currency preference (display-only
/// demo), an About entry, and Log out.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<AuthProvider>().logout();
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final wallet = context.watch<WalletProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            _SectionLabel('General'),
            const SizedBox(height: 12),
            _SwitchTile(
              icon: Icons.notifications_outlined,
              label: 'Notifications',
              value: settings.notificationsEnabled,
              onChanged: (v) =>
                  context.read<SettingsProvider>().setNotifications(v),
            ),
            const SizedBox(height: 10),
            _SwitchTile(
              icon: Icons.fingerprint_rounded,
              label: 'Biometric login',
              value: settings.biometricEnabled,
              onChanged: (v) =>
                  context.read<SettingsProvider>().setBiometric(v),
            ),
            const SizedBox(height: 10),
            _SwitchTile(
              icon: Icons.dark_mode_outlined,
              label: 'Dark mode',
              value: settings.isDarkMode,
              onChanged: (v) => context.read<SettingsProvider>().toggleDarkMode(v),
            ),
            const SizedBox(height: 24),
            _SectionLabel('Wallet'),
            const SizedBox(height: 12),
            _StaticTile(
              icon: Icons.attach_money_rounded,
              label: 'Preferred currency',
              value: wallet.currency,
            ),
            const SizedBox(height: 24),
            _SectionLabel('About'),
            const SizedBox(height: 12),
            _StaticTile(
              icon: Icons.info_outline_rounded,
              label: 'About HadyPay',
              value: AppStrings.tagline,
              onTap: () => showAboutDialog(
                context: context,
                applicationName: AppStrings.appName,
                applicationVersion: '1.0.0',
                applicationIcon: const HadyPayLogo(size: 48),
                children: const [
                  SizedBox(height: 12),
                  Text(AppStrings.demoDisclaimer),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Material(
              color: AppColors.error.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => _confirmLogout(context),
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, color: AppColors.error),
                      SizedBox(width: 8),
                      Text(
                        'Log out',
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w800,
        color: AppColors.lightTextSecondary,
        letterSpacing: 0.6,
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.teal, size: 20),
          const SizedBox(width: 12),
          Expanded(
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w700))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.teal,
          ),
        ],
      ),
    );
  }
}

class _StaticTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _StaticTile({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.teal, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              Text(
                value,
                style: const TextStyle(color: AppColors.lightTextSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
