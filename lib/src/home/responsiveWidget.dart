import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget largeScreen;
  final Widget mediumScreen;
  final Widget smallScreen;
  final Widget smallheight;
  const ResponsiveWidget(
      {Key? key,
      required this.largeScreen,
      required this.mediumScreen,
      required this.smallScreen,
      required this.smallheight})
      : super(key: key);

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 770;
  }

  static bool isSmallHeight(BuildContext context) {
    return MediaQuery.of(context).size.height < 465;
  }

  static bool isMediumHeight(BuildContext context) {
    return MediaQuery.of(context).size.height < 623;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1007;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 640 &&
        MediaQuery.of(context).size.width <= 1007;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 588) {
          return largeScreen;
        } else if (constraints.maxWidth < 960) {
          return mediumScreen;
        } else {
          return smallScreen;
        }

        // if (constraints.maxWidth > 1200) {
        //   return largeScreen;
        // } else if (constraints.maxWidth <= 1200 &&
        //     constraints.maxWidth >= 800) {
        //   return mediumScreen ?? largeScreen;
        // } else {
        //   return smallScreen ?? largeScreen;
        // }
      },
    );
  }
}
