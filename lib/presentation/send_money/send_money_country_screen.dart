import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/router/app_routes.dart';
import '../../core/widgets/flow_step_header.dart';
import '../providers/send_money_provider.dart';
import '../providers/wallet_provider.dart';

/// Send Money Step 1 of 3: Select destination country.
/// Selection is stored on [SendMoneyProvider] so it survives
/// back-navigation within the flow.
class SendMoneyCountryScreen extends StatelessWidget {
  const SendMoneyCountryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final sendMoney = context.watch<SendMoneyProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Send Money')),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: FlowStepHeader(step: 1, total: 3, label: 'Select a country'),
            ),
            Expanded(
              child: wallet.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      itemCount: wallet.countries.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final country = wallet.countries[index];
                        final selected =
                            sendMoney.selectedCountry?.name == country.name;
                        return Material(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              context
                                  .read<SendMoneyProvider>()
                                  .setCountry(country);
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.sendMoneyRecipient);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.teal
                                      : AppColors.lightBorder,
                                  width: selected ? 1.6 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(country.flagEmoji,
                                      style: const TextStyle(fontSize: 28)),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          country.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${country.currencyCode} • 1 USD ≈ ${country.rateToUsd} ${country.currencyCode}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.lightTextSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right_rounded,
                                      color: AppColors.lightTextSecondary),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
