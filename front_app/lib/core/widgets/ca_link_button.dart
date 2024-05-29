import 'package:barassage_app/config/app_colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CALinkButton extends StatelessWidget {
  Function() onPressed;
  String labelStr;
  CALinkButton({
    super.key,
    required this.onPressed,
    required this.labelStr,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Center(
          child: Text(
            labelStr,
            style: const TextStyle(color: AppColors.grey),
          ),
        ),
      ),
    );
  }
}
