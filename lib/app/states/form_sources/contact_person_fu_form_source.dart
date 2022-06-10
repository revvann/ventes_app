import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/contact_person_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart';
import 'package:ventes/app/states/form_validators/contact_person_fu_validator.dart';
import 'package:ventes/constants/strings/prospect_string.dart';

class ContactPersonFormUpdateFormSource {
  KeyableDropdownController<int, DBType> typeDropdownController = Get.put(
    KeyableDropdownController<int, DBType>(),
    tag: ProspectString.contactTypeCode,
  );

  SearchableDropdownController<Contact> contactDropdownController = Get.put(
    SearchableDropdownController<Contact>(),
    tag: ProspectString.localContactCode,
  );

  TextEditingController valueTEC = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late ContactPersonFormUpdateValidator validator;

  bool get isValid => formKey.currentState?.validate() ?? false;
  bool get isPhone => contacttype?.typename == "Phone";

  final Rx<DBType?> _contacttype = Rx<DBType?>(null);
  DBType? get contacttype => _contacttype.value;
  set contacttype(DBType? value) => _contacttype.value = value;

  final Rx<Contact?> _contact = Rx<Contact?>(null);
  Contact? get contact => _contact.value;
  set contact(Contact? value) => _contact.value = value;

  init() {
    validator = ContactPersonFormUpdateValidator(this);
  }

  close() {
    Get.delete<KeyableDropdownController<int, DBType>>(tag: ProspectString.contactTypeCode);
    valueTEC.clear();
  }

  void prepareFormValue(ContactPerson contact) {
    valueTEC.text = contact.contactvalueid ?? "";
    contacttype = contact.contacttype;
    typeDropdownController.selectedKeys = contact.contacttype?.typeid != null ? [contact.contacttype!.typeid!] : [];
  }

  Map<String, dynamic> toJson() {
    return {
      'contacttypeid': contacttype?.typeid?.toString(),
      'contactvalueid': isPhone ? contact?.phones?.first.value : valueTEC.text,
    };
  }
}
