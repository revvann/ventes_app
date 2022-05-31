// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/schedule_form/create/schedule_fc.dart';

class _TowardDropdown extends StatelessWidget {
  ScheduleFormCreateStateController state = Get.find<ScheduleFormCreateStateController>();

  @override
  Widget build(BuildContext context) {
    return SearchableDropdown<UserDetail>(
      controller: state.formSource.towardDropdownController,
      nullable: false,
      child: Obx(() {
        return RegularInput(
          enabled: false,
          label: "Toward",
          hintText: "Select toward",
          value: state.formSource.schetoward?.user?.userfullname,
        );
      }),
      onChange: state.listener.onTowardSelected,
      onCompare: state.listener.onTowardCompared,
      onItemFilter: state.listener.onTowardFilter,
      itemBuilder: buildItem,
    );
  }

  Widget buildItem(item, isSelected) {
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
        children: [
          if (!isSelected)
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              child: Text(
                item.value.user?.userfullname?.substring(0, 2).toUpperCase() ?? "",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              decoration: BoxDecoration(
                color: RegularColor.green,
                shape: BoxShape.circle,
              ),
            ),
          SizedBox(
            width: RegularSize.s,
          ),
          Text(
            item.value.user?.userfullname ?? "",
            style: TextStyle(
              color: isSelected ? RegularColor.green : RegularColor.dark,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Container(),
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
  }
}
