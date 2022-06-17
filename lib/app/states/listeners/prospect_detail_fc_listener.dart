part of 'package:ventes/app/states/controllers/prospect_detail_fc_state_controller.dart';

class ProspectDetailFormCreateListener extends StateListener {
  ProspectDetailFormCreateProperty get _properties => Get.find<ProspectDetailFormCreateProperty>(tag: ProspectString.detailCreateTag);
  ProspectDetailFormCreateFormSource get _formSource => Get.find<ProspectDetailFormCreateFormSource>(tag: ProspectString.detailCreateTag);
  ProspectDetailFormCreateDataSource get _dataSource => Get.find<ProspectDetailFormCreateDataSource>(tag: ProspectString.detailCreateTag);

  void goBack() {
    Get.back(
      id: ProspectNavigator.id,
    );
  }

  void onDateSelected(DateTime? date) {
    _formSource.date = date;
  }

  void onCategorySelected(category) {
    _formSource.prosdtcategory = category.value;
  }

  void onTypeSelected(type) {
    _formSource.prosdttype = type.value;
  }

  void onMapControllerCreated(GoogleMapController? controller) {
    if (!_properties.mapsController.isCompleted) {
      _properties.mapsController.complete(controller);
    }
  }

  void onSubmitButtonClicked() {
    Get.find<TaskHelper>().confirmPush(
      _properties.task.copyWith<bool>(
        message: ProspectString.createDetailConfirm,
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

  void onCreateDataSuccess(String message) {
    Get.find<TaskHelper>().successPush(_properties.task.copyWith(
        message: message,
        onFinished: (res) {
          Get.find<ProspectDetailStateController>().properties.refresh();
          Get.back(id: ProspectNavigator.id);
        }));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onCreateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onCreateDataError(String message) {
    Get.find<TaskHelper>().errorPush(_properties.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  @override
  Future onRefresh() async {
    _properties.refresh();
  }
}
