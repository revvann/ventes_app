import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';
import 'package:ventes/app/api/services/notification_service.dart';
import 'package:ventes/app/api/services/prospect_activity_service.dart';
import 'package:ventes/app/api/services/prospect_service.dart';
import 'package:ventes/app/api/services/schedule_service.dart';
import 'package:ventes/app/api/services/type_service.dart';
import 'package:ventes/app/api/services/user_service.dart';
import 'package:ventes/app/api/models/auth_model.dart';
import 'package:ventes/app/api/models/user_detail_model.dart';
import 'package:ventes/constants/strings/regular_string.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/core/api/fetcher.dart';
import 'package:ventes/helpers/auth_helper.dart';

class ScheduleFormCreatePresenter extends RegularPresenter {
  final _userService = Get.find<UserService>();
  final _scheduleService = Get.find<ScheduleService>();
  final _typeService = Get.find<TypeService>();
  final _prospectService = Get.find<ProspectService>();
  final _prospectActivityService = Get.find<ProspectActivityService>();
  final _notificationService = Get.find<NotificationService>();

  Future<Response> _create(Map<String, dynamic> data) async {
    return _scheduleService.store(data);
  }

  Future<Response> _getTypes() {
    Map<String, dynamic> params = {
      'typecd': DBTypeString.schedule,
    };
    return _typeService.byCode(params);
  }

  Future<Response> _getRefType(int id) {
    return _typeService.show(id);
  }

  Future<Response> _getRefFromProspect(int id) {
    return _prospectService.show(id);
  }

  Future<Response> _storeActivity(Map<String, dynamic> data) {
    return _prospectActivityService.store(data);
  }

  Future<Response> _sendMessage(Map<String, dynamic> data) {
    return _notificationService.sendMessage(data);
  }

  Future<Response> _getUserDetail() async {
    AuthModel? authModel = await Get.find<AuthHelper>().get();
    return await _userService.show(authModel!.accountActive!);
  }

  SimpleFetcher<Map<String, dynamic>> get fetchUserDetail => SimpleFetcher(responseBuilder: _getUserDetail, failedMessage: ScheduleString.fetchFailed);
  SimpleFetcher<List> get fetchTypes => SimpleFetcher(responseBuilder: _getTypes, failedMessage: ScheduleString.fetchFailed);
  DataFetcher<Function(int), Map<String, dynamic>> get fetchRefType => DataFetcher(builder: (handler) {
        return (id) async {
          handler.start();
          try {
            Response response = await _getRefType(id);
            if (response.statusCode == 200) {
              handler.success(response.body);
            } else {
              handler.failed(ScheduleString.fetchFailed);
            }
          } catch (e) {
            handler.error(e.toString());
          }
          handler.complete();
        };
      });
  DataFetcher<Function(int), Map<String, dynamic>> get fetchRefFromProspect => DataFetcher(builder: (handler) {
        return (id) async {
          handler.start();
          try {
            Response response = await _getRefFromProspect(id);
            if (response.statusCode == 200) {
              handler.success(response.body);
            } else {
              handler.failed(ScheduleString.fetchFailed);
            }
          } catch (e) {
            handler.error(e.toString());
          }
          handler.complete();
        };
      });
  DataFetcher<Function(Map<String, dynamic>), String> get create => DataFetcher(
        builder: (handler) {
          return (data) async {
            handler.start();
            try {
              Response response = await _create(data);
              if (response.statusCode == 200) {
                handler.success(ScheduleString.createSuccess);
              } else {
                handler.failed(ScheduleString.createFailed);
              }
            } catch (e) {
              handler.error(e.toString());
            }
            handler.complete();
          };
        },
      );
  DataFetcher<Function(Map<String, dynamic>), String> get sendMessage => DataFetcher(
        builder: (handler) {
          return (data) async {
            handler.start();
            try {
              Response response = await _sendMessage(data);
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
  DataFetcher<Function(Map<String, dynamic>), Map<String, dynamic>> get createRefFromActivity => DataFetcher(
        builder: (handler) {
          return (data) async {
            handler.start();
            try {
              Response response = await _storeActivity(data);
              if (response.statusCode == 200) {
                handler.success(response.body);
              } else {
                handler.failed(ScheduleString.createFailed);
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
