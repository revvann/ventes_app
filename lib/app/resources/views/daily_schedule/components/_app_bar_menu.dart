// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

part of 'package:ventes/app/resources/views/daily_schedule/daily_schedule.dart';

class _AppBarMenu extends StatelessWidget {
  DailyScheduleStateController state = Get.find<DailyScheduleStateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return state.properties.selectedAppointment != null
          ? PopupMenu(
              controller: Get.put(PopupMenuController(), tag: "SchedulePopup"),
              dropdownSettings: DropdownSettings(
                width: 150,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: RegularSize.s,
                    horizontal: RegularSize.s,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _MenuItem(
                        title: "Detail",
                        icon: "assets/svg/detail.svg",
                        onTap: openDialog,
                      ),
                      _MenuItem(
                        title: "Edit",
                        icon: "assets/svg/edit.svg",
                        onTap: state.listener.onEditButtonClick,
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
        child: _ScheduleDetail(),
      ),
    ).show();
  }
}

class _MenuItem extends StatelessWidget {
  Function()? onTap;
  String title;
  String icon;
  Color color;

  _MenuItem({
    this.onTap,
    required this.title,
    required this.icon,
    this.color = RegularColor.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(RegularSize.s),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(RegularSize.s),
        splashColor: color.withOpacity(0.1),
        highlightColor: color.withOpacity(0.1),
        hoverColor: color.withOpacity(0.1),
        focusColor: color.withOpacity(0.1),
        onTap: onTap ?? () {},
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: RegularSize.s,
            horizontal: RegularSize.s,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                icon,
                width: RegularSize.m,
                color: color,
              ),
              SizedBox(width: RegularSize.s),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
