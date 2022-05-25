import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/prospect_fc_data_source.dart';
import 'package:ventes/app/states/form_sources/prospect_fc_form_source.dart';
import 'package:ventes/app/states/listeners/prospect_fc_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectFormCreateStateController extends RegularStateController {
  ProspectFormCreateListener listener = Get.put(ProspectFormCreateListener());
  ProspectFormCreateFormSource formSource = Get.put(ProspectFormCreateFormSource());
  ProspectFormCreateDataSource dataSource = Get.put(ProspectFormCreateDataSource());
  ProspectFormCreateProperties properties = Get.put(ProspectFormCreateProperties());

  @override
  void onClose() {
    Get.delete<ProspectFormCreateProperties>();
    Get.delete<ProspectFormCreateDataSource>();
    Get.delete<ProspectFormCreateFormSource>();
    Get.delete<ProspectFormCreateListener>();
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

class ProspectFormCreateProperties {
  ProspectFormCreateDataSource get dataSource => Get.find<ProspectFormCreateDataSource>();

  void refresh() {
    dataSource.fetchData();
    Get.find<TaskHelper>().loaderPush(ProspectString.formCreateTaskCode);
  }
}
