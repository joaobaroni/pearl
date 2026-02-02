/// Screen-width breakpoints used to drive responsive layout decisions.
enum Breakpoint {
  mobile(0),
  desktop(600);

  final double minWidth;
  const Breakpoint(this.minWidth);

  static Breakpoint fromWidth(double width) {
    if (width >= desktop.minWidth) return desktop;
    return mobile;
  }
}
