import 'package:get/get.dart';
import 'package:ventes/app/states/typedefs/prospect_competitor_fc_typedef.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/states/state_listener.dart';

class ProspectCompetitorFormCreateListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(
      id: Views.prospect.index,
    );
  }

  void onSubmitButtonClicked() {}

  @override
  Future onReady() async {
    property.refresh();
  }
}
