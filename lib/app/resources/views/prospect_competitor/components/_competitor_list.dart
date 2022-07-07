part of 'package:ventes/app/resources/views/prospect_competitor/prospect_competitor.dart';

class _CompetitorList extends StatelessWidget {
  Controller state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return HandlerContainer<Function(List<Competitor>)>(
      handlers: [state.dataSource.competitorsHandler],
      width: RegularSize.xl,
      builder: (competitors) => ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: competitors.length,
        itemBuilder: (_, index) {
          Competitor _competitor = competitors[index];
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
                          _competitor.comptname ?? "Unknown",
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
                          _competitor.comptproductname ?? "Unavailable",
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
                              onTap: () => state.listener.navigateToCompetitorFormUpdate(_competitor.comptid!),
                            ),
                            MenuItem(
                              title: "Delete",
                              icon: "assets/svg/delete.svg",
                              onTap: () {},
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
