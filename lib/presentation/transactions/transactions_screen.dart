import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/transaction.dart';
import '../providers/wallet_provider.dart';

/// Screen 8: Transactions. When [embedded] is true (used inside
/// [HomeShell]'s bottom-nav tab) it renders body-only content with no
/// Scaffold/AppBar of its own; when false it's a full standalone screen
/// suitable for a normal push (e.g. from Home's "See all" link).
class TransactionsScreen extends StatefulWidget {
  final bool embedded;
  const TransactionsScreen({super.key, this.embedded = false});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

enum _Filter { all, completed, pending, failed }

class _TransactionsScreenState extends State<TransactionsScreen> {
  _Filter _filter = _Filter.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wallet = context.read<WalletProvider>();
      if (wallet.profile == null) wallet.load();
    });
  }

  List<AppTransaction> _apply(List<AppTransaction> all) {
    switch (_filter) {
      case _Filter.all:
        return all;
      case _Filter.completed:
        return all
            .where((t) => t.status == TransactionStatus.completed)
            .toList();
      case _Filter.pending:
        return all.where((t) => t.status == TransactionStatus.pending).toList();
      case _Filter.failed:
        return all.where((t) => t.status == TransactionStatus.failed).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final filtered = _apply(wallet.transactions);

    final body = wallet.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _Filter.values.map((f) {
                      final selected = f == _filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(_label(f)),
                          selected: selected,
                          onSelected: (_) => setState(() => _filter = f),
                          selectedColor: AppColors.teal.withOpacity(0.16),
                          labelStyle: TextStyle(
                            color: selected
                                ? AppColors.teal
                                : AppColors.lightTextSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: selected
                                  ? AppColors.teal
                                  : AppColors.lightBorder,
                            ),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('No transactions found.'))
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) =>
                            _TransactionRow(tx: filtered[index]),
                      ),
              ),
            ],
          );

    if (widget.embedded) {
      return SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Transactions',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: SafeArea(child: body),
    );
  }

  String _label(_Filter f) {
    switch (f) {
      case _Filter.all:
        return 'All';
      case _Filter.completed:
        return 'Completed';
      case _Filter.pending:
        return 'Pending';
      case _Filter.failed:
        return 'Failed';
    }
  }
}

class _TransactionRow extends StatelessWidget {
  final AppTransaction tx;
  const _TransactionRow({required this.tx});

  Color _statusColor() {
    switch (tx.status) {
      case TransactionStatus.completed:
        return AppColors.success;
      case TransactionStatus.pending:
        return AppColors.pending;
      case TransactionStatus.failed:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.teal.withOpacity(0.12),
            child: Text(tx.countryFlag, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.recipientName,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  '${tx.countryName} • ${Formatters.date(tx.date)}',
                  style: const TextStyle(
                      fontSize: 11.5, color: AppColors.lightTextSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '- ${Formatters.currency(tx.amountSent, r'$')}',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _statusColor().withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  tx.status.name,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _statusColor(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
