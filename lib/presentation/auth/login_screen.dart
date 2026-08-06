import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/demo_badge.dart';
import '../../core/widgets/hadypay_logo.dart';
import '../../core/widgets/primary_button.dart';
import '../providers/auth_provider.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController =
      TextEditingController(text: '');
  String _countryCode = '+20';
  final _formKey = GlobalKey<FormState>();

  static const _codes = ['+20', '+970', '+962', '+966', '+971', '+1'];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final fullPhone = '$_countryCode ${_phoneController.text.trim()}';
    final ok = await auth.sendOtp(fullPhone);
    if (ok && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const OtpScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HadyPayLogo(size: 72),
                const SizedBox(height: 24),
                Text('Welcome back',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  'Enter your phone number to continue',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.lightTextSecondary,
                      ),
                ),
                const SizedBox(height: 8),
                const DemoBadge(),
                const SizedBox(height: 32),
                Text('Phone number',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .inputDecorationTheme
                            .fillColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.lightBorder),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _countryCode,
                          items: _codes
                              .map((c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c),
                                  ))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _countryCode = v ?? _countryCode),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: '10 123 4567',
                        ),
                        validator: (v) {
                          if (v == null || v.trim().length < 6) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  label: 'Send OTP',
                  isLoading: auth.isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'By continuing, you agree to HadyPay\'s ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.lightTextSecondary,
                          ),
                      children: const [
                        TextSpan(
                          text: 'Terms',
                          style: TextStyle(
                              color: AppColors.teal,
                              fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: ' & '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                              color: AppColors.teal,
                              fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: '.'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
