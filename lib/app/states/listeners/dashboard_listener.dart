// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:ventes/app/resources/views/splash_screen.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/app/states/typedefs/dashboard_typedef.dart';
import 'package:ventes/helpers/function_helpers.dart';

class DashboardListener extends StateListener with ListenerMixin {
  void switchAccount(int userdtid) async {
    Get.find<AuthHelper>().accountActive.val = userdtid;
    Get.offAllNamed(SplashScreenView.route);
  }

  @override
  Future onReady() async {
    property.position = await getCurrentPosition();
    dataSource.currentPositionHandler.fetcher.run();
    dataSource.customerHandler.fetcher.run();
    dataSource.userHandler.fetcher.run();
    dataSource.scheduleCountHandler.fetcher.run();
  }
}
