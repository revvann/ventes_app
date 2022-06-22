import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/app/api/contracts/logout_contract.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/auth_service.dart';
import 'package:ventes/app/api/services/bp_customer_service.dart';
import 'package:ventes/app/api/services/gmaps_service.dart';
import 'package:ventes/app/api/services/schedule_service.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/constants/strings/dashboard_string.dart';
import 'package:ventes/core/api/fetcher.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/helpers/function_helpers.dart';

class DashboardPresenter extends RegularPresenter<DashboardContract> {
  final BpCustomerService _bpCustomerService = Get.find();
  final UserService _userService = Get.find();
  final AuthService _authService = Get.find();
  final GmapsService _gmapsService = Get.find();
  final ScheduleService _scheduleService = Get.find();

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

  Future<Response> _getCurrentPosition() async {
    Position position = await getCurrentPosition();
    return await _gmapsService.getDetail(position.latitude, position.longitude);
  }

  SimpleFetcher get logout => SimpleFetcher(responseBuilder: _authService.signOut, failedMessage: "Logout failed");

  SimpleFetcher<Map<String, dynamic>> get fetchPosition => SimpleFetcher<Map<String, dynamic>>(
        responseBuilder: _getCurrentPosition,
        failedMessage: DashboardString.fetchFailed,
      );

  SimpleFetcher<List> get fetchUser => SimpleFetcher<List>(
        responseBuilder: _getUser,
        failedMessage: DashboardString.fetchFailed,
      );

  SimpleFetcher<List> get fetchCustomers => SimpleFetcher<List>(
        responseBuilder: _getCustomers,
        failedMessage: DashboardString.fetchFailed,
      );

  SimpleFetcher<Map<String, dynamic>> get fetchScheduleCount => SimpleFetcher<Map<String, dynamic>>(
        responseBuilder: _getSchedule,
        failedMessage: DashboardString.fetchFailed,
      );
}

abstract class DashboardContract implements FetchDataContract, LogoutContract {}
