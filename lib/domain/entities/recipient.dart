import 'package:flutter/material.dart';

class Recipient {
  final String id;
  final String name;
  final String phone;
  final String countryName;
  final String flagEmoji;
  final Color avatarColor;

  const Recipient({
    required this.id,
    required this.name,
    required this.phone,
    required this.countryName,
    required this.flagEmoji,
    required this.avatarColor,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}
