import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/contracts/logout_contract.dart';
import 'package:ventes/app/network/services/auth_service.dart';
import 'package:ventes/app/network/services/bp_customer_service.dart';
import 'package:ventes/app/network/services/gmaps_service.dart';
import 'package:ventes/app/network/services/schedule_service.dart';
import 'package:ventes/app/network/services/user_service.dart';
import 'package:ventes/constants/strings/dashboard_string.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/helpers/function_helpers.dart';

class DashboardPresenter {
  final _bpCustomerService = Get.find<BpCustomerService>();
  final _userService = Get.find<UserService>();
  final _authService = Get.find<AuthService>();
  final _gmapsService = Get.find<GmapsService>();
  final _scheduleService = Get.find<ScheduleService>();

  late FetchDataContract _fetchDataContract;
  set fetchDataContract(FetchDataContract value) => _fetchDataContract = value;

  late LogoutContract _logoutContract;
  set logoutContract(LogoutContract value) => _logoutContract = value;

  Future<Response> _getSchedule() async {
    int? userdtid = (await _findActiveUser())?.userdtid;

    DateTime now = DateTime.now();
    DateTime start = firstWeekDate(now);
    DateTime end = lastWeekDate(now);

    Map<String, dynamic> data = {
      'schetowardid': userdtid.toString(),
      'startdate': dbFormatDate(start),
      'enddate': dbFormatDate(end),
    };

    return _scheduleService.count(data);
  }

  Future<Response> _getCustomers() async {
    int? bpid = (await _findActiveUser())?.userdtbpid;
    Map<String, dynamic> data = {
      'sbcbpid': bpid.toString(),
    };
    return await _bpCustomerService.select(data);
  }

  Future<UserDetail?> _findActiveUser() async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    Response response = await _userService.show(authModel!.accountActive!);

    if (response.statusCode == 200) {
      return UserDetail.fromJson(response.body);
    }
    return null;
  }

  Future<Response> _getUser() async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    Map<String, dynamic> params = {'userid': authModel!.userId!.toString()};
    return await _userService.select(params);
  }

  Future<Response> _getActiveUser() async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    return await _userService.show(authModel!.accountActive!);
  }

  Future<Response> _getCurrentPosition() async {
    Position position = await getCurrentPosition();
    return await _gmapsService.getDetail(position.latitude, position.longitude);
  }

  void fetchData(double latitude, double longitude) async {
    Map data = {};
    try {
      Response customersResponse = await _getCustomers();
      Response activeUserResponse = await _getActiveUser();
      Response currentPositionResponse = await _getCurrentPosition();
      Response scheduleResponse = await _getSchedule();
      Response userResponse = await _getUser();
      if (customersResponse.statusCode == 200 &&
          activeUserResponse.statusCode == 200 &&
          currentPositionResponse.statusCode == 200 &&
          scheduleResponse.statusCode == 200 &&
          userResponse.statusCode == 200) {
        data['customers'] = customersResponse.body;
        data['activeUser'] = activeUserResponse.body;
        data['currentPosition'] = currentPositionResponse.body;
        data['scheduleCount'] = scheduleResponse.body['count'];
        data['user'] = userResponse.body;
        _fetchDataContract.onLoadSuccess(data);
      } else {
        _fetchDataContract.onLoadFailed(DashboardString.fetchFailed);
      }
    } catch (err) {
      _fetchDataContract.onLoadError(err.toString());
    }
  }

  void logout() async {
    Response authResponse = await _authService.signOut();
    try {
      if (authResponse.statusCode == 200) {
        _logoutContract.onLogoutSuccess("Logout Success");
      } else {
        _logoutContract.onLogoutFailed("Logout Failed");
      }
    } catch (err) {
      _logoutContract.onLogoutError(err.toString());
    }
  }
}
