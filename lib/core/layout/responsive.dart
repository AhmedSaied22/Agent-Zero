import 'package:elgassos/core/extensions/media_query_extensions.dart';
import 'package:elgassos/core/utils/size_config.dart';
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;
  final double mobileBreakpoint;
  final double tabletBreakpoint;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
    this.mobileBreakpoint = SizeConfig.tabletBreakPoint, // 599
    this.tabletBreakpoint = SizeConfig.desktopBreakPoint, // 1199
  });

  static bool isMobile(BuildContext context) =>
      context.screenWidth <= SizeConfig.tabletBreakPoint;

  static bool isTablet(BuildContext context) {
    final width = context.screenWidth;
    return width > SizeConfig.tabletBreakPoint &&
        width <= SizeConfig.desktopBreakPoint;
  }

  static bool isDesktop(BuildContext context) =>
      context.screenWidth > SizeConfig.desktopBreakPoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width > tabletBreakpoint) {
          return desktop;
        } else if (width > mobileBreakpoint) {
          return tablet ?? desktop;
        } else {
          return mobile;
        }
      },
    );
  }
}
