import 'package:get/get.dart';
import 'package:ventes/app/states/typedefs/profile_typedef.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProfileListener extends StateListener with ListenerMixin {
  @override
  Future onReady() async {
    dataSource.fetchData();
    Get.find<TaskHelper>().loaderPush(property.task);
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(property.task.copyWith(message: message, snackbar: true));
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(property.task.copyWith(message: message));
  }

  void onLoadComplete() {
    Get.find<TaskHelper>().loaderPop(property.task.name);
  }

  void goBack() {
    backToDashboard();
  }
}
