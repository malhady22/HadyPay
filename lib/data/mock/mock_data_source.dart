import 'package:flutter/material.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/recipient.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/user_profile.dart';

/// Static, in-memory demo data. Nothing here touches a network or a
/// real financial system — this exists purely to make the UI feel alive.
class MockDataSource {
  MockDataSource._();
  static final MockDataSource instance = MockDataSource._();

  final UserProfile currentUser = const UserProfile(
    fullName: 'Mahmoud Elhady',
    phone: '+20 100 123 4567',
    email: 'mahmoud.elhady@hadypay.demo',
    kycStatus: KycStatus.verified,
    walletBalance: 4820.50,
    walletCurrency: 'USD',
  );

  final List<Country> countries = const [
    Country(
      name: 'Egypt',
      flagEmoji: '🇪🇬',
      currencyCode: 'EGP',
      currencySymbol: 'E£',
      rateToUsd: 49.60,
    ),
    Country(
      name: 'Palestine',
      flagEmoji: '🇵🇸',
      currencyCode: 'ILS',
      currencySymbol: '₪',
      rateToUsd: 3.65,
    ),
    Country(
      name: 'Jordan',
      flagEmoji: '🇯🇴',
      currencyCode: 'JOD',
      currencySymbol: 'JD',
      rateToUsd: 0.71,
    ),
    Country(
      name: 'Saudi Arabia',
      flagEmoji: '🇸🇦',
      currencyCode: 'SAR',
      currencySymbol: 'SR',
      rateToUsd: 3.75,
    ),
    Country(
      name: 'United Arab Emirates',
      flagEmoji: '🇦🇪',
      currencyCode: 'AED',
      currencySymbol: 'AED',
      rateToUsd: 3.67,
    ),
    Country(
      name: 'United States',
      flagEmoji: '🇺🇸',
      currencyCode: 'USD',
      currencySymbol: r'$',
      rateToUsd: 1.0,
    ),
  ];

  final List<Recipient> _recipients = [
    const Recipient(
      id: 'r1',
      name: 'Ahmed Al-Wuhaybi',
      phone: '+970 59 123 4567',
      countryName: 'Palestine',
      flagEmoji: '🇵🇸',
      avatarColor: Color(0xFF19B38B),
    ),
    const Recipient(
      id: 'r2',
      name: 'Sara Mostafa',
      phone: '+20 101 987 6543',
      countryName: 'Egypt',
      flagEmoji: '🇪🇬',
      avatarColor: Color(0xFF162A4E),
    ),
    const Recipient(
      id: 'r3',
      name: 'Youssef Nasser',
      phone: '+962 79 555 1122',
      countryName: 'Jordan',
      flagEmoji: '🇯🇴',
      avatarColor: Color(0xFF2ED9A6),
    ),
    const Recipient(
      id: 'r4',
      name: 'Laila Hamdan',
      phone: '+966 55 222 3344',
      countryName: 'Saudi Arabia',
      flagEmoji: '🇸🇦',
      avatarColor: Color(0xFFF2A93B),
    ),
  ];

  List<Recipient> get recipients => List.unmodifiable(_recipients);

  void addRecipient(Recipient r) => _recipients.add(r);

  final List<AppTransaction> _transactions = [
    AppTransaction(
      id: 'HP-central-8823',
      recipientName: 'Ahmed Al-Wuhaybi',
      countryFlag: '🇵🇸',
      countryName: 'Palestine',
      amountSent: 200,
      currencySent: 'USD',
      amountReceived: 730,
      currencyReceived: 'ILS',
      fee: 3.5,
      status: TransactionStatus.completed,
      date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    ),
    AppTransaction(
      id: 'HP-central-8791',
      recipientName: 'Sara Mostafa',
      countryFlag: '🇪🇬',
      countryName: 'Egypt',
      amountSent: 150,
      currencySent: 'USD',
      amountReceived: 7440,
      currencyReceived: 'EGP',
      fee: 2.9,
      status: TransactionStatus.completed,
      date: DateTime.now().subtract(const Duration(days: 3, hours: 6)),
    ),
    AppTransaction(
      id: 'HP-central-8654',
      recipientName: 'Youssef Nasser',
      countryFlag: '🇯🇴',
      countryName: 'Jordan',
      amountSent: 80,
      currencySent: 'USD',
      amountReceived: 56.80,
      currencyReceived: 'JOD',
      fee: 1.9,
      status: TransactionStatus.pending,
      date: DateTime.now().subtract(const Duration(days: 5, hours: 1)),
    ),
    AppTransaction(
      id: 'HP-central-8412',
      recipientName: 'Laila Hamdan',
      countryFlag: '🇸🇦',
      countryName: 'Saudi Arabia',
      amountSent: 300,
      currencySent: 'USD',
      amountReceived: 1125,
      currencyReceived: 'SAR',
      fee: 4.2,
      status: TransactionStatus.failed,
      date: DateTime.now().subtract(const Duration(days: 9, hours: 2)),
    ),
    AppTransaction(
      id: 'HP-central-8107',
      recipientName: 'Ahmed Al-Wuhaybi',
      countryFlag: '🇵🇸',
      countryName: 'Palestine',
      amountSent: 100,
      currencySent: 'USD',
      amountReceived: 365,
      currencyReceived: 'ILS',
      fee: 2.5,
      status: TransactionStatus.completed,
      date: DateTime.now().subtract(const Duration(days: 14)),
    ),
  ];

  List<AppTransaction> get transactions => List.unmodifiable(
        _transactions..sort((a, b) => b.date.compareTo(a.date)),
      );

  void addTransaction(AppTransaction t) => _transactions.insert(0, t);
}
