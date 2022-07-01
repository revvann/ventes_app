import 'package:get/get.dart';
import 'package:ventes/app/states/typedefs/prospect_assign_typedef.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/states/state_listener.dart';

class ProspectAssignListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(id: Views.prospect.index);
  }

  @override
  Future onReady() async {
    property.refresh();
  }
}
