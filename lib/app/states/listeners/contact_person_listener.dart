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
    Get.find<TaskHelper>().loaderPush(ProspectString.contactPersonTaskCode);
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.contactPersonTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.contactPersonTaskCode);
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.contactPersonTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.contactPersonTaskCode);
  }

  void onDeleteFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.contactPersonTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.contactPersonTaskCode);
  }

  void onDeleteSuccess(String message) {
    Get.find<TaskHelper>().successPush(ProspectString.contactPersonTaskCode, message, () async {
      Get.find<ContactPersonStateController>().refreshStates();
    });
    Get.find<TaskHelper>().loaderPop(ProspectString.contactPersonTaskCode);
  }

  void onDeleteError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.contactPersonTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.contactPersonTaskCode);
  }

  @override
  Future onRefresh() async {
    _properties.refresh();
  }
}
