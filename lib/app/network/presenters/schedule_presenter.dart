import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/constants/strings/regular_string.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/services/schedule_service.dart';

class SchedulePresenter {
  final ScheduleService _scheduleService = Get.find<ScheduleService>();
  final TypeService _typeService = Get.find<TypeService>();
  late final FetchDataContract _fetchContract;
  set fetchContract(FetchDataContract value) => _fetchContract = value;

  Future<Response> _getSchedules([int? month]) async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    int userid = authModel!.userId!;
    Map<String, dynamic> params = {
      "schetowardid": userid.toString(),
      "schemonth": month.toString(),
    };

    return await _scheduleService.select(params);
  }

  Future<Response> _getTypes() async {
    Map<String, dynamic> params = {
      "typecd": DBTypeString.schedule,
    };
    return await _typeService.byCode(params);
  }

  void fetchSchedules([int? month]) async {
    try {
      Map data = {};
      Response scheduleResponse = await _getSchedules(month);
      if (scheduleResponse.statusCode == 200) {
        data["schedules"] = scheduleResponse.body;
        _fetchContract.onLoadSuccess(data);
      } else {
        _fetchContract.onLoadFailed(ScheduleString.fetchFailed);
      }
    } catch (e) {
      _fetchContract.onLoadFailed(e.toString());
    }
  }

  void fetchData([int? scheduleMonth]) async {
    try {
      Map data = {};
      Response scheduleResponse = await _getSchedules(scheduleMonth);
      Response typesResponse = await _getTypes();
      if (scheduleResponse.statusCode == 200 && typesResponse.statusCode == 200) {
        data["schedules"] = scheduleResponse.body;
        data["types"] = typesResponse.body;
        _fetchContract.onLoadSuccess(data);
      } else {
        _fetchContract.onLoadFailed("${scheduleResponse.statusCode} ${typesResponse.statusCode}");
      }
    } catch (e) {
      _fetchContract.onLoadFailed(e.toString());
    }
  }
}
