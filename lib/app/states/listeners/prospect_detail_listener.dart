import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/prospect_detail_state_controller.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProspectDetailListener {
  ProspectDetailProperties get _properties => Get.find<ProspectDetailProperties>();

  void goBack() {
    Get.back(id: ProspectNavigator.id);
  }
}
