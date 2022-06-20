import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/prospect_detail_fc_typedef.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectDetailFormCreateProperty extends StateProperty with PropertyMixin {
  final Completer<GoogleMapController> mapsController = Completer();

  final Rx<Set<Marker>> _marker = Rx<Set<Marker>>(<Marker>{});
  Set<Marker> get marker => _marker.value;
  set marker(Set<Marker> value) => _marker.value = value;

  late int prospectId;
  double defaultZoom = 20;

  Task task = Task(ProspectString.formCreateDetailTaskCode);

  refresh() {
    dataSource.fetchData(prospectId);
    Get.find<TaskHelper>().loaderPush(task);
  }
}
