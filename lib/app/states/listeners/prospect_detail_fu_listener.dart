import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/controllers/prospect_detail_fu_state_controller.dart';
import 'package:ventes/app/states/controllers/prospect_detail_state_controller.dart';
import 'package:ventes/app/states/data_sources/prospect_detail_fu_data_source.dart';
import 'package:ventes/app/states/form_sources/prospect_detail_fu_form_source.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProspectDetailFormUpdateListener {
  ProspectDetailFormUpdateProperties get _properties => Get.find<ProspectDetailFormUpdateProperties>();
  ProspectDetailFormUpdateFormSource get _formSource => Get.find<ProspectDetailFormUpdateFormSource>();
  ProspectDetailFormUpdateDataSource get _dataSource => Get.find<ProspectDetailFormUpdateDataSource>();

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

  Future onRefresh() async {
    _properties.refresh();
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
}
