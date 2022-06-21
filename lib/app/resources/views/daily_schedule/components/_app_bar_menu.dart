// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

part of 'package:ventes/app/resources/views/daily_schedule/daily_schedule.dart';

class _AppBarMenu extends StatelessWidget {
  DailyScheduleStateController state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return state.property.selectedAppointment != null
          ? PopupMenu(
              controller: Get.put(PopupMenuController(), tag: "SchedulePopup"),
              dropdownSettings: DropdownSettings(
                width: 150,
                builder: (controller) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: RegularSize.s,
                    horizontal: RegularSize.s,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MenuItem(
                        title: "Detail",
                        icon: "assets/svg/detail.svg",
                        onTap: openDialog,
                      ),
                      MenuItem(
                        title: "Edit",
                        icon: "assets/svg/edit.svg",
                        onTap: state.listener.onEditButtonClick,
                      ),
                      MenuItem(
                        title: "Delete",
                        icon: "assets/svg/delete.svg",
                        onTap: state.listener.deleteSchedule,
                      )
                    ],
                  ),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(RegularSize.xs),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: SvgPicture.asset(
                  "assets/svg/menu-dots.svg",
                  color: Colors.white,
                  width: RegularSize.m,
                ),
              ),
            )
          : SizedBox();
    });
  }

  void openDialog() {
    RegularDialog(
      width: Get.width * 0.9,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        vertical: RegularSize.m,
        horizontal: RegularSize.m,
      ),
      child: SingleChildScrollView(
        child: ScheduleDetail(state.property.selectedAppointment!, state.dataSource.permissions),
      ),
    ).show();
  }
}
