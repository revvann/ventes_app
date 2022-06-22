import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/app/api/presenters/dashboard_presenter.dart';
import 'package:ventes/app/models/auth_model.dart';
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

class DashboardDataSource extends StateDataSource<DashboardPresenter> with DataSourceMixin implements DashboardContract {
  final String currentPositionID = "curposhdr";
  final String userID = 'userhdr';
  final String customerID = 'cstmhdr';
  final String scheduleCountID = "schcounthdr";
  final String logoutID = 'logouthdr';

  late DataHandler<Map<String, dynamic>, Function()> currentPositionHandler;
  late DataHandler<List, Function()> userHandler;
  late DataHandler<List, Function()> customerHandler;
  late DataHandler<Map<String, dynamic>, Function()> scheduleCountHandler;
  late DataHandler<dynamic, Function()> logoutHandler;

  final _customers = Rx<List<BpCustomer>>([]);
  set customers(List<BpCustomer> value) => _customers.value = value;
  List<BpCustomer> get customers => _customers.value;

  final _accounts = Rx<List<UserDetail>>([]);
  set accounts(List<UserDetail> value) => _accounts.value = value;
  List<UserDetail> get accounts => _accounts.value;

  final _account = Rx<UserDetail?>(null);
  set account(UserDetail? value) => _account.value = value;
  UserDetail? get account => _account.value;

  final _scheduleCount = 0.obs;
  set scheduleCount(int value) => _scheduleCount.value = value;
  int get scheduleCount => _scheduleCount.value;

  final _currentPosition = Rx<MapsLoc?>(null);
  MapsLoc? get currentPosition => _currentPosition.value;
  set currentPosition(MapsLoc? value) => _currentPosition.value = value;

  void _customersFromList(List data, LatLng currentPos) {
    customers = data.map((e) => BpCustomer.fromJson(e)).toList();
    LatLng coords2 = LatLng(currentPos.latitude, currentPos.longitude);
    customers = customers.map((element) => _filterBpCustomer(element, coords2)).where(_isBpCustomer100Meters).toList();
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

  void _userSuccess(List data) async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    if (authModel != null) {
      accounts = data.map<UserDetail>((e) => UserDetail.fromJson(e)).toList();
      account = accounts.firstWhere((element) => element.userdtid == authModel.accountActive);
      accounts.removeWhere((element) => element.userdtid == authModel.accountActive);
    }
  }

  void _customerSuccess(List data) {
    _customersFromList(
      data,
      LatLng(property.position!.latitude, property.position!.longitude),
    );
  }

  void _logout(res) async {
    await Get.find<AuthHelper>().destroy();
    Get.offAllNamed(StartedPageView.route);
  }

  void _logoutSuccess(String message) {
    Get.find<TaskHelper>().successPush(property.task.copyWith(snackbar: true, message: message, onFinished: _logout));
  }

  @override
  void init() {
    super.init();
    currentPositionHandler = DataHandler(
      currentPositionID,
      fetcher: presenter.fetchPosition,
      onError: (message) => _showError(currentPositionID, message),
      onFailed: (message) => _showFailed(currentPositionID, message),
      onSuccess: (data) => currentPosition = MapsLoc.fromJson(data),
    );

    userHandler = DataHandler(
      userID,
      fetcher: presenter.fetchUser,
      onError: (message) => _showError(userID, message),
      onFailed: (message) => _showFailed(userID, message),
      onSuccess: _userSuccess,
    );

    customerHandler = DataHandler(
      customerID,
      fetcher: presenter.fetchCustomers,
      onError: (message) => _showError(customerID, message),
      onFailed: (message) => _showFailed(customerID, message),
      onSuccess: _customerSuccess,
    );

    scheduleCountHandler = DataHandler(
      scheduleCountID,
      fetcher: presenter.fetchScheduleCount,
      onError: (message) => _showError(scheduleCountID, message),
      onFailed: (message) => _showFailed(scheduleCountID, message),
      onSuccess: (data) => scheduleCount = data['count'],
    );

    logoutHandler = DataHandler(
      logoutID,
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
