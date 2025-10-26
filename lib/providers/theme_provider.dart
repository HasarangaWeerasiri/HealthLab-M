import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;
  static const String _key = 'theme_mode';

  bool get isDarkMode => _isDarkMode;

  // Dark Mode Colors
  static const Color _darkBackground = Color(0xFF201E1A);
  static const Color _darkHeader = Color(0xFF00432D);
  static const Color _darkCard = Color(0xFF00432D);
  static const Color _darkText = Color(0xFFE6FDD8);
  static const Color _darkTextSecondary = Color(0xFFEDFDDE);
  static const Color _darkNavBar = Color(0xFF366A49);
  static const Color _darkNavBarSelected = Color(0xFFEDFDDE);
  static const Color _darkNavBarUnselected = Color(0xFF1F412A);
  static const Color _darkSearchBar = Color(0xFFEBFBD9);
  static const Color _darkSearchText = Color(0xFF1E4029);
  static const Color _darkButton = Color(0xFF4CAF50);
  static const Color _darkCategorySelected = Color(0xFFCDEDC6);
  static const Color _darkCategoryUnselected = Color(0xFFFFFFFF);

  // Light Mode Colors
  static const Color _lightBackground = Color(0xFFF5F5F5);
  static const Color _lightHeader = Color(0xFF1B5E3F); // Darker green for better visibility
  static const Color _lightCard = Color(0xFFFFFFFF);
  static const Color _lightText = Color(0xFF2E7D5A); // Lighter green for readability
  static const Color _lightTextSecondary = Color(0xFF1E4029);
  static const Color _lightNavBar = Color(0xFFE8F5E9);
  static const Color _lightNavBarSelected = Color(0xFF4CAF50); // Bright green
  static const Color _lightNavBarUnselected = Color(0xFFB0BEC5);
  static const Color _lightSearchBar = Color(0xFFE0E0E0);
  static const Color _lightSearchText = Color(0xFF212121);
  static const Color _lightButton = Color(0xFF2E7D5A);
  static const Color _lightCategorySelected = Color(0xFFA5D6A7);
  static const Color _lightCategoryUnselected = Color(0xFF757575);

  ThemeProvider() {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_key) ?? true;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, _isDarkMode);
    notifyListeners();
  }

  // Get colors based on current theme
  Color get backgroundColor => _isDarkMode ? _darkBackground : _lightBackground;
  Color get headerColor => _isDarkMode ? _darkHeader : _lightHeader;
  Color get cardColor => _isDarkMode ? _darkCard : _lightCard;
  Color get textColor => _isDarkMode ? _darkText : _lightText;
  Color get textSecondaryColor => _isDarkMode ? _darkTextSecondary : _lightTextSecondary;
  Color get navBarColor => _isDarkMode ? _darkNavBar : _lightNavBar;
  Color get navBarSelectedColor => _isDarkMode ? _darkNavBarSelected : _lightNavBarSelected;
  Color get navBarUnselectedColor => _isDarkMode ? _darkNavBarUnselected : _lightNavBarUnselected;
  Color get searchBarColor => _isDarkMode ? _darkSearchBar : _lightSearchBar;
  Color get searchTextColor => _isDarkMode ? _darkSearchText : _lightSearchText;
  Color get buttonColor => _isDarkMode ? _darkButton : _lightButton;
  Color get categorySelectedColor => _isDarkMode ? _darkCategorySelected : _lightCategorySelected;
  Color get categoryUnselectedColor => _isDarkMode ? _darkCategoryUnselected : _lightCategoryUnselected;
  Color get headerTextColor => _isDarkMode ? _darkText : Colors.white;
}

