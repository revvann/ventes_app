import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/prospect_detail_fu_typedef.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectDetailFormUpdateProperty extends StateProperty with PropertyMixin {
  late int prospectDetailId;
  Task task = Task(ProspectString.formUpdateDetailTaskCode);

  final Completer<GoogleMapController> mapsController = Completer();

  final Rx<Set<Marker>> _marker = Rx<Set<Marker>>(<Marker>{});
  Set<Marker> get marker => _marker.value;
  set marker(Set<Marker> value) => _marker.value = value;

  double defaultZoom = 20;

  refresh() {
    dataSource.fetchData(prospectDetailId);
    Get.find<TaskHelper>().loaderPush(task);
  }
}
