import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/contact_person_state_controller.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/app/states/typedefs/contact_person_fc_typedef.dart';

class ContactPersonFormCreateListener extends StateListener {
  Property get _property => Get.find<Property>(tag: ProspectString.contactCreateTag);
  FormSource get _formSource => Get.find<FormSource>(tag: ProspectString.contactCreateTag);

  void goBack() {
    Get.back(
      id: ProspectNavigator.id,
    );
  }

  void onTypeSelected(type) {
    _formSource.contacttype = type.value;
  }

  Future<List<Contact>> onContactFilter(String? search) async {
    return await ContactsService.getContacts(
      query: search,
      withThumbnails: false,
      photoHighResolution: false,
    );
  }

  void onContactChanged(contactItem) {
    _formSource.contact = contactItem.value;
  }

  bool onContactCompared(selectedItem, item) {
    return selectedItem == item;
  }

  void onSubmitButtonClicked() {
    Get.find<TaskHelper>().confirmPush(
      _property.task.copyWith<bool>(
        message: ProspectString.createContactConfirm,
        onFinished: (res) {
          if (res) {
            _formSource.onSubmit();
          }
        },
      ),
    );
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateContactTaskCode);
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateContactTaskCode);
  }

  void onCreateDataSuccess(String message) {
    Get.find<TaskHelper>().successPush(_property.task.copyWith(
        message: message,
        onFinished: (res) {
          Get.find<ContactPersonStateController>().property.refresh();
          Get.back(id: ProspectNavigator.id);
        }));
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateContactTaskCode);
  }

  void onCreateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateContactTaskCode);
  }

  void onCreateDataError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateContactTaskCode);
  }

  @override
  Future onReady() async {
    _property.refresh();
  }
}
