import 'package:flutter/material.dart';
import '../../domain/repositories/hadypay_repository.dart';

enum AuthStatus { unauthenticated, otpSent, authenticated }

/// Drives the phone + OTP demo login flow. The only valid OTP is 1234,
/// as shown on the OTP screen itself — this is a UI/UX prototype, not
/// a real authentication system.
class AuthProvider extends ChangeNotifier {
  final HadyPayRepository repository;
  AuthProvider(this.repository);

  AuthStatus status = AuthStatus.unauthenticated;
  String phoneNumber = '';
  bool isLoading = false;
  String? errorMessage;

  Future<bool> sendOtp(String phone) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    phoneNumber = phone;
    final ok = await repository.requestOtp(phone);
    isLoading = false;
    if (ok) status = AuthStatus.otpSent;
    notifyListeners();
    return ok;
  }

  Future<bool> verifyOtp(String code) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    final ok = await repository.verifyOtp(phoneNumber, code);
    isLoading = false;
    if (ok) {
      status = AuthStatus.authenticated;
    } else {
      errorMessage = 'Incorrect code. Try 1234 for this demo.';
    }
    notifyListeners();
    return ok;
  }

  void logout() {
    status = AuthStatus.unauthenticated;
    phoneNumber = '';
    notifyListeners();
  }
}
