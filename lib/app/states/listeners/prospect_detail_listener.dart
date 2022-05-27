import 'package:get/get.dart';
import 'package:ventes/app/resources/views/prospect_detail_form/create/prospect_detail_fc.dart';
import 'package:ventes/app/states/controllers/prospect_detail_state_controller.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProspectDetailListener {
  ProspectDetailProperties get _properties => Get.find<ProspectDetailProperties>();

  void goBack() {
    Get.back(id: ProspectNavigator.id);
  }

  void navigateToProspectDetailForm() {
    Get.toNamed(
      ProspectDetailFormCreateView.route,
      id: ProspectNavigator.id,
      arguments: {
        'prospect': _properties.prospectId,
      },
    );
  }
}
