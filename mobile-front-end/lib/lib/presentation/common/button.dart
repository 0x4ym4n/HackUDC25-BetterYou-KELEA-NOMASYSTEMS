import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';

class RoundedButton extends StatelessWidget {
  VoidCallback onPressed;
  String text;
  RoundedButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.pillsGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          minimumSize: Size(400, 80),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.lightText,
          ),
        ),
      ),
    );
  }
}
