// ignore_for_file: prefer_const_constructors
part of 'package:ventes/app/states/controllers/dashboard_state_controller.dart';

class _Listener extends RegularListener {
  _Properties get _properties => Get.find<_Properties>(tag: DashboardString.dashboardTag);
  _DataSource get _dataSource => Get.find<_DataSource>(tag: DashboardString.dashboardTag);

  void switchAccount(int userdtid) async {
    Get.find<AuthHelper>().accountActive.val = userdtid;
    Get.offAllNamed(SplashScreenView.route);
  }

  void _logout() async {
    await Get.find<AuthHelper>().destroy();
    Get.offAllNamed(StartedPageView.route);
  }

  void onLoadDataError(String message) {
    Get.find<TaskHelper>().errorPush(_properties.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onLoadDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onLogoutError(String message) {
    Get.find<TaskHelper>().errorPush(_properties.task.copyWith(message: message));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onLogoutFailed(String message) {
    Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: message, snackbar: true));
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  void onLogoutSuccess(String message) {
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
    Get.find<TaskHelper>().successPush(_properties.task.copyWith(snackbar: true, message: message, onFinished: _logout));
  }

  @override
  Future onRefresh() async {
    _properties.position = await getCurrentPosition();
    _dataSource.fetchData(LatLng(_properties.position!.latitude, _properties.position!.longitude));

    Get.find<TaskHelper>().loaderPush(_properties.task);
  }
}
