import 'package:get/get.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/prospect_fu_data_source.dart';
import 'package:ventes/app/states/form_sources/prospect_fu_form_source.dart';
import 'package:ventes/app/states/listeners/prospect_fu_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectFormUpdateStateController extends RegularStateController {
  ProspectFormUpdateListener listener = Get.put(ProspectFormUpdateListener());
  ProspectFormUpdateFormSource formSource = Get.put(ProspectFormUpdateFormSource());
  ProspectFormUpdateDataSource dataSource = Get.put(ProspectFormUpdateDataSource());
  ProspectFormUpdateProperties properties = Get.put(ProspectFormUpdateProperties());

  @override
  void onClose() {
    Get.delete<ProspectFormUpdateProperties>();
    Get.delete<ProspectFormUpdateDataSource>();
    Get.delete<ProspectFormUpdateFormSource>();
    Get.delete<ProspectFormUpdateListener>();
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

class ProspectFormUpdateProperties {
  ProspectFormUpdateDataSource get dataSource => Get.find<ProspectFormUpdateDataSource>();

  late int prospectId;

  void refresh() {
    dataSource.fetchData(prospectId);
    Get.find<TaskHelper>().loaderPush(ProspectString.formUpdateTaskCode);
  }
}
