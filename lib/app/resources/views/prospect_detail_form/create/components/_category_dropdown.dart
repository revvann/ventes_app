// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/prospect_detail_form/create/prospect_detail_fc.dart';

class _CategoryDropdown extends StatelessWidget {
  ProspectDetailFormCreateStateController state = Get.find<ProspectDetailFormCreateStateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return KeyableDropdown<int, DBType>(
        controller: state.formSource.categoryDropdownController,
        nullable: false,
        child: Obx(
          () {
            return RegularInput(
              enabled: false,
              label: "Category",
              value: state.formSource.prosdtcategory?.typename,
              hintText: "Select category",
            );
          },
        ),
        onChange: state.listener.onCategorySelected,
        items: state.dataSource.categoryItems,
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
