import 'package:get/get.dart';
import 'package:ventes/core/api/service.dart';
import 'package:ventes/helpers/auth_helper.dart';

class UserService extends Service {
  @override
  String get api => "/user";

  Future<Response> attachDevice(int id, String deviceid) async {
    return await put('$api/$id/attach-device', {
      'userdeviceid': deviceid,
    });
  }

  Future<Response> setToken(String? token) async {
    int? id = Get.find<AuthHelper>().userId.val;
    return await update(id!, {
      'userfcmtoken': token,
    });
  }
}
