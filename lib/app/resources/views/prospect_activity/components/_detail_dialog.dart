part of 'package:ventes/app/resources/views/prospect_activity/prospect_activity.dart';

class _DetailDialog extends StatelessWidget {
  ProspectActivity detail;

  _DetailDialog(this.detail);

  String? get date => detail.prospectdtdate != null ? detail.prospectdtdate! : null;

  @override
  Widget build(BuildContext context) {
    String formattedDate = date != null ? formatDate(dbParseDate(date!)) : "";

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formattedDate,
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
          title: "Description",
          value: detail.prospectdtdesc ?? '-',
        ),
        SizedBox(
          height: RegularSize.s,
        ),
        if (detail.prospectdtloc != null) ...[
          Text(
            "Location Link",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: RegularColor.dark,
            ),
          ),
          SizedBox(
            height: RegularSize.xs,
          ),
          RichText(
            text: TextSpan(
              text: detail.prospectdtloc ?? '-',
              style: TextStyle(
                fontSize: 14,
                color: RegularColor.dark,
              ),
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                TextSpan(
                  text: " Copy",
                  style: TextStyle(
                    color: RegularColor.primary,
                  ),
                  recognizer: CopyGestureRecognizer(detail.prospectdtloc!),
                ),
              ],
            ),
          ),
          SizedBox(
            height: RegularSize.s,
          ),
        ],
        Text(
          "Tags",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: RegularColor.dark,
          ),
        ),
        SizedBox(
          height: RegularSize.s,
        ),
        Wrap(
          spacing: RegularSize.s,
          runSpacing: RegularSize.s,
          children: [
            if (detail.prospectdtcat != null)
              _DetailTag(
                text: detail.prospectdtcat?.typename ?? "",
                color: RegularColor.cyan,
              ),
            if (detail.prospectdttype != null)
              _DetailTag(
                text: detail.prospectdttype?.typename ?? "",
                color: RegularColor.red,
              ),
          ],
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

class _DetailTag extends StatelessWidget {
  String text;
  Color color;
  _DetailTag({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: TextStyle(
          color: color,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: RegularSize.s,
        vertical: RegularSize.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(RegularSize.s),
      ),
    );
  }
}
