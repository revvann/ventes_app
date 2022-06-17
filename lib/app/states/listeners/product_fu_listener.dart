part of 'package:ventes/app/states/controllers/product_fu_state_controller.dart';

class _Listener extends RegularListener {
  _FormSource get _formSource => Get.find<_FormSource>(tag: ProspectString.productUpdateTag);
  _Properties get _properties => Get.find<_Properties>(tag: ProspectString.productUpdateTag);
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.productUpdateTag);

  void goBack() {
    Get.back(
      id: ProspectNavigator.id,
    );
  }

  void onSubmitButtonClicked() {
    if (_formSource.isValid) {
      Map<String, dynamic> data = _formSource.toJson();
      _dataSource.updateData(_properties.productid, data);
      Get.find<TaskHelper>().loaderPush(_properties.task);
    } else {
      Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: "Please fill all required fields"));
    }
  }

  void onTaxChanged(item) {
    _formSource.prosproducttax = item.value;
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
        onFinished: () {
          Get.find<ProductStateController>().properties.refresh();
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

  @override
  Future onRefresh() async {
    _properties.refresh();
  }
}
