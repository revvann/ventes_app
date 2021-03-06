// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/contact/contact.dart';

class _ContactList extends StatelessWidget {
  ContactPersonStateController state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return HandlerContainer<Function(List<ContactPerson>)>(
      handlers: [state.dataSource.contactsHandler],
      width: RegularSize.xl,
      builder: (contactPersons) => ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: contactPersons.length,
        itemBuilder: (_, index) {
          ContactPerson _contact = contactPersons[index];
          return GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: RegularSize.m,
                horizontal: RegularSize.m,
              ),
              margin: EdgeInsets.only(
                bottom: RegularSize.m,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(RegularSize.m),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 30,
                    color: Color(0xFF0157E4).withOpacity(0.1),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _contact.contactname ?? "Unknown",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: RegularColor.dark,
                          ),
                        ),
                        SizedBox(
                          height: RegularSize.s,
                        ),
                        Text(
                          _contact.contactvalueid ?? "Unavailable",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: RegularColor.dark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: RegularSize.s),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: RegularSize.s,
                      vertical: RegularSize.xs,
                    ),
                    decoration: BoxDecoration(
                      color: RegularColor.secondary,
                      borderRadius: BorderRadius.circular(RegularSize.s),
                    ),
                    child: Text(
                      _contact.contacttype?.typename ?? "",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: RegularSize.s),
                  PopupMenu(
                    controller: state.property.createPopupController(index),
                    dropdownSettings: DropdownSettings(
                      width: 150,
                      offset: Offset(10, 5),
                      builder: (controller) => Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: RegularSize.s,
                          horizontal: RegularSize.s,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MenuItem(
                              title: "Edit",
                              icon: "assets/svg/edit.svg",
                              onTap: () => state.listener.navigateToUpdateForm(_contact.contactpersonid!),
                            ),
                            MenuItem(
                              title: "Delete",
                              icon: "assets/svg/delete.svg",
                              onTap: () => state.listener.deleteData(_contact.contactpersonid!),
                            ),
                          ],
                        ),
                      ),
                    ),
                    child: Container(
                      width: 20,
                      height: 20,
                      padding: EdgeInsets.all(RegularSize.xs),
                      alignment: Alignment.center,
                      child: Transform.rotate(
                        angle: pi / 2,
                        child: SvgPicture.asset(
                          "assets/svg/menu-dots.svg",
                          color: RegularColor.dark,
                          width: RegularSize.m,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
