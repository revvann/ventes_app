import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/network/services/type_service.dart';
import 'package:ventes/constants/strings/regular_string.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/app/network/contracts/fetch_data_contract.dart';
import 'package:ventes/app/network/services/schedule_service.dart';

class DailySchedulePresenter {
  final TypeService _typeService = Get.find<TypeService>();
  final _scheduleService = Get.find<ScheduleService>();
  late final FetchDataContract _fetchContract;
  set fetchContract(FetchDataContract contract) => _fetchContract = contract;

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
        _fetchContract.onLoadSuccess(data);
      } else {
        _fetchContract.onLoadFailed(ScheduleString.fetchFailed);
      }
    } catch (e) {
      _fetchContract.onLoadFailed(e.toString());
    }
  }
}
