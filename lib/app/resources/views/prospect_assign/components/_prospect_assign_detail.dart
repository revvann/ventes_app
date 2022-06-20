part of 'package:ventes/app/resources/views/prospect_assign/prospect_assign.dart';

class _ProspectAssignDetail extends StatelessWidget {
  ProspectAssign prospectAssign;

  _ProspectAssignDetail(this.prospectAssign);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Prospect Assign Detail",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: RegularColor.dark,
          ),
        ),
        SizedBox(
          height: RegularSize.m,
        ),
        _DetailItem(
          title: "Assign To",
          value: prospectAssign.prospectassign?.user?.userfullname ?? '-',
        ),
        SizedBox(
          height: RegularSize.s,
        ),
        _DetailItem(
          title: "Report To",
          value: prospectAssign.prospectreport?.user?.userfullname ?? '-',
        ),
        SizedBox(
          height: RegularSize.s,
        ),
        _DetailItem(
          title: "Description",
          value: prospectAssign.prospectassigndesc ?? '-',
        ),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  String title;
  String value;
  Color color;

  _DetailItem({
    required this.title,
    required this.value,
    this.color = RegularColor.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(
          height: RegularSize.xs,
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: color,
          ),
        ),
      ],
    );
  }
}
