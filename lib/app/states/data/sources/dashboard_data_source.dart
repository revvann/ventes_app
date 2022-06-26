import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/api/presenters/dashboard_presenter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/maps_loc.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/resources/views/started_page.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/app/states/typedefs/dashboard_typedef.dart';
import 'package:ventes/helpers/task_helper.dart';

class DashboardDataSource extends StateDataSource<DashboardPresenter> with DataSourceMixin {
  final String currentPositionID = "curposhdr";
  final String usersID = 'usershdr';
  final String userID = 'userhdr';
  final String customersID = 'cstmhdr';
  final String scheduleCountID = "schcounthdr";
  final String logoutID = 'logouthdr';

  late DataHandler<MapsLoc?, Map<String, dynamic>, Function()> currentPositionHandler;
  late DataHandler<List<UserDetail>, List, Function()> usersHandler;
  late DataHandler<UserDetail?, Map<String, dynamic>, Function()> userHandler;
  late DataHandler<List<BpCustomer>, List, Function()> customersHandler;
  late DataHandler<int, Map<String, dynamic>, Function()> scheduleCountHandler;
  late DataHandler<dynamic, dynamic, Function()> logoutHandler;

  List<BpCustomer> get customers => customersHandler.value;
  List<UserDetail> get accounts => usersHandler.value;
  UserDetail? get account => userHandler.value;
  int get scheduleCount => scheduleCountHandler.value;

  MapsLoc? get currentPosition => currentPositionHandler.value;

  List<BpCustomer> _customersFromList(List data, LatLng currentPos) {
    List<BpCustomer> customers = data.map((e) => BpCustomer.fromJson(e)).toList();
    LatLng coords2 = LatLng(currentPos.latitude, currentPos.longitude);
    return customers.map((element) => _filterBpCustomer(element, coords2)).where(_isBpCustomer100Meters).toList();
  }

  BpCustomer _filterBpCustomer(BpCustomer element, LatLng currentCoordinates) {
    LatLng coords1 = LatLng(element.sbccstm?.cstmlatitude ?? 0.0, element.sbccstm?.cstmlongitude ?? 0.0);
    double radius = calculateDistance(coords1, currentCoordinates);
    element.radius = radius;
    return element;
  }

  bool _isBpCustomer100Meters(BpCustomer element) => element.radius != null ? element.radius! <= 100 : false;

  void _showError(String id, String message) {
    Get.find<TaskHelper>().errorPush(Task(id, message: message));
  }

  void _showFailed(String id, String message, [bool snackbar = true]) {
    Get.find<TaskHelper>().failedPush(Task(id, message: message, snackbar: snackbar));
  }

  List<UserDetail> _usersSuccess(List data) {
    List<UserDetail> accounts = data.map<UserDetail>((e) => UserDetail.fromJson(e)).toList();
    accounts.removeWhere((element) => element.userdtid == account?.userdtid);
    return accounts;
  }

  UserDetail _userSuccess(Map<String, dynamic> data) {
    UserDetail account = UserDetail.fromJson(data);
    usersHandler.fetcher.run();
    return account;
  }

  List<BpCustomer> _customerSuccess(List data) {
    return _customersFromList(
      data,
      LatLng(property.position!.latitude, property.position!.longitude),
    );
  }

  void _logout(res) async {
    await Get.find<AuthHelper>().destroy();
    Get.offAllNamed(StartedPageView.route);
  }

  void _logoutSuccess(String message) {
    Get.find<TaskHelper>().successPush(Task(logoutID, snackbar: true, message: message, onFinished: _logout));
  }

  @override
  void init() {
    super.init();
    currentPositionHandler = DataHandler(
      currentPositionID,
      initialValue: null,
      fetcher: presenter.fetchPosition,
      onError: (message) => _showError(currentPositionID, message),
      onFailed: (message) => _showFailed(currentPositionID, message),
      onSuccess: (data) => MapsLoc.fromJson(data),
    );

    usersHandler = DataHandler(
      usersID,
      initialValue: [],
      fetcher: presenter.fetchUsers,
      onError: (message) => _showError(usersID, message),
      onFailed: (message) => _showFailed(usersID, message),
      onSuccess: _usersSuccess,
    );

    userHandler = DataHandler(
      userID,
      initialValue: null,
      fetcher: presenter.fetchUser,
      onError: (message) => _showError(userID, message),
      onFailed: (message) => _showFailed(userID, message),
      onSuccess: _userSuccess,
    );

    customersHandler = DataHandler(
      customersID,
      initialValue: [],
      fetcher: presenter.fetchCustomers,
      onError: (message) => _showError(customersID, message),
      onFailed: (message) => _showFailed(customersID, message),
      onSuccess: _customerSuccess,
    );

    scheduleCountHandler = DataHandler(
      scheduleCountID,
      initialValue: 0,
      fetcher: presenter.fetchScheduleCount,
      onError: (message) => _showError(scheduleCountID, message),
      onFailed: (message) => _showFailed(scheduleCountID, message),
      onSuccess: (data) => data['count'],
    );

    logoutHandler = DataHandler(
      logoutID,
      initialValue: null,
      fetcher: presenter.logout,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(logoutID)),
      onError: (message) => _showError(logoutID, message),
      onFailed: (message) => _showFailed(logoutID, message, false),
      onSuccess: (data) => _logoutSuccess("Logout Success"),
      onComplete: () => Get.find<TaskHelper>().loaderPop(logoutID),
    );
  }

  @override
  DashboardPresenter presenterBuilder() => DashboardPresenter();

  @override
  onLoadError(String message) {}

  @override
  onLoadFailed(String message) {}

  @override
  onLoadSuccess(Map data) async {}

  @override
  void onLogoutError(String message) {}
  @override
  void onLogoutFailed(String message) {}
  @override
  void onLogoutSuccess(String message) {}

  @override
  onLoadComplete() {}

  @override
  void onLogoutComplete() {}
}
