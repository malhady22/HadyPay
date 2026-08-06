import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/router/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/mock_hadypay_repository.dart';
import 'presentation/auth/login_screen.dart';
import 'presentation/confirmation/confirmation_screen.dart';
import 'presentation/home/home_shell.dart';
import 'presentation/onboarding/onboarding_screen.dart';
import 'presentation/profile/profile_screen.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/send_money_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/providers/wallet_provider.dart';
import 'presentation/send_money/send_money_amount_screen.dart';
import 'presentation/send_money/send_money_country_screen.dart';
import 'presentation/send_money/send_money_recipient_screen.dart';
import 'presentation/settings/settings_screen.dart';
import 'presentation/splash/splash_screen.dart';
import 'presentation/success/success_screen.dart';
import 'presentation/transactions/transactions_screen.dart';

void main() {
  runApp(const HadyPayApp());
}

class HadyPayApp extends StatelessWidget {
  const HadyPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Single mock repository instance shared by every provider that needs
    // data access, matching the Clean Architecture boundary already
    // established in lib/domain + lib/data.
    final repository = MockHadyPayRepository();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(repository)),
        ChangeNotifierProvider(create: (_) => WalletProvider(repository)),
        ChangeNotifierProvider(create: (_) => SendMoneyProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'HadyPay',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settings.themeMode,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: (settingsRoute) {
              switch (settingsRoute.name) {
                case AppRoutes.splash:
                  return MaterialPageRoute(builder: (_) => const SplashScreen());
                case AppRoutes.onboarding:
                  return MaterialPageRoute(
                      builder: (_) => const OnboardingScreen());
                case AppRoutes.login:
                  return MaterialPageRoute(builder: (_) => const LoginScreen());
                case AppRoutes.home:
                  return MaterialPageRoute(builder: (_) => const HomeShell());
                case AppRoutes.sendMoneySelectCountry:
                  return MaterialPageRoute(
                      builder: (_) => const SendMoneyCountryScreen());
                case AppRoutes.sendMoneyRecipient:
                  return MaterialPageRoute(
                      builder: (_) => const SendMoneyRecipientScreen());
                case AppRoutes.sendMoneyAmount:
                  return MaterialPageRoute(
                      builder: (_) => const SendMoneyAmountScreen());
                case AppRoutes.confirmation:
                  return MaterialPageRoute(
                      builder: (_) => const ConfirmationScreen());
                case AppRoutes.success:
                  return MaterialPageRoute(builder: (_) => const SuccessScreen());
                case AppRoutes.transactions:
                  return MaterialPageRoute(
                      builder: (_) => const TransactionsScreen());
                case AppRoutes.profile:
                  return MaterialPageRoute(builder: (_) => const ProfileScreen());
                case AppRoutes.settings:
                  return MaterialPageRoute(
                      builder: (_) => const SettingsScreen());
                default:
                  return MaterialPageRoute(builder: (_) => const SplashScreen());
              }
            },
          );
        },
      ),
    );
  }
}
