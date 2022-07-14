import 'package:get/get.dart';
import 'package:ventes/app/api/models/auth_model.dart';
import 'package:ventes/constants/strings/regular_string.dart';
import 'package:ventes/helpers/auth_helper.dart';

class NotificationService extends GetConnect {
  @override
  void onInit() {
    httpClient.addRequestModifier<dynamic>((request) async {
      AuthModel? session = await Get.find<AuthHelper>().get();
      if (session?.jwtToken != null) request.headers['Authorization'] = "Bearer ${session?.jwtToken}";
      return request;
    });
    httpClient.timeout = const Duration(hours: 5);
  }

  Future<Response> sendMessage(Map<String, dynamic> data) async {
    return await post("${RegularString.nodeServer}/send-message", data);
  }
}
