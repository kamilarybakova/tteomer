import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/button_widget.dart';
import 'new_password_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  int secondsLeft = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  void _startTimer() {
    timer?.cancel();
    secondsLeft = 60;

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _hideKeyboard() => FocusScope.of(context).unfocus();
  void _showKeyboard() => focusNode.requestFocus();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                    l10n.verifyEmailTitle,
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
                    l10n.verifyEmailDesc(widget.email),
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: _showKeyboard,
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    controller: controller,
                    focusNode: focusNode,
                    autoFocus: true,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.fade,
                    enableActiveFill: true,
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(14),
                      fieldHeight: 64,
                      fieldWidth: 64,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      inactiveColor: Colors.grey.shade300,
                      selectedColor: Colors.black54,
                      activeColor: Colors.black54,
                    ),
                    onChanged: (_) => setState(() {}),
                    onCompleted: (_) => _submit(),
                  ),
                ),
                const SizedBox(height: 28),
                ButtonWidget(
                  text: l10n.send,
                  filled: true,
                  onTap: controller.text.length == 4 ? _submit : null,
                ),
                const SizedBox(height: 24),
                Text(
                  secondsLeft > 0
                      ? l10n.resendWithTimer(
                    '00:${secondsLeft.toString().padLeft(2, '0')}',
                  )
                      : l10n.resendCode,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    final code = controller.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewPasswordScreen(email: widget.email, code: code),
      ),
    );
  }
}
