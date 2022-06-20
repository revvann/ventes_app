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

class ProspectFormCreateListener extends StateListener with ListenerMixin {
  void onDateStartSelected(DateTime? value) {
    if (value != null) {
      formSource.prosstartdate = value;
      if (formSource.prosstartdate != null && formSource.prosenddate != null) {
        if (formSource.prosstartdate!.isAfter(formSource.prosenddate!)) {
          formSource.prosenddate = formSource.prosstartdate;
        }
      }
    }
  }

  void onDateEndSelected(DateTime? value) {
    if (value != null) {
      formSource.prosenddate = value;
    }
  }

  void onExpDateEndSelected(DateTime? value) {
    if (value != null) {
      formSource.prosexpenddate = value;
    }
  }

  void onFollowUpSelected(dynamic key) {
    formSource.prostype = key;
  }

  void onOwnerSelected(dynamic data) {
    if (data != null) {
      formSource.prosowner = data.value as UserDetail;
    }
  }

  bool onOwnerCompared(selectedItem, item) {
    return (selectedItem as UserDetail).userdtid == item.userdtid;
  }

  Future<List<UserDetail>> onOwnerFilter(String? search) async {
    return await dataSource.fetchUser(search);
  }

  void onCustomerSelected(dynamic data) {
    if (data != null) {
      formSource.proscustomer = data.value as BpCustomer;
    }
  }

  bool onCustomerCompared(selectedItem, item) {
    return (selectedItem as BpCustomer).sbcid == item.sbcid;
  }

  Future<List<BpCustomer>> onCustomerFilter(String? search) async {
    return await dataSource.fetchCustomer(search);
  }

  void onSubmitButtonClicked() {
    Get.find<TaskHelper>().confirmPush(
      property.task.copyWith<bool>(
        message: ProspectString.createProspectConfirm,
        onFinished: (res) {
          if (res) {
            formSource.onSubmit();
          }
        },
      ),
    );
  }

  void onAddProduct() {
    int index = formSource.prosproducts.length;
    KeyableDropdownController<int, DBType> taxDropdownController = Get.put(
      KeyableDropdownController<int, DBType>(),
      tag: 'taxDropdownController$index',
    );
    TextEditingController nameTEC = TextEditingController();
    TextEditingController priceTEC = TextEditingController();
    TextEditingController qtyTEC = TextEditingController(text: "1");
    TextEditingController discTEC = TextEditingController(text: "0");
    TextEditingController taxTEC = TextEditingController();

    formSource.addprosproduct = {
      'taxDropdownController': taxDropdownController,
      'taxType': Rx<DBType>(formSource.prospectproducttaxdefault!),
      "nameTEC": nameTEC,
      "priceTEC": priceTEC,
      "qtyTEC": qtyTEC,
      "discTEC": discTEC,
      "taxTEC": taxTEC,
    };
  }

  void onRemoveProduct(Map<String, dynamic> product) {
    int index = formSource.prosproducts.indexOf(product);
    Get.delete<KeyableDropdownController<int, DBType>>(tag: 'taxDropdownController$index');
    formSource.removeprosproduct = product;
  }

  void goBack() {
    Get.back(id: ProspectNavigator.id);
  }

  void onDataLoadError(String message) {
    Get.find<TaskHelper>().errorPush(property.task.copyWith(message: message));
  }

  void onDataLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(property.task.copyWith(message: message, snackbar: true));
  }

  void onCreateDataSuccess(String message) {
    Get.find<TaskHelper>().successPush(property.task.copyWith(
        message: message,
        onFinished: (res) {
          Get.find<ProspectStateController>().property.refresh();
          Get.back(id: ProspectNavigator.id);
        }));
  }

  void onCreateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(property.task.copyWith(message: message, snackbar: true));
  }

  void onCreateDataError(String message) {
    Get.find<TaskHelper>().errorPush(property.task.copyWith(message: message));
  }

  void onComplete() => Get.find<TaskHelper>().loaderPop(property.task.name);
  @override
  Future onReady() async {
    property.refresh();
  }
}
