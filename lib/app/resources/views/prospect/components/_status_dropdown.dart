// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/prospect/prospect.dart';

class _StatusDropdown extends StatelessWidget {
  ProspectStateController state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: RegularSize.m),
      child: Obx(() {
        return KeyableDropdown<int, DBType>(
          controller: state.formSource.statusDropdownController,
          child: Obx(
            () {
              return RegularInput(
                enabled: false,
                label: "Status",
                value: state.formSource.prosstatus?.typename,
                hintText: "Select status",
              );
            },
          ),
          onChange: state.listener.onStatusSelected,
          items: state.dataSource.statusItems,
          itemBuilder: (item, isSelected) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: RegularSize.s,
                vertical: RegularSize.s,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(RegularSize.s),
                color: isSelected ? RegularColor.green.withOpacity(0.3) : Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.value.typename ?? "",
                    style: TextStyle(
                      color: isSelected ? RegularColor.green : RegularColor.dark,
                      fontSize: 14,
                    ),
                  ),
                  if (isSelected)
                    SvgPicture.asset(
                      "assets/svg/check.svg",
                      color: RegularColor.green,
                      height: RegularSize.m,
                      width: RegularSize.m,
                    ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
