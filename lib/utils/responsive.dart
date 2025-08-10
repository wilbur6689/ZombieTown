import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Mobile-focused responsive design (landscape orientation)
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isSmallMobile(BuildContext context) {
    // Phones in landscape (usually around 640-720px wide)
    return getScreenWidth(context) < 750;
  }

  static bool isLargeMobile(BuildContext context) {
    // Larger phones/small tablets in landscape (750px+)
    return getScreenWidth(context) >= 750;
  }

  static bool isTablet(BuildContext context) {
    // Tablets (typically 768px+ wide)
    return getScreenWidth(context) >= 768 && getScreenWidth(context) < 1200;
  }

  static bool isDesktop(BuildContext context) {
    // Desktop screens (1200px+ wide)
    return getScreenWidth(context) >= 1200;
  }

  static EdgeInsets getScreenPadding(BuildContext context) {
    // Optimized for mobile landscape - less vertical padding, more horizontal
    if (isLargeMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    } else {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    }
  }

  static double getButtonWidth(BuildContext context) {
    // Button sizes optimized for mobile landscape
    if (isLargeMobile(context)) {
      return 220;
    } else {
      return 180;
    }
  }

  static double getButtonHeight(BuildContext context) {
    // Taller buttons for mobile touch targets
    return 50;
  }

  static double getFontSize(BuildContext context, {required double baseFontSize}) {
    // Slight scaling for larger mobile screens
    if (isLargeMobile(context)) {
      return baseFontSize * 1.1;
    } else {
      return baseFontSize;
    }
  }

  static double getTitleFontSize(BuildContext context) {
    if (isLargeMobile(context)) {
      return 28;
    } else {
      return 24;
    }
  }

  static double getIconSize(BuildContext context, {double baseSize = 24}) {
    if (isLargeMobile(context)) {
      return baseSize * 1.2;
    } else {
      return baseSize;
    }
  }

  static int getCrossAxisCount(BuildContext context, {int baseCount = 2}) {
    // Grid layouts for mobile landscape
    if (isLargeMobile(context)) {
      return baseCount + 1;
    } else {
      return baseCount;
    }
  }

  static double getCardHeight(BuildContext context) {
    // Card heights optimized for landscape mobile
    return getScreenHeight(context) * 0.25;
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context) && desktop != null) {
      return desktop!;
    } else if (ResponsiveHelper.isTablet(context) && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? 1200,
        ),
        padding: ResponsiveHelper.getScreenPadding(context),
        child: child,
      ),
    );
  }
}