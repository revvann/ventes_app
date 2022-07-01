import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/popup_button.dart';
import 'package:ventes/app/states/typedefs/dashboard_typedef.dart';
import 'package:ventes/constants/strings/dashboard_string.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';

class DashboardProperty extends StateProperty with PropertyMixin {
  Position? position;
  Task task = Task(DashboardString.taskCode);
  String? get shortName => getInitials(dataSource.account?.user?.userfullname ?? "");
  PopupMenuController menuController = Get.put(PopupMenuController(), tag: "dashboardPopup");

  void logout() {
    menuController.toggleDropdown(close: true);
    Get.find<TaskHelper>().confirmPush(
      task.copyWith<bool>(
        message: DashboardString.confirmLogout,
        onFinished: (res) {
          if (res) {
            dataSource.logoutHandler.fetcher.run();
          }
        },
      ),
    );
  }

  @override
  void close() {
    super.close();
    Get.delete<PopupMenuController>(tag: "dashboardPopup");
  }

  @override
  void init() {
    super.init();
  }
}

enum CameraMoveType { dragged, controller }
