import 'package:get/get.dart';
import 'package:ventes/app/states/typedefs/prospect_assign_typedef.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProspectAssignListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(id: ProspectNavigator.id);
  }

  @override
  Future onReady() async {
    property.refresh();
  }
}
