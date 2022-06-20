import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:ventes/app/resources/widgets/failed_snackbar.dart';
import 'package:ventes/app/resources/widgets/success_snackbar.dart';

class CopyGestureRecognizer extends TapGestureRecognizer {
  String copiableText;
  CopyGestureRecognizer(this.copiableText);

  @override
  Function()? get onTap => () {
        Clipboard.setData(ClipboardData(text: copiableText)).then((res) => SuccessSnackbar("Copié dans le presse-papier").show()).catchError((err) => FailedSnackbar("Impossible de copier").show());
      };
}
