part of 'package:ventes/app/resources/views/prospect_form/update/prospect_fu.dart';

class _StageDropdown extends StatelessWidget {
  Controller state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return KeyableDropdown<int, DBType>(
        controller: state.formSource.stageDropdownController,
        nullable: false,
        child: Obx(
          () {
            return RegularInput(
              enabled: false,
              label: "Stage",
              value: state.formSource.prosstage?.typename,
              hintText: "Select stage",
            );
          },
        ),
        onChange: state.listener.onStageSelected,
        items: state.dataSource.stagesHandler.value,
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
