// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/prospect_form/create/prospect_fc.dart';

class _OwnerDropdown extends StatelessWidget {
  ProspectFormCreateStateController state = Get.find<ProspectFormCreateStateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return KeyableDropdown<int, UserDetail>(
          controller: state.formSource.ownerDropdownController,
          nullable: false,
          child: Obx(() {
            return RegularInput(
              enabled: false,
              label: "Owner",
              hintText: "Select user",
              value: state.formSource.prosownerString,
            );
          }),
          onChange: state.listener.onOwnerSelected,
          items: state.dataSource.users,
          itemBuilder: buildItem,
        );
      },
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
