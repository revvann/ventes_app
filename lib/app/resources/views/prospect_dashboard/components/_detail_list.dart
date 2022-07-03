part of 'package:ventes/app/resources/views/prospect_dashboard/prospect_dashboard.dart';

class _DetailList extends StatelessWidget {
  Controller state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return HandlerContainer<Function(Prospect?)>(
        handlers: [state.dataSource.prospectHandler],
        width: RegularSize.xl,
        builder: (prospect) {
          String startDate = prospect?.prospectstartdate != null ? Utils.formatDate(Utils.dbParseDate(prospect!.prospectstartdate!)) : "";
          String endDate = prospect?.prospectenddate != null ? Utils.formatDate(Utils.dbParseDate(prospect!.prospectenddate!)) : "";
          String expCloseDate = prospect?.prospectexpclosedate != null ? Utils.formatDate(Utils.dbParseDate(prospect!.prospectexpclosedate!)) : "";
          String value = Utils.currencyFormat(prospect?.prospectvalue?.toString() ?? "0");
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailItem(title: "Name", value: prospect?.prospectname ?? "-"),
              SizedBox(height: RegularSize.s),
              _DetailItem(title: "Date", value: "$startDate - $endDate"),
              SizedBox(height: RegularSize.s),
              _DetailItem(title: "Expectation Close Date", value: expCloseDate),
              SizedBox(height: RegularSize.s),
              _DetailItem(title: "Value", value: value),
              SizedBox(height: RegularSize.s),
              _DetailItem(title: "Description", value: prospect?.prospectdescription ?? "-"),
            ],
          );
        });
  }
}
