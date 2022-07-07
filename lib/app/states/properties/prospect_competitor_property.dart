import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/app/states/typedefs/prospect_competitor_typedef.dart';
import 'package:ventes/core/states/state_property.dart';

class ProspectCompetitorProperty extends StateProperty with PropertyMixin {
  Set<String> popupControllers = {};

  late int prospectid;

  void refresh() {
    dataSource.prospectHandler.fetcher.run(prospectid);
    dataSource.refTypesHandler.fetcher.run();
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
