enum KycStatus { verified, pending, notStarted }

class UserProfile {
  final String fullName;
  final String phone;
  final String email;
  final KycStatus kycStatus;
  final double walletBalance;
  final String walletCurrency;

  const UserProfile({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.kycStatus,
    required this.walletBalance,
    required this.walletCurrency,
  });

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}
