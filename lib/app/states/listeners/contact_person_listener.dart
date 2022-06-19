import 'package:get/get.dart';
import 'package:ventes/app/resources/views/contact_form/create/contact_person_fc.dart';
import 'package:ventes/app/resources/views/contact_form/update/contact_person_fu.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/app/states/controllers/contact_person_state_controller.dart';
import 'package:ventes/app/states/typedefs/contact_person_typedef.dart';

class ContactPersonListener extends StateListener {
  Property get _property => Get.find<Property>(tag: ProspectString.contactTag);
  DataSource get _dataSource => Get.find<DataSource>(tag: ProspectString.contactTag);

  void goBack() {
    Get.back(id: ProspectNavigator.id);
  }

  void onAddButtonClicked() {
    Get.toNamed(
      ContactPersonFormCreateView.route,
      id: ProspectNavigator.id,
      arguments: {
        'customer': _property.customerid,
      },
    );
  }

  void navigateToUpdateForm(int contactid) {
    Get.toNamed(
      ContactPersonFormUpdateView.route,
      id: ProspectNavigator.id,
      arguments: {
        'contact': contactid,
      },
    );
  }

  void deleteData(int id) {
    Get.find<TaskHelper>().confirmPush(
      _property.task.copyWith<bool>(
        message: ProspectString.deleteContactConfirm,
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
        onFinished: (res) async {
          Get.find<ContactPersonStateController>().refreshStates();
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
