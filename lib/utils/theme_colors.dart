import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemeColors {
  static ThemeProvider _provider(BuildContext context) {
    return Provider.of<ThemeProvider>(context, listen: false);
  }

  static Color backgroundColor(BuildContext context) =>
      _provider(context).backgroundColor;

  static Color headerColor(BuildContext context) =>
      _provider(context).headerColor;

  static Color cardColor(BuildContext context) =>
      _provider(context).cardColor;

  static Color textColor(BuildContext context) =>
      _provider(context).textColor;

  static Color textSecondaryColor(BuildContext context) =>
      _provider(context).textSecondaryColor;

  static Color navBarColor(BuildContext context) =>
      _provider(context).navBarColor;

  static Color navBarSelectedColor(BuildContext context) =>
      _provider(context).navBarSelectedColor;

  static Color navBarUnselectedColor(BuildContext context) =>
      _provider(context).navBarUnselectedColor;

  static Color searchBarColor(BuildContext context) =>
      _provider(context).searchBarColor;

  static Color searchTextColor(BuildContext context) =>
      _provider(context).searchTextColor;

  static Color buttonColor(BuildContext context) =>
      _provider(context).buttonColor;

  static Color categorySelectedColor(BuildContext context) =>
      _provider(context).categorySelectedColor;

  static Color categoryUnselectedColor(BuildContext context) =>
      _provider(context).categoryUnselectedColor;
}

