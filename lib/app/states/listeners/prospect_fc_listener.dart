import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/controllers/prospect_fc_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_state_controller.dart';
import 'package:ventes/app/states/data_sources/prospect_fc_data_source.dart';
import 'package:ventes/app/states/form_sources/prospect_fc_form_source.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProspectFormCreateListener {
  ProspectFormCreateFormSource get _formSource => Get.find<ProspectFormCreateFormSource>();
  ProspectFormCreateDataSource get _dataSource => Get.find<ProspectFormCreateDataSource>();
  ProspectFormCreateProperties get _properties => Get.find<ProspectFormCreateProperties>();

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

  Future onRefresh() async {
    _properties.refresh();
  }

  void onSubmitButtonClicked() {
    if (_formSource.isValid) {
      Map<String, dynamic> data = _formSource.toJson();
      _dataSource.createProspect(data);
      Get.find<TaskHelper>().loaderPush(ProspectString.formCreateTaskCode);
    } else {
      Get.find<TaskHelper>().failedPush(ProspectString.formCreateTaskCode, "Form is not valid");
    }
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
    Get.find<TaskHelper>().errorPush(ProspectString.formCreateTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateTaskCode);
  }

  void onDataLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.formCreateTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateTaskCode);
  }

  void onCreateDataSuccess(String message) {
    Get.find<TaskHelper>().successPush(ProspectString.formCreateTaskCode, message, () {
      Get.find<ProspectStateController>().properties.refresh();
      Get.back(id: ProspectNavigator.id);
    });
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateTaskCode);
  }

  void onCreateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.formCreateTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateTaskCode);
  }

  void onCreateDataError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.formCreateTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateTaskCode);
  }
}
