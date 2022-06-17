import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/api/contracts/delete_contract.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/constants/strings/regular_string.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/app/api/services/schedule_service.dart';

class DailySchedulePresenter extends RegularPresenter<DailyScheduleContract> {
  final TypeService _typeService = Get.find<TypeService>();
  final _scheduleService = Get.find<ScheduleService>();

  Future<Response> getSchedules(String date) async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    int userid = authModel!.userId!;
    Map<String, dynamic> params = {
      "schetowardid": userid.toString(),
      "schedate": date,
    };

    return await _scheduleService.select(params);
  }

  Future<Response> getTypes() async {
    Map<String, dynamic> params = {
      "typecd": DBTypeString.schedule,
    };
    return await _typeService.byCode(params);
  }

  Future<Response> getPermissions() async {
    Map<String, dynamic> params = {
      "typecd": ScheduleString.permissionTypeCode,
    };
    return await _typeService.byCode(params);
  }

  void fetchData(String date) async {
    try {
      Map data = {};
      Response scheduleResponse = await getSchedules(date);
      Response typesResponse = await getTypes();
      Response permissionsResponse = await getPermissions();

      if (scheduleResponse.statusCode == 200 && typesResponse.statusCode == 200 && permissionsResponse.statusCode == 200) {
        data["schedules"] = scheduleResponse.body;
        data["types"] = typesResponse.body;
        data["permissions"] = permissionsResponse.body;
        contract.onLoadSuccess(data);
      } else {
        contract.onLoadFailed(ScheduleString.fetchFailed);
      }
    } catch (e) {
      contract.onLoadFailed(e.toString());
    }
  }

  void deleteData(int scheduleid) async {
    try {
      Response response = await _scheduleService.destroy(scheduleid);
      if (response.statusCode == 200) {
        contract.onDeleteSuccess(ScheduleString.deleteSuccess);
      } else {
        contract.onDeleteFailed(ScheduleString.deleteFailed);
      }
    } catch (e) {
      contract.onDeleteFailed(e.toString());
    }
  }
}

abstract class DailyScheduleContract implements FetchDataContract, DeleteContract {}
