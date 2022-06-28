import 'package:flutter/material.dart' hide MenuItem;

class BehaviorStyle extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
