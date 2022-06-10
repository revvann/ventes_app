part of 'package:ventes/app/states/controllers/prospect_detail_state_controller.dart';

class _Listener extends RegularListener {
  _Properties get _properties => Get.find<_Properties>(tag: ProspectString.detailCreateTag);
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.detailCreateTag);

  void goBack() {
    Get.back(id: ProspectNavigator.id);
  }

  void navigateToProspectDetailForm() {
    Get.toNamed(
      ProspectDetailFormCreateView.route,
      id: ProspectNavigator.id,
      arguments: {
        'prospect': _properties.prospectId,
      },
    );
  }

  void navigateToProduct() {
    Get.toNamed(
      ProductView.route,
      id: ProspectNavigator.id,
      arguments: {
        'prospect': _properties.prospectId,
      },
    );
  }

  void navigateToContactPerson() {
    Get.toNamed(ContactPersonView.route, id: ProspectNavigator.id, arguments: {
      'customer': _dataSource.prospect?.prospectcust?.sbccstmid,
    });
  }

  void onProspectDetailClicked(int id) {
    Get.toNamed(
      ProspectDetailFormUpdateView.route,
      id: ProspectNavigator.id,
      arguments: {
        'prospectdetail': id,
      },
    );
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.detailTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.detailTaskCode);
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.detailTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.detailTaskCode);
  }

  @override
  Future onRefresh() async {
    _properties.refresh();
  }
}
