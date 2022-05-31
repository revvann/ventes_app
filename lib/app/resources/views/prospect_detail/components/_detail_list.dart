// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/prospect_detail/prospect_detail.dart';

class _DetailList extends StatelessWidget {
  ProspectDetailStateController state = Get.find<ProspectDetailStateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: state.dataSource.prospectDetails.length,
        itemBuilder: (_, index) {
          ProspectDetail _prospectDetail = state.dataSource.prospectDetails[index];
          return GestureDetector(
            onTap: () => state.listener.onProspectDetailClicked(_prospectDetail.prospectdtid!),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        formatDate(dbParseDate(_prospectDetail.prospectdtdate!)),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: RegularColor.dark,
                        ),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
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
                          _prospectDetail.prospectdttype?.typename ?? "",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: RegularSize.m,
                  ),
                  Text(
                    _prospectDetail.prospectdtdesc ?? "",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: RegularColor.dark,
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
