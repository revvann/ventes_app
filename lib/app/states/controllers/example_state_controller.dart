// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:ventes/core/states/state_controller.dart';
import 'package:ventes/app/states/data_sources/example_data_source.dart';
// import 'package:ventes/app/states/listeners/nearby_listener.dart';

class ExampleStateController extends GetxController {
  // NearbyListener listener = Get.put(NearbyListener());

  @override
  void onClose() {
    Get.delete<Exampleproperty>();
    // Get.delete<NearbyListener>();
    super.onClose();
  }
}

class Exampleproperty {
  ExampleDataSource dataSource = ExampleDataSource();
}
