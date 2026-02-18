import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/button_widget.dart';
import '../../l10n/app_localizations.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),

              Image.asset(
                'assets/images/logo.png',
                width: 220,
              ),

              const SizedBox(height: 24),

              Text(
                t.appTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 40),

              ButtonWidget(
                text: t.login,
                filled: true,
                onTap: () {},
              ),

              const SizedBox(height: 16),

              ButtonWidget(
                text: t.register,
                filled: false,
                onTap: () {},
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
