import 'package:ventes/app/states/typedefs/contact_person_fu_typedef.dart';

class ContactPersonFormUpdateValidator {
  late FormSource _formSource;
  set formSource(FormSource value) => _formSource = value;

  String? contactvalue(String? value) {
    if (!_formSource.isPhone) {
      if (value == null || value.isEmpty) {
        return "Contact value is required";
      }
    }
    return null;
  }

  String? contactname(String? value) {
    if (value == null || value.isEmpty) {
      return "Contact name is required";
    }
    return null;
  }
}
