// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/prospect_form/update/prospect_fu.dart';

class _CustomerDropdown extends StatelessWidget {
  ProspectFormUpdateStateController state = Get.find<ProspectFormUpdateStateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return KeyableDropdown<int, BpCustomer>(
          controller: state.formSource.customerDropdownController,
          nullable: false,
          child: Obx(() {
            return RegularInput(
              enabled: false,
              label: "Customer",
              hintText: "Select customer",
              value: state.formSource.proscustomerString,
            );
          }),
          onChange: state.listener.onCustomerSelected,
          items: state.dataSource.bpcustomers,
          itemBuilder: buildWidget,
        );
      },
    );
  }

  Widget buildWidget(item, isSelected) {
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
              child: Image.network(item.value.sbccstmpic!),
              decoration: BoxDecoration(
                color: RegularColor.green,
                shape: BoxShape.circle,
              ),
            ),
          SizedBox(
            width: RegularSize.s,
          ),
          Text(
            item.value.sbccstmname ?? "",
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
