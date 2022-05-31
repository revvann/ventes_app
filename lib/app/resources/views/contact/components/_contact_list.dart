// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/contact/contact.dart';

class _ContactList extends StatelessWidget {
  ContactPersonStateController state = Get.find<ContactPersonStateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: state.dataSource.contactPersons.length,
        itemBuilder: (_, index) {
          ContactPerson _contact = state.dataSource.contactPersons[index];
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
                children: [
                  Expanded(
                    child: Text(
                      _contact.contactvalueid ?? "Unavailable",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: RegularColor.dark,
                      ),
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
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
