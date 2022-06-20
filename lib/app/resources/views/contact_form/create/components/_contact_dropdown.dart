part of "package:ventes/app/resources/views/contact_form/create/contact_person_fc.dart";

class _ContactDropdown extends StatelessWidget {
  ContactPersonFormCreateStateController state = Get.find<ContactPersonFormCreateStateController>();

  @override
  Widget build(BuildContext context) {
    return SearchableDropdown<Contact>(
      controller: state.formSource.contactDropdownController,
      isMultiple: false,
      nullable: false,
      child: Obx(() {
        return RegularInput(
          enabled: false,
          label: "Phone Number",
          hintText: "select phone number",
          value: state.formSource.contact?.phones?.first.value,
        );
      }),
      onChange: state.listener.onContactChanged,
      onCompare: state.listener.onContactCompared,
      onItemFilter: state.listener.onContactFilter,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.value.givenName ?? "",
                    style: TextStyle(
                      color: isSelected ? RegularColor.green : RegularColor.dark,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: RegularSize.xs),
                  Text(
                    item.value.phones?.first.value ?? "",
                    style: TextStyle(
                      color: isSelected ? RegularColor.green : RegularColor.dark,
                      fontSize: 14,
                    ),
                  ),
                ],
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
  }
}
