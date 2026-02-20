import 'package:flutter/material.dart';
import 'package:tteomer/features/auth/presentation/pages/group_code_screen.dart';
import 'package:tteomer/features/auth/presentation/pages/log_in_screen.dart';
import 'package:tteomer/features/auth/presentation/utils/auth_text_field.dart';
import 'package:tteomer/features/auth/presentation/utils/field_label.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/button_widget.dart';
import '../../../../l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscure = true;
  bool accepted = false;

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
                  t.signUpTitle,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              FieldLabel(t.firstName),
              AuthTextField(
                controller: nameController,
                hint: t.enterName,
              ),

              const SizedBox(height: 16),

              FieldLabel(t.lastName),
              AuthTextField(
                controller: lastNameController,
                hint: t.enterLastName,
              ),

              const SizedBox(height: 16),

              FieldLabel(t.email),
              AuthTextField(
                controller: emailController,
                hint: t.enterEmail,
              ),

              const SizedBox(height: 16),

              FieldLabel(t.password),
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

              const SizedBox(height: 20),

              /// CHECKBOX
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => accepted = !accepted),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: accepted ? primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: accepted ? primary : Colors.grey.shade400,
                          width: 1.5,
                        ),
                      ),
                      child: accepted
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t.acceptTerms,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              ButtonWidget(
                text: t.createAccount,
                filled: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupCodeScreen(
                        email: emailController.text,
                        password: passwordController.text,
                        firstName: nameController.text,
                        lastName: lastNameController.text,
                      ),
                    ),
                  );
                },
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${t.alreadyHaveAccount} ',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LogInScreen(),
                        ),
                      );
                    },
                    child: Text(
                      t.login,
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
