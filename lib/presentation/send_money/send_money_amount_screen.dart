import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/router/app_routes.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/flow_step_header.dart';
import '../../core/widgets/primary_button.dart';
import '../providers/send_money_provider.dart';
import '../providers/wallet_provider.dart';

/// Send Money Step 3 of 3: enter the USD amount to send. Shows a live
/// breakdown of fee and estimated amount received, both computed on
/// [SendMoneyProvider].
class SendMoneyAmountScreen extends StatefulWidget {
  const SendMoneyAmountScreen({super.key});

  @override
  State<SendMoneyAmountScreen> createState() => _SendMoneyAmountScreenState();
}

class _SendMoneyAmountScreenState extends State<SendMoneyAmountScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final existing = context.read<SendMoneyProvider>().amount;
    if (existing > 0) {
      _amountController.text = existing.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sendMoney = context.watch<SendMoneyProvider>();
    final wallet = context.watch<WalletProvider>();
    final country = sendMoney.selectedCountry;
    final recipient = sendMoney.selectedRecipient;

    final canContinue = sendMoney.amount > 0 &&
        sendMoney.amount <= wallet.balance &&
        country != null &&
        recipient != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Send Money')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FlowStepHeader(
                  step: 3, total: 3, label: 'Enter an amount'),
              const SizedBox(height: 20),
              if (recipient != null && country != null)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.lightBorder),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: recipient.avatarColor,
                        child: Text(
                          recipient.initials,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(recipient.name,
                                style:
                                    const TextStyle(fontWeight: FontWeight.w700)),
                            Text(
                              '${country.flagEmoji} ${country.name}',
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
              Text(
                'You send',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.lightTextSecondary),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                style: const TextStyle(
                    fontSize: 32, fontWeight: FontWeight.w800),
                decoration: const InputDecoration(
                  prefixText: r'$ ',
                  hintText: '0.00',
                ),
                onChanged: (value) {
                  final parsed = double.tryParse(value) ?? 0;
                  context.read<SendMoneyProvider>().setAmount(parsed);
                },
              ),
              if (sendMoney.amount > wallet.balance)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Amount exceeds your wallet balance of '
                    '${Formatters.currency(wallet.balance, r'$')}.',
                    style: const TextStyle(
                        color: AppColors.error, fontSize: 12.5),
                  ),
                ),
              const SizedBox(height: 24),
              if (country != null) _SummaryCard(sendMoney: sendMoney, country: country),
              const SizedBox(height: 28),
              PrimaryButton(
                label: 'Continue',
                onPressed: canContinue
                    ? () => Navigator.of(context)
                        .pushNamed(AppRoutes.confirmation)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final SendMoneyProvider sendMoney;
  final dynamic country;

  const _SummaryCard({required this.sendMoney, required this.country});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.teal.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _row('Fee', Formatters.currency(sendMoney.fee, r'$')),
          const SizedBox(height: 8),
          _row('Total to pay', Formatters.currency(sendMoney.totalDebit, r'$')),
          const Divider(height: 24),
          _row(
            'Recipient gets',
            Formatters.currency(
                sendMoney.amountReceived, country.currencySymbol),
            emphasize: true,
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool emphasize = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: emphasize ? 14 : 13,
            fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
            color: emphasize
                ? AppColors.lightTextPrimary
                : AppColors.lightTextSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: emphasize ? 16 : 13,
            fontWeight: FontWeight.w800,
            color: emphasize ? AppColors.teal : AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }
}
