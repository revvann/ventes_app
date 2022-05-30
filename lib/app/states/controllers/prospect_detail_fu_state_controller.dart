import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/prospect_detail_fu_data_source.dart';
import 'package:ventes/app/states/form_sources/prospect_detail_fu_form_source.dart';
import 'package:ventes/app/states/listeners/prospect_detail_fu_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectDetailFormUpdateStateController extends RegularStateController {
  ProspectDetailFormUpdateListener listener = Get.put(ProspectDetailFormUpdateListener());
  ProspectDetailFormUpdateFormSource formSource = Get.put(ProspectDetailFormUpdateFormSource());
  ProspectDetailFormUpdateDataSource dataSource = Get.put(ProspectDetailFormUpdateDataSource());
  ProspectDetailFormUpdateProperties properties = Get.put(ProspectDetailFormUpdateProperties());

  @override
  void onClose() {
    Get.delete<ProspectDetailFormUpdateProperties>();
    Get.delete<ProspectDetailFormUpdateDataSource>();
    Get.delete<ProspectDetailFormUpdateFormSource>();
    Get.delete<ProspectDetailFormUpdateListener>();
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

class ProspectDetailFormUpdateProperties {
  ProspectDetailFormUpdateDataSource get _dataSource => Get.find<ProspectDetailFormUpdateDataSource>();

  late int prospectDetailId;

  refresh() {
    _dataSource.fetchData(prospectDetailId);
    Get.find<TaskHelper>().loaderPush(ProspectString.formUpdateDetailTaskCode);
  }
}
