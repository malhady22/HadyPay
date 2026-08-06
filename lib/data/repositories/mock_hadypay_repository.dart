import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/recipient.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/hadypay_repository.dart';
import '../mock/mock_data_source.dart';

/// Fake-latency mock implementation of [HadyPayRepository].
/// Simulates real async network calls (with small delays) purely so the
/// UI's loading states feel authentic — nothing here is a real backend.
class MockHadyPayRepository implements HadyPayRepository {
  final MockDataSource _source = MockDataSource.instance;
  final Random _random = Random();

  Future<void> _fakeLatency([int ms = 500]) =>
      Future.delayed(Duration(milliseconds: ms));

  @override
  Future<UserProfile> getUserProfile() async {
    await _fakeLatency(300);
    return _source.currentUser;
  }

  @override
  Future<List<Country>> getCountries() async {
    await _fakeLatency(250);
    return _source.countries;
  }

  @override
  Future<List<Recipient>> getRecipients() async {
    await _fakeLatency(300);
    return _source.recipients;
  }

  @override
  Future<Recipient> addRecipient({
    required String name,
    required String phone,
    required Country country,
  }) async {
    await _fakeLatency(400);
    final palette = [
      0xFF19B38B,
      0xFF162A4E,
      0xFF2ED9A6,
      0xFFF2A93B,
      0xFF6C63FF,
    ];
    final recipient = Recipient(
      id: 'r${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      phone: phone,
      countryName: country.name,
      flagEmoji: country.flagEmoji,
      avatarColor: Color(palette[_random.nextInt(palette.length)]),
    );
    _source.addRecipient(recipient);
    return recipient;
  }

  @override
  Future<List<AppTransaction>> getTransactions() async {
    await _fakeLatency(350);
    return _source.transactions;
  }

  @override
  Future<AppTransaction> createTransaction({
    required Recipient recipient,
    required Country country,
    required double amountSent,
    required double fee,
    required double amountReceived,
  }) async {
    await _fakeLatency(1200);
    final id = 'HP-${_random.nextInt(900000) + 100000}';
    final tx = AppTransaction(
      id: id,
      recipientName: recipient.name,
      countryFlag: recipient.flagEmoji,
      countryName: recipient.countryName,
      amountSent: amountSent,
      currencySent: 'USD',
      amountReceived: amountReceived,
      currencyReceived: country.currencyCode,
      fee: fee,
      status: TransactionStatus.completed,
      date: DateTime.now(),
    );
    _source.addTransaction(tx);
    return tx;
  }

  @override
  Future<bool> requestOtp(String phone) async {
    await _fakeLatency(700);
    return true; // Demo: always succeeds, code is always 1234.
  }

  @override
  Future<bool> verifyOtp(String phone, String code) async {
    await _fakeLatency(700);
    return code == '1234';
  }
}
