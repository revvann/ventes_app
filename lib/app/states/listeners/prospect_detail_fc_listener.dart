part of 'package:ventes/app/states/controllers/prospect_detail_fc_state_controller.dart';

class _Listener extends RegularListener {
  _Properties get _properties => Get.find<_Properties>(tag: ProspectString.detailCreateTag);
  _FormSource get _formSource => Get.find<_FormSource>(tag: ProspectString.detailCreateTag);
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.detailCreateTag);

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
      _dataSource.createData(data);
      Get.find<TaskHelper>().loaderPush(ProspectString.formCreateDetailTaskCode);
    } else {
      Get.find<TaskHelper>().failedPush(ProspectString.formCreateDetailTaskCode, "Form invalid, Make sure all fields are filled");
    }
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.formCreateDetailTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateDetailTaskCode);
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.formCreateDetailTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateDetailTaskCode);
  }

  void onCreateDataSuccess(String message) {
    Get.find<TaskHelper>().successPush(ProspectString.formCreateDetailTaskCode, message, () {
      Get.find<ProspectDetailStateController>().properties.refresh();
      Get.back(id: ProspectNavigator.id);
    });
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateDetailTaskCode);
  }

  void onCreateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.formCreateDetailTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateDetailTaskCode);
  }

  void onCreateDataError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.formCreateDetailTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateDetailTaskCode);
  }

  @override
  Future onRefresh() async {
    _properties.refresh();
  }
}
