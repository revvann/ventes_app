import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/schedule_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/constants/strings/regular_string.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/core/api/fetcher.dart';
import 'package:ventes/helpers/auth_helper.dart';

class SchedulePresenter extends RegularPresenter {
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

  SimpleFetcher<List> get fetchTypes => SimpleFetcher(responseBuilder: _getTypes, failedMessage: ScheduleString.fetchFailed);
  SimpleFetcher<List> get fetchPermission => SimpleFetcher(responseBuilder: _getPermissions, failedMessage: ScheduleString.fetchFailed);
  DataFetcher<Function([int?]), List> get fetchSchedules => DataFetcher(
        builder: (handler) {
          return ([month]) async {
            handler.start();
            try {
              Response scheduleResponse = await _getSchedules(month);
              if (scheduleResponse.statusCode == 200) {
                handler.success(scheduleResponse.body);
              } else {
                handler.failed(ScheduleString.fetchFailed);
              }
            } catch (e) {
              handler.error(e.toString());
            }
            handler.complete();
          };
        },
      );
}
