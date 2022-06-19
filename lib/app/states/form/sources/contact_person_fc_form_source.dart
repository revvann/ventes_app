import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/contact_person_fc_typedef.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/helpers/task_helper.dart';

class ContactPersonFormCreateFormSource extends StateFormSource {
  Property get _property => Get.find<Property>(tag: ProspectString.contactCreateTag);
  DataSource get _dataSource => Get.find<DataSource>(tag: ProspectString.contactCreateTag);

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

  Validator validator = Validator();

  bool get isValid => formKey.currentState?.validate() ?? false;
  bool get isPhone => contacttype?.typename == "Phone";

  final Rx<DBType?> _contacttype = Rx<DBType?>(null);
  DBType? get contacttype => _contacttype.value;
  set contacttype(DBType? value) => _contacttype.value = value;

  final Rx<Contact?> _contact = Rx<Contact?>(null);
  Contact? get contact => _contact.value;
  set contact(Contact? value) => _contact.value = value;

  int? customerid;

  @override
  close() {
    super.close();
    Get.delete<KeyableDropdownController<int, DBType>>(tag: ProspectString.contactTypeCode);
    Get.delete<SearchableDropdownController<Contact>>(tag: ProspectString.localContactCode);
    valueTEC.dispose();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'contacttypeid': contacttype?.typeid?.toString(),
      'contactvalueid': isPhone ? contact?.phones?.first.value : valueTEC.text,
      'contactcustomerid': customerid?.toString(),
    };
  }

  @override
  void onSubmit() {
    if (isValid) {
      Map<String, dynamic> data = toJson();
      _dataSource.createData(data);
      Get.find<TaskHelper>().loaderPush(_property.task);
    } else {
      Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: "Form is not valid"));
    }
  }
}
