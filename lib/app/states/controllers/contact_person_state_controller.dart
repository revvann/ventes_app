import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/app/states/controllers/regular_state_controller.dart';
import 'package:ventes/app/states/data_sources/contact_person_data_source.dart';
import 'package:ventes/app/states/listeners/contact_person_listener.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/helpers/task_helper.dart';

class ContactPersonStateController extends RegularStateController {
  ContactPersonListener listener = Get.put(ContactPersonListener());
  ContactPersonDataSource dataSource = Get.put(ContactPersonDataSource());
  ContactPersonProperties properties = Get.put(ContactPersonProperties());

  @override
  void onInit() {
    super.onInit();
    dataSource.init();
  }

  @override
  void onReady() {
    super.onReady();
    properties.refresh();
  }

  @override
  void onClose() {
    Get.delete<ContactPersonListener>();
    Get.delete<ContactPersonDataSource>();
    Get.delete<ContactPersonProperties>();

    for (var element in properties.popupControllers) {
      Get.delete<PopupMenuController>(tag: element);
    }
    super.onClose();
  }
}

class ContactPersonProperties {
  ContactPersonDataSource get _dataSource => Get.find<ContactPersonDataSource>();
  Set<String> popupControllers = {};

  late int customerid;

  void refresh() {
    _dataSource.fetchData(customerid);
    Get.find<TaskHelper>().loaderPush(ProspectString.contactPersonTaskCode);
  }

  PopupMenuController createPopupController([int id = 0]) {
    String tag = "popup_$id";
    popupControllers.add(tag);
    return Get.put(PopupMenuController(), tag: tag);
  }
}
