import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/prospect_detail_fc_data_source.dart';
import 'package:ventes/app/states/form_sources/prospect_detail_fc_form_source.dart';
import 'package:ventes/app/states/listeners/prospect_detail_fc_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectDetailFormCreateStateController extends RegularStateController {
  ProspectDetailFormCreateListener listener = Get.put(ProspectDetailFormCreateListener());
  ProspectDetailFormCreateFormSource formSource = Get.put(ProspectDetailFormCreateFormSource());
  ProspectDetailFormCreateDataSource dataSource = Get.put(ProspectDetailFormCreateDataSource());
  ProspectDetailFormCreateProperties properties = Get.put(ProspectDetailFormCreateProperties());

  @override
  void onClose() {
    Get.delete<ProspectDetailFormCreateProperties>();
    Get.delete<ProspectDetailFormCreateDataSource>();
    Get.delete<ProspectDetailFormCreateFormSource>();
    Get.delete<ProspectDetailFormCreateListener>();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    dataSource.init();
    formSource.init();
  }

  @override
  void onReady() {
    super.onReady();
    properties.refresh();
  }
}

class ProspectDetailFormCreateProperties {
  ProspectDetailFormCreateDataSource get _dataSource => Get.find<ProspectDetailFormCreateDataSource>();

  late int prospectId;

  refresh() {
    _dataSource.fetchData(prospectId);
    Get.find<TaskHelper>().loaderPush(ProspectString.formCreateDetailTaskCode);
  }
}
