import 'package:flutter/material.dart';

class OverScrollDisable extends StatelessWidget {
  final Widget child;
  OverScrollDisable({this.child});
  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowGlow();
      },
      child: child,
    );
  }
}
