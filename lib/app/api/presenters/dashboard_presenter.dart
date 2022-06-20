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

  void fetchData(double latitude, double longitude) async {
    Map data = {};
    try {
      Response customersResponse = await _getCustomers();
      Response currentPositionResponse = await _getCurrentPosition();
      Response scheduleResponse = await _getSchedule();
      Response userResponse = await _getUser();
      if (customersResponse.statusCode == 200 && currentPositionResponse.statusCode == 200 && scheduleResponse.statusCode == 200 && userResponse.statusCode == 200) {
        data['customers'] = customersResponse.body;
        data['currentPosition'] = currentPositionResponse.body;
        data['scheduleCount'] = scheduleResponse.body['count'];
        data['user'] = userResponse.body;
        contract.onLoadSuccess(data);
      } else {
        contract.onLoadFailed(DashboardString.fetchFailed);
      }
    } catch (e) {
      contract.onLoadError(e.toString());
    }
    contract.onLoadComplete();
  }

  void logout() async {
    Response authResponse = await _authService.signOut();
    try {
      if (authResponse.statusCode == 200) {
        contract.onLogoutSuccess("Logout Success");
      } else {
        contract.onLogoutFailed("Logout Failed");
      }
    } catch (e) {
      contract.onLogoutError(e.toString());
    }
    contract.onLogoutComplete();
  }
}

abstract class DashboardContract implements FetchDataContract, LogoutContract {}
