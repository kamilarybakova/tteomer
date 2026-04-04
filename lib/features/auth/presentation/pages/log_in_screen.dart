import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/features/auth/presentation/utils/auth_text_field.dart';
import 'package:tteomer/features/auth/presentation/utils/field_label.dart';
import 'package:tteomer/features/auth/presentation/pages/sign_up_screen.dart';
import '../../../../core/storage/shared_prefs_service.dart';
import '../../../../core/widgets/app_toast.dart';
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
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPrefsService.getInstance();
    final savedEmail = prefs.getEmail();
    final savedPassword = prefs.getPassword();

    if (savedEmail != null && savedPassword != null) {
      setState(() {
        emailController.text = savedEmail;
        passwordController.text = savedPassword;
        rememberMe = true;
      });
    }
  }

  Future<void> _handleLogin() async {
    final prefs = await SharedPrefsService.getInstance();

    if (rememberMe) {
      await prefs.saveCredentials(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } else {
      await prefs.clearAll();
    }

    ref.read(authNotifierProvider.notifier).login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      emailController.text.trim().isNotEmpty &&
          passwordController.text.trim().isNotEmpty;

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
        AppToast.show(context, next.message);
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
              FieldLabel(t.email),
              const SizedBox(height: 8),
              AuthTextField(
                controller: emailController,
                hint: 'helloworld@gmail.com',
                suffix: const Icon(Icons.check_circle, color: primary),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Чекбокс "Запомнить меня"
                  GestureDetector(
                    onTap: () => setState(() => rememberMe = !rememberMe),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: rememberMe,
                            onChanged: (val) =>
                                setState(() => rememberMe = val ?? false),
                            activeColor: primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Запомнить меня',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
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
                ],
              ),
              const SizedBox(height: 8),
              ButtonWidget(
                text: authState is AuthLoading ? 'Loading...' : t.login,
                filled: true,
                onTap: (authState is AuthLoading || !_canSubmit)
                    ? null
                    : _handleLogin,
              ),
              const Spacer(),
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