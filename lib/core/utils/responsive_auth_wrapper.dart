import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ResponsiveAuthWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveAuthWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop ||
            sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
          return Center(
            child: ConstrainedBox(
              constraints:  BoxConstraints(maxWidth: 500),
              child: child,
            ),
          );
        }
        
        return child;
      },
    );
  }
}
