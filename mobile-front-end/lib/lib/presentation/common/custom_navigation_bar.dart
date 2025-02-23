import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/theme/app_colors.dart';

class CustomBottomNavBar extends StatefulWidget {
  final Function(int) onTap;
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final List<NavItem> _items = [
    NavItem(
      icon: "assets/png/home.png",
      label: 'Home'.tr,
    ),
    NavItem(
      icon: "assets/png/chat.png",
      label: 'Journal'.tr,
    ),
    NavItem(
      icon: "assets/png/add.png",
      label: 'Add'.tr,
    ),
    NavItem(
      icon: "assets/png/streaks.png",
      label: 'Sreaks'.tr,
    ),
    NavItem(
      icon: "assets/png/profile.png",
      label: 'My Profile'.tr,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkGreenBackground,
      child: Container(
        height: kBottomNavigationBarHeight + 10,
        decoration: BoxDecoration(
          color: AppColors.pillsGreen,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                _items.length,
                (index) => _buildNavItem(index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final bool isSelected = widget.currentIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque, // Makes entire area clickable
      onTap: () => widget.onTap(index),
      child: SizedBox(
        // Added SizedBox to enforce minimum height
        height: 50, // Minimum height of 45px for better touch target
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // Center content vertically
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.identity()..scale(isSelected ? 1.3 : 1.0),
                child: Column(
                  children: [
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.6),
                        BlendMode.srcIn,
                      ),
                      child: Image.asset(
                        _items[index].icon,
                        height: 20,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Padding(
                  padding: EdgeInsets.only(bottom: 0.0),
                  child: SizedBox(
                    height: 10,
                    width: 0,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final String icon;
  final String label;

  NavItem({
    required this.icon,
    required this.label,
  });
}
