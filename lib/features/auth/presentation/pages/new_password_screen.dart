import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tteomer/features/auth/presentation/pages/log_in_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/button_widget.dart';
import '../provider/auth_state.dart';
import '../provider/providers.dart';

class NewPasswordScreen extends ConsumerStatefulWidget {
  final String email;
  final String code;

  const NewPasswordScreen({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  ConsumerState<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends ConsumerState<NewPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool obscure1 = true;
  bool obscure2 = true;

  bool get isValid =>
      passwordController.text.isNotEmpty &&
          passwordController.text == confirmController.text;

  void _hideKeyboard() => FocusScope.of(context).unfocus();

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (next is ResetPasswordSuccess) {
        AppToast.show(context, 'Пароль был сброшен');

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LogInScreen()),
              (_) => false,
        );
      }

      if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message)),
        );
      }
    });

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _hideKeyboard,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3F3),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.resetPasswordTitle,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.enterNewPassword,
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(l10n.newPassword),
                ),
                const SizedBox(height: 8),
                _PasswordField(
                  controller: passwordController,
                  obscure: obscure1,
                  hint: l10n.newPassword,
                  onToggle: () => setState(() => obscure1 = !obscure1),
                  onChanged: () => setState(() {}),
                ),

                const SizedBox(height: 20),

                // LABEL 2
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(l10n.repeatPassword),
                ),
                const SizedBox(height: 8),

                _PasswordField(
                  controller: confirmController,
                  obscure: obscure2,
                  hint: l10n.repeatPassword,
                  onToggle: () => setState(() => obscure2 = !obscure2),
                  onChanged: () => setState(() {}),
                ),

                const SizedBox(height: 28),

                // BUTTON
                ButtonWidget(
                  text: l10n.resetPassword,
                  filled: true,
                  onTap: isValid ? _submit : null,
                ),

                const Spacer(),

                // BOTTOM
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Уже есть аккаунт? ',
                        style: TextStyle(color: Colors.grey)),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LogInScreen(),
                          ),
                      ),
                      child: const Text(
                        'Войти',
                        style: TextStyle(
                          color: Color(0xFF4C63D2),
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
      ),
    );
  }

  void _submit() {
    final password = passwordController.text.trim();

    ref.read(authNotifierProvider.notifier).resetPasswordConfirm(
      email: widget.email,
      code: widget.code,
      password: password,
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final String hint;
  final VoidCallback onToggle;
  final VoidCallback onChanged;

  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.hint,
    required this.onToggle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF4C63D2);

    return TextField(
      controller: controller,
      obscureText: obscure,
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.textDisabled,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: onToggle,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary),
        ),
      ),
    );
  }
}
