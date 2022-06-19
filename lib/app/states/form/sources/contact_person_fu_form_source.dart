import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart';
import 'package:ventes/app/states/form/validators/contact_person_fu_validator.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/update_form_source.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/typedefs/contact_person_fu_typedef.dart';

class ContactPersonFormUpdateFormSource extends UpdateFormSource {
  DataSource get _dataSource => Get.find<DataSource>(tag: ProspectString.contactUpdateTag);
  Property get _property => Get.find<Property>(tag: ProspectString.contactUpdateTag);

  SearchableDropdownController<Contact> contactDropdownController = Get.put(
    SearchableDropdownController<Contact>(),
    tag: ProspectString.localContactCode,
  );

  TextEditingController valueTEC = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ContactPersonFormUpdateValidator validator = ContactPersonFormUpdateValidator();

  bool get isValid => formKey.currentState?.validate() ?? false;
  bool get isPhone => contacttype?.typename == "Phone";

  final Rx<DBType?> _contacttype = Rx<DBType?>(null);
  DBType? get contacttype => _contacttype.value;
  set contacttype(DBType? value) => _contacttype.value = value;

  final Rx<Contact?> _contact = Rx<Contact?>(null);
  Contact? get contact => _contact.value;
  set contact(Contact? value) => _contact.value = value;

  @override
  close() {
    super.close();
    Get.delete<SearchableDropdownController<Contact>>(tag: ProspectString.localContactCode);
    valueTEC.clear();
  }

  @override
  void prepareFormValues() {
    valueTEC.text = _dataSource.contactPerson?.contactvalueid ?? "";
    contacttype = _dataSource.contactPerson?.contacttype;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'contactvalueid': isPhone ? contact?.phones?.first.value : valueTEC.text,
    };
  }

  @override
  void onSubmit() {
    if (isValid) {
      Map<String, dynamic> data = toJson();
      _dataSource.updateData(data);
      Get.find<TaskHelper>().loaderPush(_property.task);
    } else {
      Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: "Form is not valid"));
    }
  }
}
