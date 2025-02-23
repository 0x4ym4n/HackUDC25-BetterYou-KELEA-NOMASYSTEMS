import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import 'avatar_glow.dart';

class Character extends StatelessWidget {
  const Character({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AvatarGlow(
        endRadius: 150,
        duration: const Duration(milliseconds: 2000),
        glowColor: AppColors.pillsGreen,
        repeat: true,
        animate: true,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.pillsGreen,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 40.0, left: 30, right: 30, bottom: 10),
              child: Image.asset(
                'assets/png/character.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
