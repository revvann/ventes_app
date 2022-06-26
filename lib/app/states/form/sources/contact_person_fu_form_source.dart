import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/update_form_source.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/typedefs/contact_person_fu_typedef.dart';

class ContactPersonFormUpdateFormSource extends UpdateFormSource with FormSourceMixin {
  Validator validator = Validator();

  SearchableDropdownController<Contact> contactDropdownController = Get.put(
    SearchableDropdownController<Contact>(),
    tag: ProspectString.localContactCode,
  );

  TextEditingController valueTEC = TextEditingController();
  TextEditingController nameTEC = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool get isValid => formKey.currentState?.validate() ?? false;
  bool get isPhone => contacttype?.typename == "Phone";

  final Rx<DBType?> _contacttype = Rx<DBType?>(null);
  DBType? get contacttype => _contacttype.value;
  set contacttype(DBType? value) => _contacttype.value = value;

  final Rx<Contact?> _contact = Rx<Contact?>(null);
  Contact? get contact => _contact.value;
  set contact(Contact? value) => _contact.value = value;

  @override
  void init() {
    super.init();
    validator.formSource = this;
  }

  @override
  close() {
    super.close();
    Get.delete<SearchableDropdownController<Contact>>(tag: ProspectString.localContactCode);
    valueTEC.clear();
  }

  @override
  void prepareFormValues() async {
    Get.find<TaskHelper>().loaderPush(Task('contactgetlist'));
    List<Contact> contacts = await ContactsService.getContactsForPhone(dataSource.contactPerson?.contactvalueid);
    Get.find<TaskHelper>().loaderPop('contactgetlist');
    Contact? contact = contacts.isNotEmpty ? contacts.first : null;

    if (contact != null) {
      contactDropdownController.selectedKeys = [contact];
      this.contact = contact;
    } else {
      valueTEC.text = dataSource.contactPerson?.contactvalueid ?? "";
    }

    contacttype = dataSource.contactPerson?.contacttype;
    nameTEC.text = dataSource.contactPerson?.contactname ?? "";
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'contactvalueid': isPhone
          ? valueTEC.text.isNotEmpty
              ? valueTEC.text
              : contact?.phones?.first.value
          : valueTEC.text,
      'contactname': nameTEC.text,
    };
  }

  @override
  void onSubmit() {
    if (isValid) {
      Map<String, dynamic> data = toJson();
      dataSource.updateHandler.fetcher.run(property.contactid, data);
    } else {
      Get.find<TaskHelper>().failedPush(property.task.copyWith(message: "Form is not valid"));
    }
  }
}
