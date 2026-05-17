import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/button_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../provider/auth_state.dart';
import '../provider/providers.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;

  bool get _isValid {
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();
    return password.isNotEmpty && password.length >= 8 && password == confirm;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (next is PasswordChangeSuccess) {
        AppToast.show(context, 'Пароль успешно изменен');
        if (context.mounted) Navigator.pop(context);
      }

      if (next is AuthError) {
        AppToast.show(context, next.message);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F3),
        centerTitle: true,
        title: Text(l10n.change_password),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.newPassword),
            const SizedBox(height: 8),
            _PasswordField(
              controller: _passwordController,
              obscure: _obscure1,
              hint: l10n.newPassword,
              onToggle: () => setState(() => _obscure1 = !_obscure1),
              onChanged: () => setState(() {}),
            ),
            const SizedBox(height: 16),
            Text(l10n.repeatPassword),
            const SizedBox(height: 8),
            _PasswordField(
              controller: _confirmController,
              obscure: _obscure2,
              hint: l10n.repeatPassword,
              onToggle: () => setState(() => _obscure2 = !_obscure2),
              onChanged: () => setState(() {}),
            ),
            const SizedBox(height: 24),
            ButtonWidget(
              text: l10n.save,
              filled: true,
              onTap: _isValid
                  ? () => ref.read(authNotifierProvider.notifier).changePassword(
                        newPassword: _passwordController.text.trim(),
                      )
                  : null,
            ),
          ],
        ),
      ),
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
    return TextField(
      controller: controller,
      obscureText: obscure,
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textDisabled),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
