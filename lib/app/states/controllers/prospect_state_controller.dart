import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/prospect_data_source.dart';
import 'package:ventes/app/states/form_sources/prospect_form_source.dart';
import 'package:ventes/app/states/listeners/prospect_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectStateController extends RegularStateController {
  ProspectListener listener = Get.put(ProspectListener());
  ProspectDataSource dataSource = Get.put(ProspectDataSource());
  ProspectFormSource formSource = Get.put(ProspectFormSource());
  ProspectProperties properties = Get.put(ProspectProperties());

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
    Get.delete<ProspectListener>();
    Get.delete<ProspectDataSource>();
    Get.delete<ProspectFormSource>();
    Get.delete<ProspectProperties>();
    super.onClose();
  }
}

class ProspectProperties {
  ProspectDataSource get _dataSource => Get.find<ProspectDataSource>();
  ProspectFormSource get _formSource => Get.find<ProspectFormSource>();

  refresh() {
    _dataSource.reset();
    _formSource.reset();
    _dataSource.fetchData();
    Get.find<TaskHelper>().loaderPush(ProspectString.taskCode);
  }
}
