import 'package:get/get.dart';
import 'package:ventes/app/api/models/prospect_model.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/prospect_typedef.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectProperty extends StateProperty with PropertyMixin {
  Prospect? selectedProspect;
  Task task = Task(ProspectString.taskCode);
  Set<String> popupControllers = {};

  void refresh() {
    dataSource.prospectsHandler.fetcher.run();
    dataSource.statusesHandler.fetcher.run();
    dataSource.lostReasonsHandler.fetcher.run();
  }

  PopupMenuController createPopupController([int id = 0]) {
    String tag = "popup_${id}_prospectlist";
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
