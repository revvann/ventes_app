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

  Future fetchSchedules([int? month]) async {
    try {
      AuthModel? authModel = await Get.find<AuthHelper>().get();
      int userid = authModel!.userId!;
      Map<String, dynamic> params = {
        "schetowardid": userid.toString(),
        "schemonth": month.toString(),
      };

      Response response = await _scheduleService.select(params);
      if (response.statusCode == 200) {
        _fetchContract.onLoadSuccess({
          "schedules": response.body,
        });
      } else {
        _fetchContract.onLoadFailed(ScheduleString.fetchFailed);
      }
    } catch (err) {
      _fetchContract.onLoadError(ScheduleString.fetchError);
    }
  }

  Future<Map<String, int>> fetchTypes() async {
    Map<String, int> types = {};
    Map<String, dynamic> params = {
      "typecd": DBTypeString.schedule,
    };
    Response response = await _typeService.byCode(params);
    if (response.statusCode == 200) {
      List<DBType> dbType = List<DBType>.from(response.body.map((e) => DBType.fromJson(e)).toList());
      types = dbType.asMap().map((i, e) => MapEntry(e.typename ?? "", e.typeid ?? 0));
    }
    return types;
  }
}
