import 'package:get/get.dart';
import 'package:ventes/app/resources/views/contact_form/create/contact_person_fc.dart';
import 'package:ventes/app/resources/views/contact_form/update/contact_person_fu.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';
import 'package:ventes/app/states/controllers/contact_person_state_controller.dart';
import 'package:ventes/app/states/typedefs/contact_person_typedef.dart';

class ContactPersonListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(id: ProspectNavigator.id);
  }

  void onAddButtonClicked() {
    Get.toNamed(
      ContactPersonFormCreateView.route,
      id: ProspectNavigator.id,
      arguments: {
        'customer': property.customerid,
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
      property.task.copyWith<bool>(
        message: ProspectString.deleteContactConfirm,
        onFinished: (res) {
          if (res) {
            dataSource.deleteData(id);
            Get.find<TaskHelper>().loaderPush(property.task);
          }
        },
      ),
    );
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(property.task.copyWith(message: message, snackbar: true));
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(property.task.copyWith(message: message));
  }

  void onDeleteFailed(String message) {
    Get.find<TaskHelper>().failedPush(property.task.copyWith(message: message, snackbar: true));
  }

  void onDeleteSuccess(String message) {
    Get.find<TaskHelper>().successPush(property.task.copyWith(
        message: message,
        onFinished: (res) async {
          Get.find<ContactPersonStateController>().refreshStates();
        }));
  }

  void onDeleteError(String message) {
    Get.find<TaskHelper>().errorPush(property.task.copyWith(message: message));
  }

  void onComplete() => Get.find<TaskHelper>().loaderPop(property.task.name);

  @override
  Future onReady() async {
    property.refresh();
  }
}
