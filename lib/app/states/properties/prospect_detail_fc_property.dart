part of 'package:ventes/app/states/controllers/prospect_detail_fc_state_controller.dart';

class ProspectDetailFormCreateProperty extends StateProperty {
  ProspectDetailFormCreateDataSource get _dataSource => Get.find<ProspectDetailFormCreateDataSource>(tag: ProspectString.detailCreateTag);
  final Completer<GoogleMapController> mapsController = Completer();

  final Rx<Set<Marker>> _marker = Rx<Set<Marker>>(<Marker>{});
  Set<Marker> get marker => _marker.value;
  set marker(Set<Marker> value) => _marker.value = value;

  late int prospectId;
  double defaultZoom = 20;

  Task task = Task(ProspectString.formCreateDetailTaskCode);

  refresh() {
    _dataSource.fetchData(prospectId);
    Get.find<TaskHelper>().loaderPush(task);
  }
}
