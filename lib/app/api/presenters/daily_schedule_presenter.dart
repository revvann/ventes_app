import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/notification_service.dart';
import 'package:ventes/app/api/services/schedule_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/app/api/models/auth_model.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/constants/strings/regular_string.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/core/api/fetcher.dart';
import 'package:ventes/helpers/auth_helper.dart';

class DailySchedulePresenter extends RegularPresenter {
  final TypeService _typeService = Get.find<TypeService>();
  final _scheduleService = Get.find<ScheduleService>();
  final _notificationService = Get.find<NotificationService>();
  final _userService = Get.find<UserService>();

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

  Future<Response> _deleteMessage(Map<String, dynamic> data) {
    return _notificationService.deleteMessage(data);
  }

  Future<Response> _getUserDetail() async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    return await _userService.show(authModel!.accountActive!);
  }

  SimpleFetcher<Map<String, dynamic>> get fetchUserDetail => SimpleFetcher(responseBuilder: _getUserDetail, failedMessage: ScheduleString.fetchFailed);
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

  DataFetcher<Function(Map<String, dynamic>), String> get deleteMessage => DataFetcher(
        builder: (handler) {
          return (data) async {
            handler.start();
            try {
              Response response = await _deleteMessage(data);
              if (response.statusCode == 200) {
                handler.success("Notification deleted successfully");
              } else {
                handler.failed("Error while deleting notification");
              }
            } catch (e) {
              handler.error(e.toString());
            }
            handler.complete();
          };
        },
      );
}
