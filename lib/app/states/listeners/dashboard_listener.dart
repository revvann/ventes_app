// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:ventes/app/resources/views/started_page.dart';
import 'package:ventes/app/states/controllers/dashboard_state_controller.dart';
import 'package:ventes/app/states/data_sources/dashboard_data_source.dart';
import 'package:ventes/constants/strings/dashboard_string.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/helpers/task_helper.dart';

class DashboardListener {
  DashboardProperties get _properties => Get.find<DashboardProperties>();
  DashboardDataSource get _dataSource => Get.find<DashboardDataSource>();

  void onLoadDataError(String message) {
    Get.find<TaskHelper>().errorPush(DashboardString.taskCode, message);
    Get.find<TaskHelper>().loaderPop(DashboardString.taskCode);
  }

  void onLoadDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(DashboardString.taskCode, message);
    Get.find<TaskHelper>().loaderPop(DashboardString.taskCode);
  }

  void onLogoutError(String message) {
    Get.find<TaskHelper>().errorPush(DashboardString.taskCode, message);
    Get.find<TaskHelper>().loaderPop(DashboardString.taskCode);
  }

  void onLogoutFailed(String message) {
    Get.find<TaskHelper>().failedPush(DashboardString.taskCode, message);
    Get.find<TaskHelper>().loaderPop(DashboardString.taskCode);
  }

  void onLogoutSuccess(String message) {
    Get.find<TaskHelper>().loaderPop(DashboardString.taskCode);
    Get.find<TaskHelper>().successPush(
      DashboardString.taskCode,
      message,
      () async {
        await Get.find<AuthHelper>().destroy();
        Get.offAllNamed(StartedPageView.route);
      },
    );
  }

  Future onRefresh() async {
    _properties.refresh();
  }
}
