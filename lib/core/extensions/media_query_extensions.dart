import 'package:flutter/material.dart';

extension MediaQueryExtensions on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  Size get screenSize => MediaQuery.sizeOf(this);
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;
  TextScaler get textScaler => MediaQuery.of(this).textScaler;
  bool get isLandscape =>
      MediaQuery.sizeOf(this).width > MediaQuery.sizeOf(this).height;

  double widthPercent(double percent) => screenWidth * percent;
  double heightPercent(double percent) => screenHeight * percent;
}
