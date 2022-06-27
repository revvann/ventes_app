import 'package:get/get.dart';
import 'package:ventes/app/resources/views/contact/contact.dart';
import 'package:ventes/app/resources/views/product/product.dart';
import 'package:ventes/app/resources/views/prospect_assign/prospect_assign.dart';
import 'package:ventes/app/resources/views/prospect_activity/prospect_activity.dart';
import 'package:ventes/app/resources/views/prospect_form/update/prospect_fu.dart';
import 'package:ventes/app/states/typedefs/prospect_dashboard_typedef.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProspectDashboardListener extends StateListener with ListenerMixin {
  @override
  Future onReady() async {
    dataSource.prospectHandler.fetcher.run(property.prospectid);
    dataSource.assignUsersHandler.fetcher.run(property.prospectid);
    dataSource.productsHandler.fetcher.run(property.prospectid);
    dataSource.detailsHandler.fetcher.run(property.prospectid);
  }

  void navigateToProspectAssign() async {
    await property.menuController.toggleDropdown(close: true);
    Get.toNamed(
      ProspectAssignView.route,
      id: ProspectNavigator.id,
      arguments: {
        'prospect': property.prospectid,
      },
    );
  }

  void navigateToProduct() async {
    await property.menuController.toggleDropdown(close: true);
    Get.toNamed(
      ProductView.route,
      id: ProspectNavigator.id,
      arguments: {
        'prospect': property.prospectid,
      },
    );
  }

  void navigateToContactPerson() async {
    await property.menuController.toggleDropdown(close: true);
    Get.toNamed(ContactPersonView.route, id: ProspectNavigator.id, arguments: {
      'customer': dataSource.prospect?.prospectcust?.sbccstmid,
    });
  }

  void navigateToProspectActivity() async {
    await property.menuController.toggleDropdown(close: true);
    Get.toNamed(
      ProspectActivityView.route,
      id: ProspectNavigator.id,
      arguments: {
        'prospect': property.prospectid,
      },
    );
  }

  void navigateToProspectUpdateForm() {
    Get.toNamed(
      ProspectFormUpdateView.route,
      id: ProspectNavigator.id,
      arguments: {
        'prospect': property.prospectid,
      },
    );
  }

  void goBack() {
    Get.back(id: ProspectNavigator.id);
  }
}