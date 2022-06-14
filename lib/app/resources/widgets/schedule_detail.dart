// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:ventes/app/models/schedule_guest_model.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/constants/regular_color.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/helpers/function_helpers.dart';

class ScheduleDetail extends StatelessWidget {
  Schedule schedule;
  List<DBType> permissions;

  ScheduleDetail(this.schedule, [this.permissions = const []]);

  String? get startDate => schedule.schestartdate != null ? schedule.schestartdate! : null;
  String? get endDate => schedule.scheenddate != null ? schedule.scheenddate! : null;
  String? get startTime => schedule.schestarttime != null ? schedule.schestarttime! : null;
  String? get endTime => schedule.scheendtime != null ? schedule.scheendtime! : null;

  @override
  Widget build(BuildContext context) {
    String formattedStartDate = startDate != null ? formatDate(dbParseDate(startDate!)) : "";
    String formattedEndDate = endDate != null ? formatDate(dbParseDate(endDate!)) : "";
    String formattedStartTime = startTime != null ? formatTime(parseTime(startTime!)) : "";
    String formattedEndTime = endTime != null ? formatTime(parseTime(endTime!)) : "";

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          schedule.schenm ?? "",
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
          schedule.schetoward?.userfullname ?? "Unknown",
          style: TextStyle(
            fontSize: 14,
            color: RegularColor.gray,
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
            height: RegularSize.s,
          ),
        ],
        if (formattedStartTime.isNotEmpty || formattedEndTime.isNotEmpty) ...[
          _DetailItem(
            title: "Time",
            value: "$formattedStartTime${formattedStartTime.isNotEmpty && formattedEndTime.isNotEmpty ? ' - ' : ''}$formattedEndTime",
          ),
          SizedBox(
            height: RegularSize.s,
          ),
        ],
        if (schedule.schetz != null) ...[
          _DetailItem(
            title: "Timezone",
            value: schedule.schetz!,
          ),
          SizedBox(
            height: RegularSize.s,
          ),
        ],
        _DetailItem(
          title: "Remind In",
          value: schedule.scheremind != null ? "${schedule.scheremind} Minutes" : 'No Reminder',
        ),
        SizedBox(
          height: RegularSize.s,
        ),
        if (schedule.scheloc != null) ...[
          Text(
            "Location",
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
              text: schedule.scheloc ?? '-',
              style: TextStyle(
                fontSize: 14,
                color: RegularColor.dark,
              ),
              children: [
                TextSpan(
                  text: " Copy",
                  style: TextStyle(
                    color: RegularColor.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: RegularSize.s,
          ),
        ],
        if (schedule.scheonlink != null) ...[
          Text(
            "Meeting Link",
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
              text: schedule.scheonlink ?? '-',
              style: TextStyle(
                fontSize: 14,
                color: RegularColor.dark,
              ),
              children: [
                TextSpan(
                  text: " Copy",
                  style: TextStyle(
                    color: RegularColor.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: RegularSize.s,
          ),
        ],
        if (schedule.schedesc != null) ...[
          _DetailItem(
            title: "Description",
            value: schedule.schedesc ?? '-',
          ),
          SizedBox(
            height: RegularSize.s,
          ),
        ],
        if (schedule.scheguest?.isNotEmpty ?? false) ...[
          Text(
            "Guests",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: RegularColor.dark,
            ),
          ),
          SizedBox(
            height: RegularSize.s,
          ),
          _GuestList(
            guests: schedule.scheguest ?? [],
            permissions: permissions,
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
            Builder(builder: (context) {
              Color color;
              String scheduleype = schedule.schetype?.typename ?? "Unknown";

              if (scheduleype == "Event") {
                color = RegularColor.yellow;
              } else if (scheduleype == "Task") {
                color = RegularColor.red;
              } else if (scheduleype == "Reminder") {
                color = RegularColor.cyan;
              } else {
                color = RegularColor.gray;
              }
              return _DetailTag(
                text: scheduleype,
                color: color,
              );
            }),
            if (schedule.scheallday ?? false)
              _DetailTag(
                text: "Allday",
                color: RegularColor.indigo,
              ),
            if (schedule.scheprivate ?? false)
              _DetailTag(
                text: "Private",
                color: RegularColor.pink,
              ),
            _DetailTag(
              text: schedule.scheonline ?? false ? "Online" : "On Site",
              color: RegularColor.green,
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

class _GuestList extends StatelessWidget {
  _GuestList({
    required this.guests,
    this.permissions = const [],
  });

  List<ScheduleGuest> guests;
  List<DBType> permissions;

  DBType findPermission(int id) {
    return permissions.firstWhere((p) => p.typeid == id, orElse: () => DBType());
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: guests.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        ScheduleGuest item = guests[index];
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0)
              SizedBox(
                height: RegularSize.s,
              ),
            _GuestListItem(
              guest: item,
            ),
            SizedBox(
              height: RegularSize.s,
            ),
            Wrap(
              spacing: RegularSize.s,
              runSpacing: RegularSize.s,
              children: [
                for (int permissionid in item.schepermisid ?? []) ...[
                  Builder(builder: (context) {
                    DBType permission = findPermission(permissionid);
                    return _DetailTag(
                      text: permission.typename ?? "Unknown",
                      color: RegularColor.green,
                    );
                  }),
                ]
              ],
            ),
          ],
        );
      },
    );
  }
}

class _GuestListItem extends StatelessWidget {
  _GuestListItem({
    this.guest,
  });
  ScheduleGuest? guest;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: RegularSize.s,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: Text(
              getInitials(guest?.scheuser?.userfullname ?? ""),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            decoration: BoxDecoration(
              color: RegularColor.primary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: RegularSize.s),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                guest?.scheuser?.userfullname ?? "",
                style: TextStyle(
                  color: RegularColor.dark,
                  fontSize: 16,
                ),
              ),
              Text(
                guest?.businesspartner?.bpname ?? "",
                style: TextStyle(
                  color: RegularColor.gray,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
