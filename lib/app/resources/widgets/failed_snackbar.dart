import 'package:ventes/app/resources/widgets/regular_snackbar.dart';
import 'package:ventes/constants/regular_color.dart';

class FailedSnackbar extends RegularSnackbar {
  FailedSnackbar(String message) : super(message: message, icon: 'assets/svg/warning.svg', color: RegularColor.yellow);
}
