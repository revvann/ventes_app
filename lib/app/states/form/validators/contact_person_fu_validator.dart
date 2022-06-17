part of 'package:ventes/app/states/controllers/contact_person_fu_state_controller.dart';

class ContactPersonFormUpdateValidator {
  String? contactvalue(String? value) {
    if (value == null || value.isEmpty) {
      return "Contact value is required";
    }
    return null;
  }
}
