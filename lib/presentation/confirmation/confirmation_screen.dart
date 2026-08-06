import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/router/app_routes.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/demo_badge.dart';
import '../../core/widgets/primary_button.dart';
import '../providers/send_money_provider.dart';
import '../providers/wallet_provider.dart';
import '../success/success_screen.dart';

/// Screen 6: Confirmation — final review before the transfer is
/// "sent" against the mock repository.
class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  bool _isSubmitting = false;

  Future<void> _confirm() async {
    final sendMoney = context.read<SendMoneyProvider>();
    final wallet = context.read<WalletProvider>();
    final country = sendMoney.selectedCountry;
    final recipient = sendMoney.selectedRecipient;
    if (country == null || recipient == null) return;

    setState(() => _isSubmitting = true);
    final tx = await wallet.sendMoney(
      recipient: recipient,
      country: country,
      amountSent: sendMoney.amount,
      fee: sendMoney.fee,
      amountReceived: sendMoney.amountReceived,
    );
    setState(() => _isSubmitting = false);

    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SuccessScreen(transactionId: tx.id),
        settings: const RouteSettings(name: AppRoutes.success),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sendMoney = context.watch<SendMoneyProvider>();
    final country = sendMoney.selectedCountry;
    final recipient = sendMoney.selectedRecipient;

    if (country == null || recipient == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Confirmation')),
        body: const Center(child: Text('Missing transfer details.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Transfer')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DemoBadge(),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.lightBorder),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: recipient.avatarColor,
                      child: Text(
                        recipient.initials,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(recipient.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 16)),
                          const SizedBox(height: 2),
                          Text(
                            '${country.flagEmoji} ${country.name} • ${recipient.phone}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Transfer details',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.lightBorder),
                ),
                child: Column(
                  children: [
                    _detailRow('You send',
                        Formatters.currency(sendMoney.amount, r'$')),
                    const SizedBox(height: 10),
                    _detailRow(
                        'Exchange rate',
                        '1 USD = ${country.rateToUsd} ${country.currencyCode}'),
                    const SizedBox(height: 10),
                    _detailRow(
                        'Fee', Formatters.currency(sendMoney.fee, r'$')),
                    const Divider(height: 26),
                    _detailRow(
                      'Total to pay',
                      Formatters.currency(sendMoney.totalDebit, r'$'),
                      emphasize: true,
                    ),
                    const SizedBox(height: 10),
                    _detailRow(
                      'Recipient gets',
                      Formatters.currency(
                          sendMoney.amountReceived, country.currencySymbol),
                      emphasize: true,
                      color: AppColors.teal,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: 'Confirm & Send',
                icon: Icons.lock_outline_rounded,
                isLoading: _isSubmitting,
                onPressed: _confirm,
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'This is a demo — no real money will be transferred.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.lightTextSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value,
      {bool emphasize = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: emphasize ? 14 : 13,
            fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
            color: AppColors.lightTextSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: emphasize ? 16 : 13,
            fontWeight: FontWeight.w800,
            color: color ?? AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }
}
