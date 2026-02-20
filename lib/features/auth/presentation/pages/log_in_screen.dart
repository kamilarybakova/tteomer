import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/features/auth/presentation/utils/auth_text_field.dart';
import 'package:tteomer/features/auth/presentation/utils/field_label.dart';
import 'package:tteomer/features/auth/presentation/pages/sign_up_screen.dart';
import '../../../../core/widgets/button_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../main_navigation_screen.dart';
import '../provider/auth_state.dart';
import '../provider/providers.dart';
import 'forgot_password_screen.dart';

class LogInScreen extends ConsumerStatefulWidget {
  const LogInScreen({super.key});

  @override
  ConsumerState<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends ConsumerState<LogInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    const primary = Color(0xFF4C63D2);

    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (next is AuthSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MainNavigationScreen(),
          ),
        );
      }

      if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message)),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
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
                        builder: (_) => const ForgotPasswordScreen(),
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

              /// 🔥 LOGIN BUTTON
              ButtonWidget(
                text: authState is AuthLoading ? 'Loading...' : t.login,
                filled: true,
                onTap: authState is AuthLoading
                    ? null
                    : () {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();

                  ref
                      .read(authNotifierProvider.notifier)
                      .login(email, password);
                },
              ),

              const Spacer(),

              /// SIGN UP
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
                          builder: (_) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Create account',
                      style: TextStyle(
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

