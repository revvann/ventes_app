// ignore_for_file: prefer_const_constructors

part of "package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart";

class _TimezoneDropdown extends StatelessWidget {
  final ScheduleFormCreateStateController state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return KeyableDropdown<String, String>(
        controller: state.formSource.timezoneDropdownController,
        child: Obx(
          () {
            return RegularInput(
              enabled: false,
              label: "Timezone",
              value: state.formSource.timezones.firstWhereOrNull((element) => element.key == state.formSource.schetz)?.value,
              hintText: "Select timezone",
            );
          },
        ),
        nullable: false,
        items: state.formSource.timezones,
        onChange: state.listener.onTimezoneChanged,
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
                Expanded(
                  child: Text(
                    item.value,
                    style: TextStyle(
                      color: isSelected ? RegularColor.green : RegularColor.dark,
                      fontSize: 14,
                    ),
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
