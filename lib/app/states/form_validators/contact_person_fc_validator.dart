part of 'package:ventes/app/states/controllers/contact_person_fc_state_controller.dart';

class _Validator {
  String? contactvalue(String? value) {
    if (value == null || value.isEmpty) {
      return "Contact value is required";
    }
    return null;
  }
}
