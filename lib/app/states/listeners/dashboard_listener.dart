// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/error_alert.dart';
import 'package:ventes/app/resources/widgets/failed_alert.dart';
import 'package:ventes/app/states/controllers/dashboard_state_controller.dart';
import 'package:ventes/app/states/data_sources/dashboard_data_source.dart';
import 'package:ventes/constants/strings/nearby_string.dart';

class DashboardListener {
  DashboardProperties get _properties => Get.find<DashboardProperties>();
  DashboardDataSource get _dataSource => Get.find<DashboardDataSource>();

  void onLoadDataError() {
    Get.close(1);
    ErrorAlert(NearbyString.fetchError).show();
  }

  void onLoadDataFailed() {
    Get.close(1);
    FailedAlert(NearbyString.fetchFailed).show();
  }
}
