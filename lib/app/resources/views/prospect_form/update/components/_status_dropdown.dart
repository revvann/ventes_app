part of 'package:ventes/app/resources/views/prospect_form/update/prospect_fu.dart';

class _StatusDropdown extends StatelessWidget {
  Controller state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return KeyableDropdown<int, DBType>(
        controller: state.formSource.statusDropdownController,
        nullable: false,
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
        items: state.dataSource.statusesHandler.value,
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
    });
  }
}
