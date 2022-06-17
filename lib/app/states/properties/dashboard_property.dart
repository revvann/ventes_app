part of 'package:ventes/app/states/controllers/dashboard_state_controller.dart';

class DashboardProperty extends StateProperty {
  DashboardDataSource get _dataSource => Get.find<DashboardDataSource>(tag: DashboardString.dashboardTag);
  Position? position;

  Task task = Task(DashboardString.taskCode);

  String? get shortName => getInitials(_dataSource.account?.user?.userfullname ?? "");

  void logout() {
    Get.find<TaskHelper>().confirmPush(
      task.copyWith<bool>(
        message: DashboardString.confirmLogout,
        onFinished: (res) {
          if (res) {
            _dataSource.logout();
            Get.find<TaskHelper>().loaderPush(task);
          }
        },
      ),
    );
  }
}

enum CameraMoveType { dragged, controller }
