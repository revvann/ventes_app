import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

class CopyGestureRecognizer extends TapGestureRecognizer {
  String copiableText;
  CopyGestureRecognizer(this.copiableText);

  @override
  Function()? get onTap => () {
        Clipboard.setData(ClipboardData(text: copiableText));
      };
}
