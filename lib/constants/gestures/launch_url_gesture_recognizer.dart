import 'package:flutter/gestures.dart';
import 'package:ventes/utils/utils.dart';

class LaunchUrlGestureRecognizer extends TapGestureRecognizer {
  String url;
  LaunchUrlGestureRecognizer(this.url);

  @override
  Function()? get onTap => () {
        Utils.launchUrl(url);
      };
}
