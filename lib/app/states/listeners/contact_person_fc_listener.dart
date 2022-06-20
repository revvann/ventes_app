import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/contact_person_state_controller.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/app/states/typedefs/contact_person_fc_typedef.dart';

class ContactPersonFormCreateListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(
      id: ProspectNavigator.id,
    );
  }

  void onTypeSelected(type) {
    formSource.contacttype = type.value;
  }

  Future<List<Contact>> onContactFilter(String? search) async {
    return await ContactsService.getContacts(
      query: search,
      withThumbnails: false,
      photoHighResolution: false,
    );
  }

  void onContactChanged(contactItem) {
    formSource.contact = contactItem.value;
  }

  bool onContactCompared(selectedItem, item) {
    return selectedItem == item;
  }

  void onSubmitButtonClicked() {
    Get.find<TaskHelper>().confirmPush(
      property.task.copyWith<bool>(
        message: ProspectString.createContactConfirm,
        onFinished: (res) {
          if (res) {
            formSource.onSubmit();
          }
        },
      ),
    );
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(property.task.copyWith(message: message, snackbar: true));
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(property.task.copyWith(message: message));
  }

  void onCreateDataSuccess(String message) {
    Get.find<TaskHelper>().successPush(property.task.copyWith(
        message: message,
        onFinished: (res) {
          Get.find<ContactPersonStateController>().property.refresh();
          Get.back(id: ProspectNavigator.id);
        }));
  }

  void onCreateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(property.task.copyWith(message: message, snackbar: true));
  }

  void onCreateDataError(String message) {
    Get.find<TaskHelper>().errorPush(property.task.copyWith(message: message));
  }

  void onComplete() => Get.find<TaskHelper>().loaderPop(property.task.name);
  @override
  Future onReady() async {
    property.refresh();
  }
}
