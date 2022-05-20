import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/form_sources/prospect_form_source.dart';
import 'package:ventes/app/states/listeners/prospect_listener.dart';

class ProspectStateController extends RegularStateController {
  ProspectProperties properties = Get.put(ProspectProperties());
  ProspectFormSource formSource = Get.put(ProspectFormSource());
  ProspectListener listener = Get.put(ProspectListener());

  @override
  void onClose() {
    Get.delete<ProspectListener>();
    Get.delete<ProspectFormSource>();
    Get.delete<ProspectProperties>();
    super.onClose();
  }
}

class ProspectProperties {}
