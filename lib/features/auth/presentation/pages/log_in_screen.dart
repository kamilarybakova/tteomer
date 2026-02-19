import 'package:flutter/material.dart';
import 'package:tteomer/features/auth/presentation/utils/auth_text_field.dart';
import 'package:tteomer/features/auth/presentation/utils/field_label.dart';
import 'package:tteomer/features/auth/presentation/pages/sign_up_screen.dart';
import '../../../../core/widgets/button_widget.dart';
import '../../../../l10n/app_localizations.dart';
import 'forgot_password_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    const primary = Color(0xFF4C63D2);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              /// TITLE
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  t.login,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5A4B4B),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              /// EMAIL
              FieldLabel(t.email),
              const SizedBox(height: 8),
              AuthTextField(
                controller: emailController,
                hint: 'helloworld@gmail.com',
                suffix: const Icon(Icons.check_circle, color: primary),
              ),

              const SizedBox(height: 20),

              /// PASSWORD
              FieldLabel(t.password),
              const SizedBox(height: 8),
              AuthTextField(
                controller: passwordController,
                hint: '••••••••',
                obscure: obscure,
                suffix: IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () => setState(() => obscure = !obscure),
                ),
              ),

              /// FORGOT PASSWORD
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    t.forgotPassword,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /// BUTTON
              ButtonWidget(
                text: t.login,
                filled: true,
                onTap: () {},
              ),

              const Spacer(),

              /// BOTTOM LINK
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${t.noAccount} ',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: Text(
                      t.createAccount,
                      style: const TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
