import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/presenters/regular_presenter.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/constants/strings/regular_string.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/app/network/services/schedule_service.dart';

class DailySchedulePresenter extends RegularPresenter<FetchDataContract> {
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

  void fetchData(String date) async {
    try {
      Map data = {};
      Response scheduleResponse = await getSchedules(date);
      Response typesResponse = await getTypes();

      if (scheduleResponse.statusCode == 200 && typesResponse.statusCode == 200) {
        data["schedules"] = scheduleResponse.body;
        data["types"] = typesResponse.body;
        contract.onLoadSuccess(data);
      } else {
        contract.onLoadFailed(ScheduleString.fetchFailed);
      }
    } catch (e) {
      contract.onLoadFailed(e.toString());
    }
  }
}
