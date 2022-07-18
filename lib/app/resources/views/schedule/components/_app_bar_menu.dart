// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

part of 'package:ventes/app/resources/views/schedule/schedule.dart';

class _AppBarMenu extends StatelessWidget {
  Controller state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return PopupMenu(
      controller: state.property.popupMenuController,
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
                title: "Daily View",
                icon: "assets/svg/detail.svg",
                onTap: state.listener.onDetailClick,
              ),
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
    );
  }
}
