import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/constants/strings/regular_string.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/app/api/services/schedule_service.dart';

class SchedulePresenter extends RegularPresenter<FetchDataContract> {
  final ScheduleService _scheduleService = Get.find<ScheduleService>();
  final TypeService _typeService = Get.find<TypeService>();

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

  Future<Response> _getPermissions() async {
    Map<String, dynamic> params = {
      "typecd": ScheduleString.permissionTypeCode,
    };
    return await _typeService.byCode(params);
  }

  void fetchSchedules([int? month]) async {
    try {
      Map data = {};
      Response scheduleResponse = await _getSchedules(month);
      if (scheduleResponse.statusCode == 200) {
        data["schedules"] = scheduleResponse.body;
        contract.onLoadSuccess(data);
      } else {
        contract.onLoadFailed(ScheduleString.fetchFailed);
      }
    } catch (e) {
      contract.onLoadFailed(e.toString());
    }
  }

  void fetchData([int? scheduleMonth]) async {
    try {
      Map data = {};
      Response scheduleResponse = await _getSchedules(scheduleMonth);
      Response typesResponse = await _getTypes();
      Response permissionsResponse = await _getPermissions();
      if (scheduleResponse.statusCode == 200 && typesResponse.statusCode == 200 && permissionsResponse.statusCode == 200) {
        data["schedules"] = scheduleResponse.body;
        data["types"] = typesResponse.body;
        data["permissions"] = permissionsResponse.body;
        contract.onLoadSuccess(data);
      } else {
        contract.onLoadFailed("${scheduleResponse.statusCode} ${typesResponse.statusCode}");
      }
    } catch (e) {
      contract.onLoadFailed(e.toString());
    }
  }
}
