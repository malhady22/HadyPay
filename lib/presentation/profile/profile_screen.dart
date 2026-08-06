import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/settings_provider.dart';
import '../providers/wallet_provider.dart';
import '../settings/settings_screen.dart';

/// Screen 9: Profile. Uses the same `embedded: bool` constructor pattern
/// as [TransactionsScreen] so it can live inside [HomeShell]'s bottom-nav
/// tab (`embedded: true`) or be pushed standalone (`embedded: false`).
class ProfileScreen extends StatefulWidget {
  final bool embedded;
  const ProfileScreen({super.key, this.embedded = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wallet = context.read<WalletProvider>();
      if (wallet.profile == null) wallet.load();
    });
  }

  Color _kycColor(KycStatus status) {
    switch (status) {
      case KycStatus.verified:
        return AppColors.success;
      case KycStatus.pending:
        return AppColors.warning;
      case KycStatus.notStarted:
        return AppColors.lightTextSecondary;
    }
  }

  String _kycLabel(KycStatus status) {
    switch (status) {
      case KycStatus.verified:
        return 'Verified';
      case KycStatus.pending:
        return 'Pending review';
      case KycStatus.notStarted:
        return 'Not started';
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final settings = context.watch<SettingsProvider>();
    final profile = wallet.profile;

    final body = (wallet.isLoading || profile == null)
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: AppColors.navy,
                        child: Text(
                          profile.initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        profile.fullName,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.phone,
                        style: const TextStyle(
                            color: AppColors.lightTextSecondary),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: _kycColor(profile.kycStatus).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_rounded,
                                size: 14, color: _kycColor(profile.kycStatus)),
                            const SizedBox(width: 6),
                            Text(
                              'KYC: ${_kycLabel(profile.kycStatus)}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: _kycColor(profile.kycStatus),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Text('Account',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                _InfoTile(icon: Icons.email_outlined, label: 'Email', value: profile.email),
                const SizedBox(height: 10),
                _InfoTile(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: profile.phone),
                const SizedBox(height: 24),
                Text('Preferences',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                _ActionRow(
                  icon: Icons.language_rounded,
                  label: 'Language',
                  trailing: Text(
                    settings.languageLabel,
                    style: const TextStyle(
                        color: AppColors.lightTextSecondary,
                        fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    context.read<SettingsProvider>().setLanguage(
                          settings.language == AppLanguage.english
                              ? AppLanguage.arabic
                              : AppLanguage.english,
                        );
                  },
                ),
                const SizedBox(height: 10),
                _ActionRow(
                  icon: Icons.dark_mode_outlined,
                  label: 'Dark mode',
                  trailing: Switch(
                    value: settings.isDarkMode,
                    onChanged: (v) =>
                        context.read<SettingsProvider>().toggleDarkMode(v),
                    activeColor: AppColors.teal,
                  ),
                  onTap: () => context
                      .read<SettingsProvider>()
                      .toggleDarkMode(!settings.isDarkMode),
                ),
                const SizedBox(height: 10),
                _ActionRow(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  trailing: const Icon(Icons.chevron_right_rounded,
                      color: AppColors.lightTextSecondary),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
              ],
            ),
          );

    if (widget.embedded) {
      return SafeArea(top: false, child: body);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(child: body),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile(
      {required this.icon, required this.label, required this.value});

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11.5, color: AppColors.lightTextSecondary)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.trailing,
    required this.onTap,
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
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
