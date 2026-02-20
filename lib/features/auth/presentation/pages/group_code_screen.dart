import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/button_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../main_navigation_screen.dart';
import '../provider/auth_state.dart';
import '../provider/providers.dart';

class GroupCodeScreen extends ConsumerStatefulWidget {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  const GroupCodeScreen({
    super.key,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  ConsumerState<GroupCodeScreen> createState() => _GroupCodeScreenState();
}

class _GroupCodeScreenState extends ConsumerState<GroupCodeScreen> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

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

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _showKeyboard() {
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (next is AuthRegistered) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MainNavigationScreen(),
          ),
        );
      }

      if (next is AuthError) {
        AppToast.show(context, next.message);
      }
    });

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _hideKeyboard,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3F3),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                t.enterGroupCode,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5A4B4B),
                ),
              ),

              const SizedBox(height: 32),

              GestureDetector(
                onTap: _showKeyboard,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 7,
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
                      fieldHeight: 48,
                      fieldWidth: 48,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      inactiveColor: Colors.grey.shade300,
                      selectedColor: Colors.black54,
                      activeColor: Colors.black54,
                    ),
                    onChanged: (_) => setState(() {}),
                    onCompleted: (value) {
                      debugPrint('CODE: $value');
                    },
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ButtonWidget(
                  text: t.send,
                  filled: true,
                  onTap: controller.text.length == 7 ? _onSend : null,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                secondsLeft > 0
                    ? t.resendWithTimer(
                  '00:${secondsLeft.toString().padLeft(2, '0')}',
                )
                    : t.resendCode,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSend() {
    final groupCode = controller.text.trim();

    ref.read(authNotifierProvider.notifier).register(
      email: widget.email,
      password: widget.password,
      firstName: widget.firstName,
      lastName: widget.lastName,
      groupCode: groupCode,
    );
  }
}
