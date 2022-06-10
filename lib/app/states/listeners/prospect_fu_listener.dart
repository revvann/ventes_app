part of 'package:ventes/app/states/controllers/prospect_fu_state_controller.dart';

class _Listener extends RegularListener {
  _FormSource get _formSource => Get.find<_FormSource>(tag: ProspectString.prospectUpdateTag);
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.prospectUpdateTag);
  _Properties get _properties => Get.find<_Properties>(tag: ProspectString.prospectUpdateTag);

  void onDateStartSelected(DateTime? value) {
    if (value != null) {
      _formSource.prosstartdate = value;
      if (_formSource.prosstartdate != null && _formSource.prosenddate != null) {
        if (_formSource.prosstartdate!.isAfter(_formSource.prosenddate!)) {
          _formSource.prosenddate = _formSource.prosstartdate;
        }
      }
    }
  }

  void onDateEndSelected(DateTime? value) {
    if (value != null) {
      _formSource.prosenddate = value;
    }
  }

  void onExpDateEndSelected(DateTime? value) {
    if (value != null) {
      _formSource.prosexpenddate = value;
    }
  }

  void onFollowUpSelected(dynamic key) {
    _formSource.prostype = key;
  }

  void onOwnerSelected(dynamic data) {
    _formSource.prosowner = data.value as UserDetail;
  }

  bool onOwnerCompared(selectedItem, item) {
    return (selectedItem as UserDetail).userdtid == item.userdtid;
  }

  Future<List<UserDetail>> onOwnerFilter(String? search) async {
    return await _dataSource.fetchUser(search);
  }

  void onCustomerSelected(dynamic data) {
    _formSource.proscustomer = data.value as BpCustomer;
  }

  bool onCustomerCompared(selectedItem, item) {
    return (selectedItem as BpCustomer).sbcid == item.sbcid;
  }

  Future<List<BpCustomer>> onCustomerFilter(String? search) async {
    return await _dataSource.fetchCustomer(search);
  }

  void onSubmitButtonClicked() {
    if (_formSource.isValid) {
      Map<String, dynamic> data = _formSource.toJson();
      _dataSource.updateProspect(_properties.prospectId, data);
      Get.find<TaskHelper>().loaderPush(ProspectString.formUpdateTaskCode);
    } else {
      Get.find<TaskHelper>().failedPush(ProspectString.formUpdateTaskCode, "Form is not valid");
    }
  }

  void goBack() {
    Get.back(id: ProspectNavigator.id);
  }

  void onDataLoadError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.formUpdateTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateTaskCode);
  }

  void onDataLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.formUpdateTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateTaskCode);
  }

  void onUpdateDataSuccess(String message) {
    Get.find<TaskHelper>().successPush(ProspectString.formUpdateTaskCode, message, () {
      Get.find<ProspectStateController>().properties.refresh();
      Get.back(id: ProspectNavigator.id);
    });
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateTaskCode);
  }

  void onUpdateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.formUpdateTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateTaskCode);
  }

  void onUpdateDataError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.formUpdateTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formUpdateTaskCode);
  }

  @override
  Future onRefresh() async {
    _properties.refresh();
  }
}
