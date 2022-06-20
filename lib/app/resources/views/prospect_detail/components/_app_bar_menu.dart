// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

part of 'package:ventes/app/resources/views/prospect_detail/prospect_detail.dart';

class _AppBarMenu extends StatelessWidget {
  ProspectDetailStateController state = Get.find<ProspectDetailStateController>();

  @override
  Widget build(BuildContext context) {
    return PopupMenu(
      controller: Get.put(PopupMenuController(), tag: "prospectPopup"),
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
                onTap: showProspectDetail,
              ),
              MenuItem(
                title: "Edit",
                icon: "assets/svg/edit.svg",
                onTap: state.listener.navigateToProspectUpdateForm,
              ),
              MenuItem(
                title: "Add Detail",
                icon: "assets/svg/plus.svg",
                onTap: state.listener.navigateToProspectDetailForm,
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

  void showProspectDetail() {
    RegularDialog(
      width: Get.width * 0.9,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        vertical: RegularSize.m,
        horizontal: RegularSize.m,
      ),
      child: ProspectDetailDialog(
        state.dataSource.prospect!,
        stages: state.dataSource.stages,
      ),
    ).show();
  }
}
