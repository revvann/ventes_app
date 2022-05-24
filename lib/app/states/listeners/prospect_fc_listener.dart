import 'package:get/get.dart';
import 'package:ventes/app/states/controllers/prospect_fc_state_controller.dart';
import 'package:ventes/app/states/data_sources/prospect_fc_data_source.dart';
import 'package:ventes/app/states/form_sources/prospect_fc_form_source.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProspectFormCreateListener {
  ProspectFormCreateFormSource get _formSource => Get.find<ProspectFormCreateFormSource>();
  ProspectFormCreateDataSource get _dataSource => Get.find<ProspectFormCreateDataSource>();
  ProspectFormCreateProperties get _properties => Get.find<ProspectFormCreateProperties>();

  void onDateStartSelected(DateTime? value) {
    if (value != null) {
      _formSource.prosstartdate = value;
      if (_formSource.prosstartdate != null && _formSource.prosenddate != null) {
        if (_formSource.prosstartdate!.isAfter(_formSource.prosenddate!)) {
          _formSource.prosenddate = _formSource.prosstartdate;
        }
      }
    }
  }

  void onDateEndSelected(DateTime? value) {
    if (value != null) {
      _formSource.prosenddate = value;
    }
  }

  void onExpDateEndSelected(DateTime? value) {
    if (value != null) {
      _formSource.prosexpenddate = value;
    }
  }

  void onRefresh() {
    _properties.refresh();
  }

  void goBack() {
    Get.back(id: ProspectNavigator.id);
  }

  void onDataLoadError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.formCreateTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateTaskCode);
  }

  void onDataLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.formCreateTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.formCreateTaskCode);
  }
}
