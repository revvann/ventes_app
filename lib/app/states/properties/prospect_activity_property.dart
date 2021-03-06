import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/prospect_activity_typedef.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectActivityProperty extends StateProperty with PropertyMixin {
  PopupMenuController menuController = Get.put(PopupMenuController(), tag: "prospectactivitypopup");

  late int prospectId;
  Set<String> popupControllers = {};
  Task task = Task(ProspectString.detailTaskCode);

  refresh() {
    dataSource.stagesHandler.fetcher.run();
    dataSource.scheduleRefTypesHandler.fetcher.run();
    dataSource.prospectHandler.fetcher.run(prospectId);
    dataSource.prospectActivitiesHandler.fetcher.run(prospectId);
  }

  PopupMenuController createPopupController([int id = 0]) {
    String tag = "popup_$id";
    popupControllers.add(tag);
    return Get.put(PopupMenuController(), tag: tag);
  }

  @override
  void close() {
    super.close();
    for (var element in popupControllers) {
      Get.delete<PopupMenuController>(tag: element);
    }
  }
}
