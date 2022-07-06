import 'package:get/get.dart';
import 'package:ventes/app/resources/views/prospect_competitor_form/create/prospect_competitor_fc.dart';
import 'package:ventes/app/states/typedefs/prospect_competitor_typedef.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/states/state_listener.dart';

class ProspectCompetitorListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(id: Views.prospect.index);
  }

  void navigateToCompetitorForm() {
    Get.toNamed(
      ProspectCompetitorFormCreateView.route,
      id: Views.prospect.index,
      arguments: {
        "prospect": property.prospectid,
      },
    );
  }

  @override
  Future onReady() async {
    property.refresh();
  }
}
