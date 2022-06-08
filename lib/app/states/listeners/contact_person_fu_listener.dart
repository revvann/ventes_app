import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/controllers/contact_person_fu_state_controller.dart';
import 'package:ventes/app/states/controllers/contact_person_state_controller.dart';
import 'package:ventes/app/states/data_sources/contact_person_fu_data_source.dart';
import 'package:ventes/app/states/form_sources/contact_person_fu_form_source.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ContactPersonFormUpdateListener {
  ContactPersonFormUpdateProperties get _properties => Get.find<ContactPersonFormUpdateProperties>();
  ContactPersonFormUpdateFormSource get _formSource => Get.find<ContactPersonFormUpdateFormSource>();
  ContactPersonFormUpdateDataSource get _dataSource => Get.find<ContactPersonFormUpdateDataSource>();

  void goBack() {
    Get.back(
      id: ProspectNavigator.id,
    );
  }

  Future onRefresh() async {
    _properties.refresh();
  }

  void onTypeSelected(type) {
    _formSource.contacttype = type.value;
  }

  Future<List<Contact>> onContactFilter(String? search) async {
    return await ContactsService.getContacts(query: search);
  }

  void onContactChanged(contactItem) {
    _formSource.contact = contactItem.value;
  }

  bool onContactCompared(selectedItem, item) {
    return selectedItem == item;
  }

  void onSubmitButtonClicked() {
    if (_formSource.isValid) {
      Map<String, dynamic> data = _formSource.toJson();
      _dataSource.updateData(data);
      Get.find<TaskHelper>().loaderPush(ProspectString.formUpdateContactTaskCode);
    } else {
      Get.find<TaskHelper>().failedPush(ProspectString.formUpdateContactTaskCode, "Form is not valid");
    }
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.formUpdateContactTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateContactTaskCode);
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.formUpdateContactTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateContactTaskCode);
  }

  void onUpdateDataSuccess(String message) {
    Get.find<TaskHelper>().successPush(ProspectString.formUpdateContactTaskCode, message, () {
      Get.find<ContactPersonStateController>().properties.refresh();
      Get.back(id: ProspectNavigator.id);
    });
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateContactTaskCode);
  }

  void onUpdateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.formUpdateContactTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateContactTaskCode);
  }

  void onUpdateDataError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.formUpdateContactTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateContactTaskCode);
  }
}
