// ignore_for_file: prefer_const_constructors
part of 'package:ventes/app/states/controllers/dashboard_state_controller.dart';

class _Listener extends RegularListener {
  _Properties get _properties => Get.find<_Properties>();
  _DataSource get _dataSource => Get.find<_DataSource>();

  void switchAccount(int userdtid) async {
    Get.find<AuthHelper>().accountActive.val = userdtid;
    Get.offAllNamed(SplashScreenView.route);
  }

  void _logout() async {
    await Get.find<AuthHelper>().destroy();
    Get.offAllNamed(StartedPageView.route);
  }

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
      _logout,
    );
  }

  @override
  Future onRefresh() async {
    _properties.position = await getCurrentPosition();
    _dataSource.fetchData(LatLng(_properties.position!.latitude, _properties.position!.longitude));

    Get.find<TaskHelper>().loaderPush(DashboardString.taskCode);
  }
}
