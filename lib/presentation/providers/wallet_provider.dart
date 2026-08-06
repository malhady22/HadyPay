import 'package:flutter/material.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/recipient.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/hadypay_repository.dart';

/// Central app-data provider: wallet balance, recipients, transactions,
/// and the countries list used for transfers. Loads once on startup
/// from the mock repository and mutates in-memory afterward.
class WalletProvider extends ChangeNotifier {
  final HadyPayRepository repository;
  WalletProvider(this.repository);

  UserProfile? profile;
  List<Country> countries = [];
  List<Recipient> recipients = [];
  List<AppTransaction> transactions = [];
  bool isLoading = true;

  double get balance => profile?.walletBalance ?? 0;
  String get currency => profile?.walletCurrency ?? 'USD';

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    final results = await Future.wait([
      repository.getUserProfile(),
      repository.getCountries(),
      repository.getRecipients(),
      repository.getTransactions(),
    ]);
    profile = results[0] as UserProfile;
    countries = results[1] as List<Country>;
    recipients = results[2] as List<Recipient>;
    transactions = results[3] as List<AppTransaction>;
    isLoading = false;
    notifyListeners();
  }

  Future<Recipient> addRecipient({
    required String name,
    required String phone,
    required Country country,
  }) async {
    final r = await repository.addRecipient(
      name: name,
      phone: phone,
      country: country,
    );
    recipients = await repository.getRecipients();
    notifyListeners();
    return r;
  }

  Future<AppTransaction> sendMoney({
    required Recipient recipient,
    required Country country,
    required double amountSent,
    required double fee,
    required double amountReceived,
  }) async {
    final tx = await repository.createTransaction(
      recipient: recipient,
      country: country,
      amountSent: amountSent,
      fee: fee,
      amountReceived: amountReceived,
    );
    transactions = await repository.getTransactions();
    if (profile != null) {
      profile = UserProfile(
        fullName: profile!.fullName,
        phone: profile!.phone,
        email: profile!.email,
        kycStatus: profile!.kycStatus,
        walletBalance: profile!.walletBalance - amountSent - fee,
        walletCurrency: profile!.walletCurrency,
      );
    }
    notifyListeners();
    return tx;
  }
}
