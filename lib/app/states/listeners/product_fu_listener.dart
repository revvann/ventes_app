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
      Get.find<TaskHelper>().loaderPush(ProspectString.formUpdateProductTaskCode);
    } else {
      Get.find<TaskHelper>().failedPush(ProspectString.formUpdateProductTaskCode, "Please fill all required fields");
    }
  }

  void onTaxChanged(item) {
    _formSource.prosproducttax = item.value;
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.formUpdateProductTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateProductTaskCode);
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.formUpdateProductTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateProductTaskCode);
  }

  void onUpdateDataSuccess(String message) {
    Get.find<TaskHelper>().successPush(ProspectString.formUpdateProductTaskCode, message, () {
      Get.find<ProductStateController>().properties.refresh();
      Get.back(id: ProspectNavigator.id);
    });
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateProductTaskCode);
  }

  void onUpdateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.formUpdateProductTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateProductTaskCode);
  }

  void onUpdateDataError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.formUpdateProductTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateProductTaskCode);
  }

  @override
  Future onRefresh() async {
    _properties.refresh();
  }
}
