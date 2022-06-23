import 'package:get/get.dart';
import 'package:ventes/app/models/auth_model.dart';
import 'package:ventes/app/api/contracts/delete_contract.dart';
import 'package:ventes/app/api/contracts/fetch_data_contract.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/constants/strings/regular_string.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/core/api/fetcher.dart';
import 'package:ventes/helpers/auth_helper.dart';
import 'package:ventes/app/api/services/schedule_service.dart';

class DailySchedulePresenter extends RegularPresenter<DailyScheduleContract> {
  final TypeService _typeService = Get.find<TypeService>();
  final _scheduleService = Get.find<ScheduleService>();

  Future<Response> _getSchedules(String date) async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    int userid = authModel!.userId!;
    Map<String, dynamic> params = {
      "schetowardid": userid.toString(),
      "schedate": date,
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
  DataFetcher<Function(String), List> get fetchSchedules => DataFetcher(
        builder: (handler) {
          return (date) async {
            handler.start();
            try {
              Response scheduleResponse = await _getSchedules(date);
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

  DataFetcher<Function(int), String> get delete => DataFetcher(
        builder: (handler) {
          return (id) async {
            handler.start();
            try {
              Response response = await _scheduleService.destroy(id);
              if (response.statusCode == 200) {
                handler.success(ScheduleString.deleteSuccess);
              } else {
                handler.failed(ScheduleString.deleteFailed);
              }
            } catch (e) {
              handler.error(e.toString());
            }
            handler.complete();
          };
        },
      );
}

abstract class DailyScheduleContract implements FetchDataContract, DeleteContract {}
