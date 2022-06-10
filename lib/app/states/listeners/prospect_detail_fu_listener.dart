part of 'package:ventes/app/states/controllers/prospect_detail_fu_state_controller.dart';

class _Listener extends RegularListener {
  _Properties get _properties => Get.find<_Properties>(tag: ProspectString.detailUpdateTag);
  _FormSource get _formSource => Get.find<_FormSource>(tag: ProspectString.detailUpdateTag);
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.detailUpdateTag);

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

  void onSubmitButtonClicked() {
    if (_formSource.isValid) {
      Map<String, dynamic> data = _formSource.toJson();
      _dataSource.updateData(_properties.prospectDetailId, data);
      Get.find<TaskHelper>().loaderPush(ProspectString.formUpdateDetailTaskCode);
    } else {
      Get.find<TaskHelper>().failedPush(ProspectString.formUpdateDetailTaskCode, "Form invalid, Make sure all fields are filled");
    }
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.formUpdateDetailTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateDetailTaskCode);
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.formUpdateDetailTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateDetailTaskCode);
  }

  void onUpdateDataSuccess(String message) {
    Get.find<TaskHelper>().successPush(ProspectString.formUpdateDetailTaskCode, message, () {
      Get.find<ProspectDetailStateController>().properties.refresh();
      Get.back(id: ProspectNavigator.id);
    });
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateDetailTaskCode);
  }

  void onUpdateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.formUpdateDetailTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateDetailTaskCode);
  }

  void onUpdateDataError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.formUpdateDetailTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateDetailTaskCode);
  }

  @override
  Future onRefresh() async {
    _properties.refresh();
  }
}
