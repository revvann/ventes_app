import 'package:get/get.dart';
import 'package:ventes/app/resources/views/contact/contact.dart';
import 'package:ventes/app/resources/views/prospect_detail_form/create/prospect_detail_fc.dart';
import 'package:ventes/app/resources/views/prospect_detail_form/update/prospect_detail_fu.dart';
import 'package:ventes/app/states/controllers/prospect_detail_state_controller.dart';
import 'package:ventes/app/states/data_sources/prospect_detail_data_source.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProspectDetailListener {
  ProspectDetailProperties get _properties => Get.find<ProspectDetailProperties>();
  ProspectDetailDataSource get _dataSource => Get.find<ProspectDetailDataSource>();

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

  Future onRefresh() async {
    _properties.refresh();
  }

  void onLoadFailed(String message) {
    Get.find<TaskHelper>().failedPush(ProspectString.detailTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.detailTaskCode);
  }

  void onLoadError(String message) {
    Get.find<TaskHelper>().errorPush(ProspectString.detailTaskCode, message);
    Get.find<TaskHelper>().loaderPop(ProspectString.detailTaskCode);
  }
}
