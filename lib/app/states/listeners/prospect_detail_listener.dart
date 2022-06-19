import 'package:get/get.dart';
import 'package:ventes/app/resources/views/contact/contact.dart';
import 'package:ventes/app/resources/views/product/product.dart';
import 'package:ventes/app/resources/views/prospect_assign/prospect_assign.dart';
import 'package:ventes/app/resources/views/prospect_detail_form/create/prospect_detail_fc.dart';
import 'package:ventes/app/resources/views/prospect_detail_form/update/prospect_detail_fu.dart';
import 'package:ventes/app/resources/views/prospect_form/update/prospect_fu.dart';
import 'package:ventes/app/states/controllers/prospect_detail_state_controller.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/prospect_detail_typedef.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProspectDetailListener extends StateListener {
  Property get _property => Get.find<Property>(tag: ProspectString.detailTag);
  DataSource get _dataSource => Get.find<DataSource>(tag: ProspectString.detailTag);

  void goBack() {
    Get.back(id: ProspectNavigator.id);
  }

  void navigateToProspectDetailForm() {
    Get.toNamed(
      ProspectDetailFormCreateView.route,
      id: ProspectNavigator.id,
      arguments: {
        'prospect': _property.prospectId,
      },
    );
  }

  void navigateToProspectAssign() {
    Get.toNamed(
      ProspectAssignView.route,
      id: ProspectNavigator.id,
      arguments: {
        'prospect': _property.prospectId,
      },
    );
  }

  void navigateToProspectUpdateForm() {
    Get.toNamed(
      ProspectFormUpdateView.route,
      id: ProspectNavigator.id,
      arguments: {
        'prospect': _property.prospectId,
      },
    );
  }

  void navigateToProduct() {
    Get.toNamed(
      ProductView.route,
      id: ProspectNavigator.id,
      arguments: {
        'prospect': _property.prospectId,
      },
    );
  }

  void navigateToContactPerson() {
    Get.toNamed(ContactPersonView.route, id: ProspectNavigator.id, arguments: {
      'customer': _dataSource.prospect?.prospectcust?.sbccstmid,
    });
  }

  void onProspectDetailClicked(int id) {
    Get.toNamed(
      ProspectDetailFormUpdateView.route,
      id: ProspectNavigator.id,
      arguments: {
        'prospectdetail': id,
      },
    );
  }

  void deleteDetail(int id) {
    Get.find<TaskHelper>().confirmPush(
      _property.task.copyWith<bool>(
        message: ProspectString.deleteDetailConfirm,
        onFinished: (res) {
          if (res) {
            _dataSource.deleteData(id);
            Get.find<TaskHelper>().loaderPush(_property.task);
          }
        },
      ),
    );
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onDeleteFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onDeleteSuccess(String message) {
    Get.find<TaskHelper>().successPush(_property.task.copyWith(
        message: message,
        onFinished: (res) {
          Get.find<ProspectDetailStateController>().refreshStates();
        }));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onDeleteError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  @override
  Future onReady() async {
    _property.refresh();
  }
}
