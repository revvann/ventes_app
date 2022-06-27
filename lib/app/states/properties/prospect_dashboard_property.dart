import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/app/states/typedefs/prospect_dashboard_typedef.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectDashboardProperty extends StateProperty with PropertyMixin {
  PopupMenuController menuController = Get.put(PopupMenuController(), tag: "prospectdashboardpopup");
  Task task = Task(ProspectString.prospectDashboardTaskCode);
  late int prospectid;
}
