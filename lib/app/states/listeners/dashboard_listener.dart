// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/resources/views/splash_screen.dart';
import 'package:ventes/app/resources/views/started_page.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/typedefs/dashboard_typedef.dart';

class DashboardListener extends StateListener with ListenerMixin {
  void switchAccount(int userdtid) async {
    Get.find<AuthHelper>().accountActive.val = userdtid;
    Get.offAllNamed(SplashScreenView.route);
  }

  void _logout(res) async {
    await Get.find<AuthHelper>().destroy();
    Get.offAllNamed(StartedPageView.route);
  }

  void onLoadDataError(String message) {
    Get.find<TaskHelper>().errorPush(property.task.copyWith(message: message));
  }

  void onLoadDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(property.task.copyWith(message: message, snackbar: true));
  }

  void onLogoutError(String message) {
    Get.find<TaskHelper>().errorPush(property.task.copyWith(message: message));
  }

  void onLogoutFailed(String message) {
    Get.find<TaskHelper>().failedPush(property.task.copyWith(message: message, snackbar: true));
  }

  void onLogoutSuccess(String message) {
    Get.find<TaskHelper>().successPush(property.task.copyWith(snackbar: true, message: message, onFinished: _logout));
  }

  void onComplete() => Get.find<TaskHelper>().loaderPop(property.task.name);
  @override
  Future onReady() async {
    property.position = await getCurrentPosition();
    dataSource.fetchData(LatLng(property.position!.latitude, property.position!.longitude));
    Get.find<TaskHelper>().loaderPush(property.task);
  }
}
