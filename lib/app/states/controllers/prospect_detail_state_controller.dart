import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/listeners/prospect_detail_listener.dart';

class ProspectDetailStateController extends RegularStateController {
  ProspectDetailListener listener = Get.put(ProspectDetailListener());
  ProspectDetailProperties properties = Get.put(ProspectDetailProperties());

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    Get.delete<ProspectDetailListener>();
    Get.delete<ProspectDetailProperties>();
    super.onClose();
  }
}

class ProspectDetailProperties {
  late int prospectId;
}
