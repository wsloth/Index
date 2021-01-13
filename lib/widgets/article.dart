import 'package:flutter/material.dart';

/// Calculates the intensity of the redness, based on the weight of
/// the score. When the app is being used in light mode, it will
/// calculated based on the color black. When used in dark mode, it
/// will calculate based on the color white.
Color calculateArticleScoreRGBA(BuildContext context, int score) {
  // Check if we are running in dark or light mode
  final ThemeData mode = Theme.of(context);
  final bool isDarkMode = mode.brightness == Brightness.dark;

  // Calculate how intensely red the score should
  final int tempCalculatedRedBasedOnScore = (score / 1.5).floor();
  final int calculatedRedForLightMode = tempCalculatedRedBasedOnScore > 255 ? 255 : tempCalculatedRedBasedOnScore;
  final int calculatedRed = isDarkMode ? 255 : calculatedRedForLightMode;
  final int calculatedGreen = isDarkMode ? 255 - calculatedRedForLightMode : 0;
  final int calculatedBlue = isDarkMode ? 255 - calculatedRedForLightMode : 0;

  return Color.fromRGBO(
    calculatedRed,
    calculatedGreen,
    calculatedBlue,
    1,
  );
}

Widget getArticleScoreStylizedText(BuildContext context, int score) {
  final Color textColor = calculateArticleScoreRGBA(context, score);

  return Text("+$score",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        // The higher the score, the redder the text will be
        color: textColor,
      ));
}
