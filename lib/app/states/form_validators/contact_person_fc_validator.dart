import 'package:ventes/app/states/form_sources/contact_person_fc_form_source.dart';

class ContactPersonFormCreateValidator {
  late ContactPersonFormCreateFormSource _formSource;
  ContactPersonFormCreateValidator(this._formSource);

  String? contactvalue(String? value) {
    if (value == null || value.isEmpty) {
      return "Contact value is required";
    }
    return null;
  }
}
