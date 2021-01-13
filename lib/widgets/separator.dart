import 'package:flutter/material.dart';
import 'package:index/utils/theming.dart';

/// Generates a separator line which automatically
/// re-styles based on the theme.
class Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theming.isDarkMode(context);
    return Divider(
      color: isDarkMode ? Colors.grey : Colors.black12,
      height: 10,
      thickness: 1,
    );
  }
}
