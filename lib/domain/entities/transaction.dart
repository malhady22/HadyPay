enum TransactionStatus { completed, pending, failed }

class AppTransaction {
  final String id;
  final String recipientName;
  final String countryFlag;
  final String countryName;
  final double amountSent;
  final String currencySent;
  final double amountReceived;
  final String currencyReceived;
  final double fee;
  final TransactionStatus status;
  final DateTime date;

  const AppTransaction({
    required this.id,
    required this.recipientName,
    required this.countryFlag,
    required this.countryName,
    required this.amountSent,
    required this.currencySent,
    required this.amountReceived,
    required this.currencyReceived,
    required this.fee,
    required this.status,
    required this.date,
  });
}
