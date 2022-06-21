// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

part of 'package:ventes/app/resources/views/prospect_detail/prospect_detail.dart';

class _AppBarMenu extends StatelessWidget {
  ProspectDetailStateController state = Get.find<Controller>();

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
                title: "Contact",
                icon: 'assets/svg/contact.svg',
                onTap: state.listener.navigateToContactPerson,
              ),
              MenuItem(
                title: "Product",
                icon: "assets/svg/product-list.svg",
                onTap: state.listener.navigateToProduct,
              ),
              MenuItem(
                title: "Assigned Users",
                icon: "assets/svg/user.svg",
                onTap: state.listener.navigateToProspectAssign,
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
