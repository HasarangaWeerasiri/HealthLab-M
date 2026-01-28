import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: themeProvider.navBarColor.withOpacity(0.3), // Transparent background
            borderRadius: BorderRadius.circular(35),
          ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(context, 0, 'assets/icons/home (2).png'),
            _buildNavItem(context, 1, 'assets/icons/chemistry.png'),
            _buildNavItem(context, 2, 'assets/icons/plus.png'),
            _buildNavItem(context, 3, 'assets/icons/user (3).png'),
          ],
        ),
      ),
        );
      },
    );
  }

  Widget _buildNavItem(BuildContext context, int index, String iconPath) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isSelected = selectedIndex == index;
        
        return Expanded(
          child: GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected 
                    ? themeProvider.navBarSelectedColor
                    : themeProvider.navBarUnselectedColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 28,
                  height: 28,
                  color: isSelected 
                      ? (themeProvider.isDarkMode ? Colors.black.withOpacity(0.8) : Colors.white)
                      : Colors.white.withOpacity(0.6),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
