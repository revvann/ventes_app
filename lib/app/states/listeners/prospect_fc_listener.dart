import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/controllers/prospect_state_controller.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/prospect_fc_typedef.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProspectFormCreateListener extends StateListener {
  FormSource get _formSource => Get.find<FormSource>(tag: ProspectString.prospectCreateTag);
  DataSource get _dataSource => Get.find<DataSource>(tag: ProspectString.prospectCreateTag);
  Property get _property => Get.find<Property>(tag: ProspectString.prospectCreateTag);

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
    if (data != null) {
      _formSource.prosowner = data.value as UserDetail;
    }
  }

  bool onOwnerCompared(selectedItem, item) {
    return (selectedItem as UserDetail).userdtid == item.userdtid;
  }

  Future<List<UserDetail>> onOwnerFilter(String? search) async {
    return await _dataSource.fetchUser(search);
  }

  void onCustomerSelected(dynamic data) {
    if (data != null) {
      _formSource.proscustomer = data.value as BpCustomer;
    }
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
        message: ProspectString.createProspectConfirm,
        onFinished: (res) {
          if (res) {
            _formSource.onSubmit();
          }
        },
      ),
    );
  }

  void onAddProduct() {
    int index = _formSource.prosproducts.length;
    KeyableDropdownController<int, DBType> taxDropdownController = Get.put(
      KeyableDropdownController<int, DBType>(),
      tag: 'taxDropdownController$index',
    );
    TextEditingController nameTEC = TextEditingController();
    TextEditingController priceTEC = TextEditingController();
    TextEditingController qtyTEC = TextEditingController(text: "1");
    TextEditingController discTEC = TextEditingController(text: "0");
    TextEditingController taxTEC = TextEditingController();

    _formSource.addprosproduct = {
      'taxDropdownController': taxDropdownController,
      'taxType': Rx<DBType>(_formSource.prospectproducttaxdefault!),
      "nameTEC": nameTEC,
      "priceTEC": priceTEC,
      "qtyTEC": qtyTEC,
      "discTEC": discTEC,
      "taxTEC": taxTEC,
    };
  }

  void onRemoveProduct(Map<String, dynamic> product) {
    int index = _formSource.prosproducts.indexOf(product);
    Get.delete<KeyableDropdownController<int, DBType>>(tag: 'taxDropdownController$index');
    _formSource.removeprosproduct = product;
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

  void onCreateDataSuccess(String message) {
    Get.find<TaskHelper>().successPush(_property.task.copyWith(
        message: message,
        onFinished: (res) {
          Get.find<ProspectStateController>().property.refresh();
          Get.back(id: ProspectNavigator.id);
        }));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onCreateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onCreateDataError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  @override
  Future onReady() async {
    _property.refresh();
  }
}
