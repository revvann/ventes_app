import 'package:ventes/app/states/form_sources/contact_person_fu_form_source.dart';

class ContactPersonFormUpdateValidator {
  late ContactPersonFormUpdateFormSource _formSource;
  ContactPersonFormUpdateValidator(this._formSource);

  String? contactvalue(String? value) {
    if (value == null || value.isEmpty) {
      return "Contact value is required";
    }
    return null;
  }
}
