import 'package:get/get.dart';
import 'package:ventes/state/controllers/nearby_state_controller.dart';

mixin NearbyListener {
  NearbyStateController get _$ => Get.find<NearbyStateController>();
}
