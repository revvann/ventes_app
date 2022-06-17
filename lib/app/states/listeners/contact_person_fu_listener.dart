part of 'package:ventes/app/states/controllers/contact_person_fu_state_controller.dart';

class ContactPersonFormUpdateListener extends StateListener {
  ContactPersonFormUpdateProperty get _properties => Get.find<ContactPersonFormUpdateProperty>(tag: ProspectString.contactUpdateTag);
  ContactPersonFormUpdateFormSource get _formSource => Get.find<ContactPersonFormUpdateFormSource>(tag: ProspectString.contactUpdateTag);
  ContactPersonFormUpdateDataSource get _dataSource => Get.find<ContactPersonFormUpdateDataSource>(tag: ProspectString.contactUpdateTag);

  void goBack() {
    Get.back(
      id: ProspectNavigator.id,
    );
  }

  @override
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
    Get.find<TaskHelper>().confirmPush(
      _properties.task.copyWith<bool>(
        message: ProspectString.updateContactConfirm,
        onFinished: (res) {
          if (res) {
            _formSource.onSubmit();
          }
        },
      ),
    );
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(_properties.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onUpdateDataSuccess(String message) {
    Get.find<TaskHelper>().successPush(_properties.task.copyWith(
        message: message,
        onFinished: (res) {
          Get.find<ContactPersonStateController>().properties.refresh();
          Get.back(id: ProspectNavigator.id);
        }));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onUpdateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onUpdateDataError(String message) {
    Get.find<TaskHelper>().errorPush(_properties.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }
}
