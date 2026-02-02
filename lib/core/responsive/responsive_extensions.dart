import 'package:flutter/material.dart';

import 'breakpoints.dart';

/// Convenience getters and helpers on [BuildContext] for querying screen
/// dimensions and selecting values based on the current [Breakpoint].
extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  Breakpoint get breakpoint => Breakpoint.fromWidth(screenWidth);

  bool get isMobile => breakpoint == Breakpoint.mobile;
  bool get isDesktop => breakpoint == Breakpoint.desktop;

  T responsive<T>({
    required T mobile,
    T? desktop,
  }) {
    return switch (breakpoint) {
      Breakpoint.desktop => desktop ?? mobile,
      Breakpoint.mobile => mobile,
    };
  }
}
