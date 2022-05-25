import 'package:get/get.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/views/prospect_form/create/prospect_fc.dart';
import 'package:ventes/app/resources/views/prospect_form/update/prospect_fu.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/controllers/prospect_state_controller.dart';
import 'package:ventes/app/states/data_sources/prospect_data_source.dart';
import 'package:ventes/app/states/form_sources/prospect_form_source.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProspectListener {
  ProspectProperties get _properties => Get.find<ProspectProperties>();
  ProspectFormSource get _formSource => Get.find<ProspectFormSource>();
  ProspectDataSource get _dataSource => Get.find<ProspectDataSource>();

  void onDateStartSelected(DateTime? value) {
    if (value != null) {
      _formSource.prosstartdate = value;
      if (_formSource.prosstartdate != null && _formSource.prosenddate != null) {
        if (_formSource.prosstartdate!.isAfter(_formSource.prosenddate!)) {
          _formSource.prosenddate = _formSource.prosstartdate;
        }
      }
    }
    onFilterChanged();
  }

  void onDateEndSelected(DateTime? value) {
    if (value != null) {
      _formSource.prosenddate = value;
    }
    onFilterChanged();
  }

  void onStatusSelected(selectedItem) {
    if (selectedItem != null) {
      _formSource.prosstatus = (selectedItem as DropdownItem<int, DBType>).value;
    } else {
      _formSource.prosstatus = null;
    }
    onFilterChanged();
  }

  void onFollowUpSelected(dynamic key) {
    _formSource.prostype = key;
    onFilterChanged();
  }

  void onAddButtonClicked() {
    Get.toNamed(ProspectFormCreateView.route, id: ProspectNavigator.id);
  }

  Future onRefresh() async {
    _properties.refresh();
  }

  Future onFilterChanged() async {
    Map<String, dynamic> filter = _formSource.toJson();
    _dataSource.fetchProspect(params: filter);
    Get.find<TaskHelper>().loaderPush(ProspectString.taskCode);
  }

  void onProspectClicked() {
    Get.toNamed(
      ProspectFormUpdateView.route,
      id: ProspectNavigator.id,
      arguments: {
        'prospect': _properties.selectedProspect?.prospectid,
      },
    );
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.taskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.taskCode);
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.taskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.taskCode);
  }
}
