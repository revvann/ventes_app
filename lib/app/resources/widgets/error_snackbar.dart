import 'package:ventes/app/resources/widgets/regular_snackbar.dart';
import 'package:ventes/constants/regular_color.dart';

class ErrorSnackbar extends RegularSnackbar {
  ErrorSnackbar(String message) : super(message: message, icon: 'assets/svg/close.svg', color: RegularColor.red);
}
