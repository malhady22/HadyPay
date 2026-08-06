import '../entities/country.dart';
import '../entities/recipient.dart';
import '../entities/transaction.dart';
import '../entities/user_profile.dart';

/// Single abstract repository boundary between the presentation layer
/// and data sources. In this MVP, the only implementation is the mock
/// repository — swapping in a real backend later means implementing
/// this interface again, with zero changes to the UI layer.
abstract class HadyPayRepository {
  Future<UserProfile> getUserProfile();
  Future<List<Country>> getCountries();
  Future<List<Recipient>> getRecipients();
  Future<Recipient> addRecipient({
    required String name,
    required String phone,
    required Country country,
  });
  Future<List<AppTransaction>> getTransactions();
  Future<AppTransaction> createTransaction({
    required Recipient recipient,
    required Country country,
    required double amountSent,
    required double fee,
    required double amountReceived,
  });
  Future<bool> requestOtp(String phone);
  Future<bool> verifyOtp(String phone, String code);
}
