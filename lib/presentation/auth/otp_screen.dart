import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/router/app_routes.dart';
import '../../core/widgets/primary_button.dart';
import '../providers/auth_provider.dart';
import '../providers/wallet_provider.dart';

/// OTP verification (demo). The correct code is always 1234 — shown
/// on-screen so testers never get stuck, since no real SMS is sent.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  late final AnimationController _shakeController;
  int _secondsLeft = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _startTimer();
  }

  void _startTimer() {
    _secondsLeft = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    _shakeController.dispose();
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  Future<void> _verify() async {
    if (_code.length != 4) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.verifyOtp(_code);
    if (!mounted) return;
    if (ok) {
      await context.read<WalletProvider>().load();
      if (!mounted) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
    } else {
      _shakeController.forward(from: 0);
      for (final c in _controllers) {
        c.clear();
      }
      _focusNodes.first.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: AppColors.tealGradient,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.sms_rounded,
                    color: Colors.white, size: 30),
              ),
              const SizedBox(height: 24),
              Text('Enter verification code',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'We sent a demo code to ${auth.phoneNumber}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.lightTextSecondary,
                    ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Hint: use code 1234',
                  style: TextStyle(
                      color: AppColors.teal, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 36),
              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final t = _shakeController.value;
                  final offset = (t == 0)
                      ? 0.0
                      : (16 * (1 - t)) *
                          ((t * 12).floor().isEven ? 1 : -1);
                  return Transform.translate(
                    offset: Offset(offset, 0),
                    child: child,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (i) => _otpBox(i)),
                ),
              ),
              if (auth.errorMessage != null) ...[
                const SizedBox(height: 14),
                Text(
                  auth.errorMessage!,
                  style: const TextStyle(
                      color: AppColors.error, fontWeight: FontWeight.w600),
                ),
              ],
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Verify & Continue',
                isLoading: auth.isLoading,
                onPressed: _code.length == 4 ? _verify : null,
              ),
              const SizedBox(height: 20),
              Center(
                child: _secondsLeft > 0
                    ? Text(
                        'Resend code in 00:${_secondsLeft.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                            color: AppColors.lightTextSecondary),
                      )
                    : TextButton(
                        onPressed: () {
                          context.read<AuthProvider>().sendOtp(auth.phoneNumber);
                          _startTimer();
                        },
                        child: const Text('Resend code'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _otpBox(int index) {
    return SizedBox(
      width: 64,
      height: 64,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(counterText: ''),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          setState(() {});
          if (_code.length == 4) _verify();
        },
      ),
    );
  }
}
