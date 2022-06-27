import 'package:flutter/material.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/stage_item.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/helpers/function_helpers.dart';

class ProspectActivityDialog extends StatelessWidget {
  Prospect prospect;
  List<DBType> stages;

  ProspectActivityDialog(
    this.prospect, {
    this.stages = const [],
  });

  String? get startDate => prospect.prospectstartdate != null ? prospect.prospectstartdate! : null;
  String? get endDate => prospect.prospectenddate != null ? prospect.prospectenddate! : null;
  String? get expectedDate => prospect.prospectexpclosedate != null ? prospect.prospectexpclosedate! : null;

  @override
  Widget build(BuildContext context) {
    String formattedStartDate = startDate != null ? formatDate(dbParseDate(startDate!)) : "";
    String formattedEndDate = endDate != null ? formatDate(dbParseDate(endDate!)) : "";
    String formattedExpectedDate = expectedDate != null ? formatDate(dbParseDate(expectedDate!)) : "";

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            prospect.prospectname ?? "",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: RegularColor.dark,
            ),
          ),
          SizedBox(
            height: RegularSize.xs,
          ),
          Text(
            prospect.prospectowneruser?.user?.userfullname ?? "Unknown",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: RegularColor.dark,
            ),
          ),
          SizedBox(
            height: RegularSize.m,
          ),
          if (formattedStartDate.isNotEmpty || formattedEndDate.isNotEmpty) ...[
            _DetailItem(
              title: "Date",
              value: "$formattedStartDate${formattedStartDate.isNotEmpty && formattedEndDate.isNotEmpty ? ' - ' : ''}$formattedEndDate",
            ),
            SizedBox(
              height: RegularSize.m,
            ),
          ],
          if (formattedExpectedDate.isNotEmpty) ...[
            _DetailItem(
              title: "Expected Close Date",
              value: formattedExpectedDate,
            ),
            SizedBox(
              height: RegularSize.m,
            ),
          ],
          _DetailItem(title: "Customer", value: prospect.prospectcust?.sbccstmname ?? "Unknown"),
          SizedBox(
            height: RegularSize.m,
          ),
          _DetailItem(title: "Prospect Value", value: currencyFormat(prospect.prospectvalue?.toString().replaceAll('.', ',') ?? "0")),
          SizedBox(
            height: RegularSize.m,
          ),
          Text(
            "Stage",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: RegularColor.dark,
            ),
          ),
          SizedBox(
            height: RegularSize.s,
          ),
          Row(
            children: [
              for (DBType stage in stages) ...[
                Expanded(
                  child: StageItem(
                    height: 30,
                    width: 70,
                    color: stage.typeid == prospect.prospectstageid ? RegularColor.green : RegularColor.gray,
                    child: Text(
                      stage.typename ?? "-",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(
            height: RegularSize.m,
          ),
          _DetailItem(title: "Description", value: prospect.prospectdescription ?? ""),
          SizedBox(
            height: RegularSize.m,
          ),
          Text(
            "More",
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
              if (prospect.prospectstatus != null)
                _DetailTag(
                  text: prospect.prospectstatus?.typename ?? "-",
                  color: RegularColor.green,
                ),
            ],
          ),
        ],
      ),
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
