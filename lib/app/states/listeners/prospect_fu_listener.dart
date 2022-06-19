import 'package:get/get.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/states/controllers/prospect_state_controller.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/prospect_fu_typedef.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProspectFormUpdateListener extends StateListener {
  FormSource get _formSource => Get.find<FormSource>(tag: ProspectString.prospectUpdateTag);
  DataSource get _dataSource => Get.find<DataSource>(tag: ProspectString.prospectUpdateTag);
  Property get _property => Get.find<Property>(tag: ProspectString.prospectUpdateTag);

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
    Get.find<TaskHelper>().confirmPush(
      _property.task.copyWith<bool>(
        message: ProspectString.updateProspectConfirm,
        onFinished: (res) {
          if (res) {
            _formSource.onSubmit();
          }
        },
      ),
    );
  }

  void goBack() {
    Get.back(id: ProspectNavigator.id);
  }

  void onDataLoadError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onDataLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onUpdateDataSuccess(String message) {
    Get.find<TaskHelper>().successPush(_property.task.copyWith(
        message: message,
        onFinished: (res) {
          Get.find<ProspectStateController>().property.refresh();
          Get.back(id: ProspectNavigator.id);
        }));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onUpdateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onUpdateDataError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  @override
  Future onReady() async {
    _property.refresh();
  }
}
