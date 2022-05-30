import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/prospect_detail_data_source.dart';
import 'package:ventes/app/states/listeners/prospect_detail_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectDetailStateController extends RegularStateController {
  ProspectDetailListener listener = Get.put(ProspectDetailListener());
  ProspectDetailDataSource dataSource = Get.put(ProspectDetailDataSource());
  ProspectDetailProperties properties = Get.put(ProspectDetailProperties());

  @override
  void onInit() {
    super.onInit();
    dataSource.init();
  }

  @override
  void onReady() {
    super.onReady();
    properties.refresh();
  }

  @override
  void onClose() {
    Get.delete<ProspectDetailListener>();
    Get.delete<ProspectDetailDataSource>();
    Get.delete<ProspectDetailProperties>();
    super.onClose();
  }
}

class ProspectDetailProperties {
  ProspectDetailDataSource get _dataSource => Get.find<ProspectDetailDataSource>();
  late int prospectId;

  refresh() {
    _dataSource.fetchData(prospectId);
    Get.find<TaskHelper>().loaderPush(ProspectString.detailTaskCode);
  }
}
