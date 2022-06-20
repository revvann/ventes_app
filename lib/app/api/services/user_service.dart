import 'package:get/get.dart';
import 'package:ventes/core/api/service.dart';

class UserService extends Service {
  @override
  String get api => "/user";

  ///
  /// params must has typecd key
  ///
  Future<Response> attachDevice(int id, String deviceid) async {
    return await put('$api/$id/attach-device', {
      'userdeviceid': deviceid,
    });
  }
}
