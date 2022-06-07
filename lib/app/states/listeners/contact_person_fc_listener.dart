import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/contact_person_fc_state_controller.dart';
import 'package:ventes/app/states/controllers/contact_person_state_controller.dart';
import 'package:ventes/app/states/data_sources/contact_person_fc_data_source.dart';
import 'package:ventes/app/states/form_sources/contact_person_fc_form_source.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ContactPersonFormCreateListener {
  ContactPersonFormCreateProperties get _properties => Get.find<ContactPersonFormCreateProperties>();
  ContactPersonFormCreateFormSource get _formSource => Get.find<ContactPersonFormCreateFormSource>();
  ContactPersonFormCreateDataSource get _dataSource => Get.find<ContactPersonFormCreateDataSource>();

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
      _dataSource.createData(data);
      Get.find<TaskHelper>().loaderPush(ProspectString.formCreateContactTaskCode);
    } else {
      Get.find<TaskHelper>().failedPush(ProspectString.formCreateContactTaskCode, "Form is not valid");
    }
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.formCreateContactTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateContactTaskCode);
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.formCreateContactTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateContactTaskCode);
  }

  void onCreateDataSuccess(String message) {
    Get.find<TaskHelper>().successPush(ProspectString.formCreateContactTaskCode, message, () {
      Get.find<ContactPersonStateController>().properties.refresh();
      Get.back(id: ProspectNavigator.id);
    });
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateContactTaskCode);
  }

  void onCreateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.formCreateContactTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateContactTaskCode);
  }

  void onCreateDataError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.formCreateContactTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateContactTaskCode);
  }
}
