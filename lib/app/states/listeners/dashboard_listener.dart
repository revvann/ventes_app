// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/resources/views/splash_screen.dart';
import 'package:ventes/app/resources/views/started_page.dart';
import 'package:ventes/constants/strings/dashboard_string.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/app/states/typedefs/dashboard_typedef.dart';

class DashboardListener extends StateListener {
  Property get _property => Get.find<Property>(tag: DashboardString.dashboardTag);
  DataSource get _dataSource => Get.find<DataSource>(tag: DashboardString.dashboardTag);

  void switchAccount(int userdtid) async {
    Get.find<AuthHelper>().accountActive.val = userdtid;
    Get.offAllNamed(SplashScreenView.route);
  }

  void _logout(res) async {
    await Get.find<AuthHelper>().destroy();
    Get.offAllNamed(StartedPageView.route);
  }

  void onLoadDataError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onLoadDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onLogoutError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onLogoutFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onLogoutSuccess(String message) {
    Get.find<TaskHelper>().loaderPop(_property.task.name);
    Get.find<TaskHelper>().successPush(_property.task.copyWith(snackbar: true, message: message, onFinished: _logout));
  }

  @override
  Future onReady() async {
    _property.position = await getCurrentPosition();
    _dataSource.fetchData(LatLng(_property.position!.latitude, _property.position!.longitude));

    Get.find<TaskHelper>().loaderPush(_property.task);
  }
}
