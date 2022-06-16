import 'package:ventes/app/resources/widgets/regular_snackbar.dart';
import 'package:ventes/constants/regular_color.dart';

class SuccessSnackbar extends RegularSnackbar {
  SuccessSnackbar(String message) : super(message: message, icon: 'assets/svg/check.svg', color: RegularColor.green);
}
