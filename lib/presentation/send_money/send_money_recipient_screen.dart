import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/router/app_routes.dart';
import '../../core/widgets/flow_step_header.dart';
import '../../core/widgets/primary_button.dart';
import '../../domain/entities/recipient.dart';
import '../providers/send_money_provider.dart';
import '../providers/wallet_provider.dart';

/// Send Money Step 2 of 3: pick an existing recipient or add a new one.
/// Can also be opened standalone from the Home "Recipients" quick action —
/// in that case a country may not yet be selected, and the empty state
/// nudges the user back to Step 1.
class SendMoneyRecipientScreen extends StatelessWidget {
  const SendMoneyRecipientScreen({super.key});

  Future<void> _showAddRecipientSheet(BuildContext context) async {
    final sendMoney = context.read<SendMoneyProvider>();
    final wallet = context.read<WalletProvider>();

    if (sendMoney.selectedCountry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a country first.')),
      );
      return;
    }

    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isSaving = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                decoration: const BoxDecoration(
                  color: AppColors.lightSurface,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColors.lightBorder,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Text('Add new recipient',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: nameController,
                        decoration:
                            const InputDecoration(labelText: 'Full name'),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter a name'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration:
                            const InputDecoration(labelText: 'Phone number'),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter a phone number'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      PrimaryButton(
                        label: 'Save recipient',
                        isLoading: isSaving,
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          setSheetState(() => isSaving = true);
                          await wallet.addRecipient(
                            name: nameController.text.trim(),
                            phone: phoneController.text.trim(),
                            country: sendMoney.selectedCountry!,
                          );
                          if (sheetContext.mounted) {
                            Navigator.of(sheetContext).pop();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

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
              child: FlowStepHeader(
                  step: 2, total: 3, label: 'Choose a recipient'),
            ),
            Expanded(
              child: wallet.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      children: [
                        ...wallet.recipients.map((recipient) {
                          final selected =
                              sendMoney.selectedRecipient?.id == recipient.id;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _RecipientTile(
                              recipient: recipient,
                              selected: selected,
                              onTap: () {
                                context
                                    .read<SendMoneyProvider>()
                                    .setRecipient(recipient);
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.sendMoneyAmount);
                              },
                            ),
                          );
                        }),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => _showAddRecipientSheet(context),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.teal,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.add_circle_outline_rounded,
                                      color: AppColors.teal),
                                  SizedBox(width: 12),
                                  Text(
                                    'Add new recipient',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.teal,
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
          ],
        ),
      ),
    );
  }
}

class _RecipientTile extends StatelessWidget {
  final Recipient recipient;
  final bool selected;
  final VoidCallback onTap;

  const _RecipientTile({
    required this.recipient,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.teal : AppColors.lightBorder,
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
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
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(
                      '${recipient.flagEmoji} ${recipient.countryName} • ${recipient.phone}',
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
  }
}
