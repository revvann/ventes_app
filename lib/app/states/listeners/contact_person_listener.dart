part of 'package:ventes/app/states/controllers/contact_person_state_controller.dart';

class _Listener extends RegularListener {
  _Properties get _properties => Get.find<_Properties>(tag: ProspectString.contactTag);
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.contactTag);

  void goBack() {
    Get.back(id: ProspectNavigator.id);
  }

  void onAddButtonClicked() {
    Get.toNamed(
      ContactPersonFormCreateView.route,
      id: ProspectNavigator.id,
      arguments: {
        'customer': _properties.customerid,
      },
    );
  }

  void navigateToUpdateForm(int contactid) {
    Get.toNamed(
      ContactPersonFormUpdateView.route,
      id: ProspectNavigator.id,
      arguments: {
        'contact': contactid,
      },
    );
  }

  void deleteData(int id) {
    _dataSource.deleteData(id);
    Get.find<TaskHelper>().loaderPush(_properties.task);
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(_properties.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onDeleteFailed(String message) {
    Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onDeleteSuccess(String message) {
    Get.find<TaskHelper>().successPush(_properties.task.copyWith(
        snackbar: true,
        message: message,
        onFinished: () async {
          Get.find<ContactPersonStateController>().refreshStates();
        }));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onDeleteError(String message) {
    Get.find<TaskHelper>().errorPush(_properties.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  @override
  Future onRefresh() async {
    _properties.refresh();
  }
}
