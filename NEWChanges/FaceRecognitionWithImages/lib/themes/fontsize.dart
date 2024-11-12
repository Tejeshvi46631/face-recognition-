import 'package:flutter/material.dart';

class FontSizeManager {
  final double screenWidth;
  final double screenHeight;
  final double defaultFontSize;

  FontSizeManager(BuildContext context, {this.defaultFontSize = 16.0})
      : screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height;

  double calculateFontSize(double percentageOfScreenWidth) {
    return screenWidth * percentageOfScreenWidth;
  }

  double calculateHeight(double percentageOfScreenHeight) {
    return screenHeight * percentageOfScreenHeight;
  }
}
