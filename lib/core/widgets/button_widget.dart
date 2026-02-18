import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final bool filled;
  final VoidCallback onTap;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primary = AppColors.accent;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(12),
        color: filled ? primary : Colors.transparent,
        onPressed: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: filled
                ? null
                : Border.all(color: primary, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: filled ? Colors.white : primary,
            ),
          ),
        ),
      ),
    );
  }
}
