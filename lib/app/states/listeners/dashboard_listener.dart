// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:ventes/app/resources/views/started_page.dart';
import 'package:ventes/app/resources/widgets/error_alert.dart';
import 'package:ventes/app/resources/widgets/failed_alert.dart';
import 'package:ventes/app/resources/widgets/success_alert.dart';
import 'package:ventes/app/states/controllers/dashboard_state_controller.dart';
import 'package:ventes/app/states/data_sources/dashboard_data_source.dart';
import 'package:ventes/constants/strings/dashboard_string.dart';
import 'package:ventes/constants/strings/nearby_string.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/helpers/task_helper.dart';

class DashboardListener {
  DashboardProperties get _properties => Get.find<DashboardProperties>();
  DashboardDataSource get _dataSource => Get.find<DashboardDataSource>();

  void onLoadDataError() {
    Get.find<TaskHelper>().remove(DashboardString.taskCode);
    ErrorAlert(NearbyString.fetchError).show();
  }

  void onLoadDataFailed() {
    Get.find<TaskHelper>().remove(DashboardString.taskCode);
    FailedAlert(NearbyString.fetchFailed).show();
  }

  void onLogoutError(String message) {
    Get.find<TaskHelper>().remove(DashboardString.taskCode);
    ErrorAlert(message).show();
  }

  void onLogoutFailed(String message) {
    Get.find<TaskHelper>().remove(DashboardString.taskCode);
    FailedAlert(message).show();
  }

  void onLogoutSuccess(String message) {
    Get.find<TaskHelper>().remove(DashboardString.taskCode);
    SuccessAlert(message).show().then((res) async {
      await Get.find<AuthHelper>().destroy();
      Get.offAllNamed(StartedPageView.route);
    });
  }

  Future onRefresh() async {
    _properties.refresh();
  }
}
