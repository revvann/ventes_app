import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/controllers/prospect_detail_fc_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_detail_state_controller.dart';
import 'package:ventes/app/states/data_sources/prospect_detail_fc_data_source.dart';
import 'package:ventes/app/states/form_sources/prospect_detail_fc_form_source.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProspectDetailFormCreateListener {
  ProspectDetailFormCreateProperties get _properties => Get.find<ProspectDetailFormCreateProperties>();
  ProspectDetailFormCreateFormSource get _formSource => Get.find<ProspectDetailFormCreateFormSource>();
  ProspectDetailFormCreateDataSource get _dataSource => Get.find<ProspectDetailFormCreateDataSource>();

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

  Future onRefresh() async {
    _properties.refresh();
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
      // Get.find<ProspectDetailStateController>().properties.refresh();
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
}
