part of 'package:ventes/app/states/controllers/prospect_state_controller.dart';

class _Listener extends RegularListener {
  _Properties get _properties => Get.find<_Properties>(tag: ProspectString.prospectTag);
  _FormSource get _formSource => Get.find<_FormSource>(tag: ProspectString.prospectTag);
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.prospectTag);

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
      _formSource.prosstatus = (selectedItem as KeyableDropdownItem<int, DBType>).value;
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

  Future onFilterChanged() async {
    Map<String, dynamic> filter = _formSource.toJson();
    _dataSource.fetchProspect(params: filter);
    Get.find<TaskHelper>().loaderPush(ProspectString.taskCode);
  }

  void onProspectClicked() {
    Get.toNamed(
      ProspectDetailView.route,
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

  @override
  Future onRefresh() async {
    _properties.refresh();
  }
}
