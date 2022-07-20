import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/notification_service.dart';
import 'package:ventes/app/api/services/schedule_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/app/api/models/auth_model.dart';
import 'package:ventes/app/api/models/user_detail_model.dart';
import 'package:ventes/constants/strings/regular_string.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/core/api/fetcher.dart';
import 'package:ventes/helpers/auth_helper.dart';

class ScheduleFormUpdatePresenter extends RegularPresenter {
  final _userService = Get.find<UserService>();
  final _scheduleService = Get.find<ScheduleService>();
  final _typeService = Get.find<TypeService>();
  final _notificationService = Get.find<NotificationService>();

  Future<Response> _getTypes() {
    Map<String, dynamic> params = {
      'typecd': DBTypeString.schedule,
    };
    return _typeService.byCode(params);
  }

  Future<Response> _updateMessage(Map<String, dynamic> data) {
    return _notificationService.updateMessage(data);
  }

  Future<Response> _getUserDetail() async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    return await _userService.show(authModel!.accountActive!);
  }

  SimpleFetcher<Map<String, dynamic>> get fetchUserDetail => SimpleFetcher(responseBuilder: _getUserDetail, failedMessage: ScheduleString.fetchFailed);
  SimpleFetcher<List> get fetchTypes => SimpleFetcher(responseBuilder: _getTypes, failedMessage: ScheduleString.fetchFailed);
  DataFetcher<Function(int), Map<String, dynamic>> get fetchSchedule => DataFetcher(
        builder: (handler) {
          return (scheduleid) async {
            handler.start();
            try {
              Response scheduleResponse = await _scheduleService.show(scheduleid);
              if (scheduleResponse.statusCode == 200) {
                handler.success(scheduleResponse.body);
              } else {
                handler.failed("Failed to fetch schedule");
              }
            } catch (e) {
              handler.error(e.toString());
            }
            handler.complete();
          };
        },
      );
  DataFetcher<Function(Map<String, dynamic>), String> get update => DataFetcher(
        builder: (handler) {
          return (data) async {
            handler.start();
            try {
              Response response = await _scheduleService.update(data['scheid'], data);
              if (response.statusCode == 200) {
                handler.success(ScheduleString.updateSuccess);
              } else {
                handler.failed(ScheduleString.updateFailed);
              }
            } catch (e) {
              handler.error(e.toString());
            }
            handler.complete();
          };
        },
      );

  DataFetcher<Function(Map<String, dynamic>), String> get updateMessage => DataFetcher(
        builder: (handler) {
          return (data) async {
            handler.start();
            try {
              Response response = await _updateMessage(data);
              if (response.statusCode == 200) {
                handler.success("Notification successfully scheduled");
              } else {
                handler.failed("cannot scheduled notification");
              }
            } catch (e) {
              handler.error(e.toString());
            }
            handler.complete();
          };
        },
      );

  Future<List<UserDetail>> fetchUsers(String? search) async {
    UserDetail? activeUser = await findActiveUser();
    Map<String, dynamic> params = {
      'userdtbpid': activeUser?.userdtbpid.toString(),
      'search': search,
    };
    Response usersResponse = await _userService.select(params);
    if (usersResponse.statusCode == 200) {
      return List<UserDetail>.from(usersResponse.body.map((e) => UserDetail.fromJson(e)));
    }
    return [];
  }

  Future<UserDetail?> findActiveUser() async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    Response response = await _userService.show(authModel!.accountActive!);

    if (response.statusCode == 200) {
      return UserDetail.fromJson(response.body);
    }
    return null;
  }
}
