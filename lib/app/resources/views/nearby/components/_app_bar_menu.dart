// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

part of 'package:ventes/app/resources/views/nearby/nearby.dart';

class _AppBarMenu extends StatelessWidget {
  NearbyStateController state = Get.find<NearbyStateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isCustomerSelected = state.properties.selectedCustomer.isNotEmpty;
      bool isBpHasCustomer = false;
      if (state.dataSource.bpCustomers.isNotEmpty && state.properties.selectedCustomer.isNotEmpty) {
        isBpHasCustomer = state.dataSource.bpCustomersHas(state.properties.selectedCustomer.first);
      }
      return PopupMenu(
        controller: Get.put(PopupMenuController(), tag: "NearbyPopup"),
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
                if (isCustomerSelected && isBpHasCustomer) ...[
                  MenuItem(
                    title: "Edit",
                    icon: "assets/svg/edit.svg",
                    onTap: state.listener.onEditDataClick,
                  ),
                  MenuItem(
                    title: "Delete",
                    icon: "assets/svg/delete.svg",
                    onTap: state.listener.onDeleteDataClick,
                  ),
                ] else ...[
                  MenuItem(
                    title: "Add",
                    icon: "assets/svg/plus.svg",
                    onTap: state.listener.onAddDataClick,
                  )
                ],
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
    });
  }
}
