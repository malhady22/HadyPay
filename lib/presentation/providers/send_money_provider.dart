import 'package:flutter/material.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/recipient.dart';

/// Holds the in-progress "Send Money" draft as the user moves through
/// Select Country -> Recipient -> Amount -> Confirmation -> Success.
/// Reset once the transfer completes (or is cancelled).
class SendMoneyProvider extends ChangeNotifier {
  Country? selectedCountry;
  Recipient? selectedRecipient;
  double amount = 0;

  static const double feeFlat = 2.99;
  static const double feeRatePercent = 0.5; // 0.5%

  double get fee =>
      amount <= 0 ? 0 : feeFlat + (amount * feeRatePercent / 100);

  double get totalDebit => amount + fee;

  double get amountReceived {
    if (selectedCountry == null || amount <= 0) return 0;
    return amount * selectedCountry!.rateToUsd;
  }

  void setCountry(Country c) {
    selectedCountry = c;
    notifyListeners();
  }

  void setRecipient(Recipient r) {
    selectedRecipient = r;
    notifyListeners();
  }

  void setAmount(double a) {
    amount = a;
    notifyListeners();
  }

  void reset() {
    selectedCountry = null;
    selectedRecipient = null;
    amount = 0;
    notifyListeners();
  }
}
