part of 'package:ventes/app/states/controllers/contact_person_fc_state_controller.dart';

class _Listener extends RegularListener {
  _Properties get _properties => Get.find<_Properties>(tag: ProspectString.contactCreateTag);
  _FormSource get _formSource => Get.find<_FormSource>(tag: ProspectString.contactCreateTag);
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.contactCreateTag);

  void goBack() {
    Get.back(
      id: ProspectNavigator.id,
    );
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
      Get.find<TaskHelper>().loaderPush(_properties.task);
    } else {
      Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: "Form is not valid"));
    }
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateContactTaskCode);
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(_properties.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateContactTaskCode);
  }

  void onCreateDataSuccess(String message) {
    Get.find<TaskHelper>().successPush(_properties.task.copyWith(
        message: message,
        onFinished: () {
          Get.find<ContactPersonStateController>().properties.refresh();
          Get.back(id: ProspectNavigator.id);
        }));
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateContactTaskCode);
  }

  void onCreateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateContactTaskCode);
  }

  void onCreateDataError(String message) {
    Get.find<TaskHelper>().errorPush(_properties.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateContactTaskCode);
  }

  @override
  Future onRefresh() async {
    _properties.refresh();
  }
}
