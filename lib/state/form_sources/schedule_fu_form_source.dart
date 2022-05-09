// ignore_for_file: unnecessary_getters_setters, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_guest_model.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/resources/widgets/regular_dropdown.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/state/controllers/schedule_fu_state_controller.dart';
import 'package:ventes/state/form_sources/schedule_fc_form_source.dart';
import 'package:ventes/state/form_validators/schedule_fu_validator.dart';
import 'package:ventes/state/listeners/schedule_fu_listener.dart';

class ScheduleFormUpdateFormSource {
  int readOnlyId = 14;
  int addMemberId = 15;
  int shareLinkId = 16;

  ScheduleFormUpdateProperties get _properties => Get.find<ScheduleFormUpdateProperties>();
  ScheduleFormUpdateListener get _listener => Get.find<ScheduleFormUpdateListener>();
  late ScheduleFormUpdateValidator validator;

  UserDetail? userDefault;

  final schenmTEC = TextEditingController();
  final schestartdateTEC = TextEditingController();
  final scheenddateTEC = TextEditingController();
  final schelocTEC = TextEditingController();
  final scheremindTEC = TextEditingController();
  final schedescTEC = TextEditingController();
  final scheonlinkTEC = TextEditingController();
  final schestarttimeDC = DropdownController<String?>(null);
  final scheendtimeDC = DropdownController<String?>(null);
  final schetzDC = DropdownController<String?>(null);
  final formKey = GlobalKey<FormState>();

  int scheid = -1;
  String _scheonlink = "";
  String _scheloc = "";
  final Rx<DateTime> _schestartdate = Rx<DateTime>(DateTime.now());
  final Rx<DateTime> _scheenddate = Rx<DateTime>(DateTime.now());
  final Rx<DateTime?> _schestarttime = Rx<DateTime?>(null);
  final Rx<DateTime?> _scheendtime = Rx<DateTime?>(null);
  final Rx<int> _schetype = Rx<int>(0);
  final Rx<bool> _scheprivate = Rx<bool>(false);
  final Rx<bool> _scheallday = Rx<bool>(false);
  final Rx<bool> _scheonline = Rx<bool>(false);
  final Rx<List<ScheduleGuest>> _guests = Rx<List<ScheduleGuest>>([]);
  final Rx<UserDetail?> _schetoward = Rx<UserDetail?>(null);

  bool get isEvent => _properties.dataSource.typeName(schetype) == "Event";
  bool get isTask => _properties.dataSource.typeName(schetype) == "Task";
  bool get isReminder => _properties.dataSource.typeName(schetype) == "Reminder";

  int? get schebpid => schetoward?.userdtbpid;

  String get schenm => schenmTEC.text;
  set schenm(String value) {
    schenmTEC.text = value;
  }

  DateTime get schestartdate => _schestartdate.value;
  set schestartdate(DateTime? value) {
    if (value != null) {
      schestartdateTEC.text = formatDate(value);
      _schestartdate.value = value;
    }
  }

  DateTime get scheenddate => _scheenddate.value;
  set scheenddate(DateTime? value) {
    if (value != null) {
      _scheenddate.value = value;
      scheenddateTEC.text = formatDate(value);
    }
  }

  DateTime? get schestarttime => _schestarttime.value;
  set schestarttime(DateTime? value) {
    if (value == null) {
      schestarttimeDC.value = null;
      _schestarttime.value = null;
    } else {
      schestarttimeDC.value = formatTime(value);
      _schestarttime.value = value;
    }
  }

  set schestarttimequiet(DateTime? value) {
    _schestarttime.value = value;
  }

  DateTime? get scheendtime => _scheendtime.value;
  set scheendtime(DateTime? value) {
    if (value == null) {
      scheendtimeDC.value = null;
    } else {
      scheendtimeDC.items = createTimeList(value.hour, value.minute);
      scheendtimeDC.value = formatTime(value);
    }
    _scheendtime.value = value;
  }

  set scheendtimequiet(DateTime? value) {
    _scheendtime.value = value;
  }

  int get schetype => _schetype.value;
  set schetype(int value) => _schetype.value = value;

  bool get scheallday => _scheallday.value;
  set scheallday(bool value) => _scheallday.value = value;

  String get scheloc => _scheloc;
  set scheloc(String value) {
    schelocTEC.text = value;
    _scheloc = value;
  }

  set schelocquiet(String value) {
    _scheloc = value;
  }

  String? get schedesc => schedescTEC.text;
  set schedesc(String? value) {
    schedescTEC.text = value ?? "";
  }

  bool get scheonline => _scheonline.value;
  set scheonline(bool value) => _scheonline.value = value;

  bool get scheprivate => _scheprivate.value;
  set scheprivate(bool value) => _scheprivate.value = value;

  int get scheremind => int.tryParse(scheremindTEC.text) ?? 0;
  set scheremind(int? value) {
    scheremindTEC.text = (value ?? 0).toString();
  }

  String get scheonlink => _scheonlink;
  set scheonlink(String? value) {
    if (value != null) {
      scheonlinkTEC.text = value;
      _scheonlink = value;
    }
  }

  set scheonlinkquiet(String value) {
    _scheonlink = value;
  }

  String? get schetz => schetzDC.value;
  set schetz(String? value) {
    schetzDC.value = value;
  }

  List<ScheduleGuest> get guests => _guests.value;
  set guests(List<ScheduleGuest> value) => _guests.value = value;

  UserDetail? get schetoward => _schetoward.value;
  set schetoward(UserDetail? value) => _schetoward.value = value;

  DateTime get fullStartDate {
    return DateTime(
      schestartdate.year,
      schestartdate.month,
      schestartdate.day,
      schestarttime?.hour ?? 0,
      schestarttime?.minute ?? 0,
      schestarttime?.second ?? 0,
    );
  }

  DateTime get fullEndDate {
    return DateTime(
      scheenddate.year,
      scheenddate.month,
      scheenddate.day,
      scheendtime?.hour ?? 0,
      scheendtime?.minute ?? 0,
      scheendtime?.second ?? 0,
    );
  }

  void addGuest(UserDetail guest) {
    _guests.update((value) => value!.add(
          ScheduleGuest(
            scheuserid: guest.userid,
            schebpid: guest.userdtbpid,
            scheuser: guest.user,
            businesspartner: guest.businesspartner,
          ),
        ));
  }

  void removeGuest(guest) {
    int? userid = guest is UserDetail ? guest.userid : guest.scheuserid;
    _guests.update((value) => value!.removeWhere((g) => g.scheuserid == userid));
  }

  void setPermission(int userid, List<int> permission) {
    _guests.update((value) => value!.firstWhere((g) => g.scheuserid == userid).schepermisid = permission);
  }

  void removePermission(int userid, int permission) {
    _guests.update((value) {
      if (value != null) {
        var guest = value.firstWhere((g) => g.scheuserid == userid);
        if (guest.schepermisid != null) {
          guest.schepermisid!.remove(permission);
        }
      }
    });
  }

  void addPermission(int userid, int permission) {
    _guests.update((value) {
      if (value != null) {
        var guest = value.firstWhere((g) => g.scheuserid == userid);
        if (guest.schepermisid != null) {
          guest.schepermisid!.add(permission);
        } else {
          guest.schepermisid = [permission];
        }
      }
    });
  }

  bool hasPermission(int userid, SchedulePermission permission) {
    switch (permission) {
      case SchedulePermission.readOnly:
        return _guests.value.firstWhere((g) => g.scheuserid == userid).schepermisid?.contains(readOnlyId) ?? false;
      case SchedulePermission.addMember:
        return _guests.value.firstWhere((g) => g.scheuserid == userid).schepermisid?.contains(addMemberId) ?? false;
      case SchedulePermission.shareLink:
        return _guests.value.firstWhere((g) => g.scheuserid == userid).schepermisid?.contains(shareLinkId) ?? false;
      default:
        return false;
    }
  }

  bool isValid() {
    return formKey.currentState?.validate() ?? false;
  }

  void setEndTimeList() {
    DateTime maxDate = DateTime(scheenddate.year, scheenddate.month, scheenddate.day, 23, 59);
    bool hasMoreTime = maxDate.difference(fullStartDate).inMinutes >= 15;
    if (hasMoreTime) {
      if (fullStartDate.difference(fullEndDate).inSeconds >= 0) {
        DateTime _dateEnd = fullEndDate.subtract(Duration(
          hours: fullEndDate.hour,
          minutes: fullEndDate.minute,
        ));
        scheenddate = scheendtime = _dateEnd.add(Duration(
          hours: fullStartDate.hour,
          minutes: fullStartDate.minute + 15,
        ));
      }
    } else {
      DateTime dateEnd = fullEndDate.subtract(Duration(minutes: fullEndDate.minute, hours: fullEndDate.hour));
      scheenddate = scheendtime = dateEnd.add(Duration(days: 1, minutes: 15));
    }
  }

  void setStartTimeList() {
    DateTime date = DateTime.now();
    schestarttimeDC.items = createTimeList();
    scheendtimeDC.items = createTimeList(date.hour, date.minute);
    schestarttimeDC.value = schestarttimeDC.items.first['value'];
    scheendtimeDC.value = scheendtimeDC.items.first['value'];

    schestartdate = schestarttime = DateTime(date.year, date.month, date.day, 0, 0);
    scheenddate = scheendtime = DateTime(date.year, date.month, date.day, 0, 0);
    setEndTimeList();
  }

  void prepareFormValue() {
    if (_properties.dataSource.schedule != null) {
      Schedule schedule = _properties.dataSource.schedule!;
      scheid = schedule.scheid ?? -1;
      schenm = schedule.schenm ?? "";
      schetype = _properties.dataSource.typeIndex(schedule.schetypeid ?? 0);
      schestartdate = dbParseDate(schedule.schestartdate!);
      scheenddate = dbParseDate(schedule.scheenddate ?? schedule.schestartdate!);
      schestarttime = !(schedule.scheallday ?? false) ? parseTime(schedule.schestarttime!) : null;
      scheendtime = !(schedule.scheallday ?? false) ? parseTime(schedule.scheendtime ?? schedule.schestarttime!) : null;
      schetzDC.value = schedule.schetz;

      scheallday = schedule.scheallday ?? false;
      _listener.onAlldayValueChanged(scheallday);

      scheloc = schedule.scheloc ?? "";
      scheonline = schedule.scheonline ?? false;
      scheonlink = schedule.scheonlink ?? "";
      scheremind = schedule.scheremind ?? 1;
      schedesc = schedule.schedesc ?? "";
      scheprivate = schedule.scheprivate ?? false;
      schetoward = UserDetail(
        userid: schedule.schetowardid,
        user: schedule.schetoward,
      );
      guests = schedule.scheguest ?? [];
    }
  }

  formSourceDispose() {
    schenmTEC.dispose();
    schestartdateTEC.dispose();
    scheenddateTEC.dispose();
    schelocTEC.dispose();
    scheremindTEC.dispose();
    schedescTEC.dispose();
    scheonlinkTEC.dispose();
  }

  formSourceInit() async {
    validator = ScheduleFormUpdateValidator(this);

    setStartTimeList();

    scheremindTEC.text = "0";
    scheonlinkTEC.addListener(_listener.onOnlineLinkChanged);
    schelocTEC.addListener(_listener.onLocationChanged);

    userDefault = await _properties.dataSource.userActive;
    schetoward = userDefault;
    schetzDC.items = getTimezoneList();
    String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    schetzDC.value = currentTimeZone;
  }

  Map<String, dynamic> toJson() {
    return {
      "scheid": scheid,
      "schenm": schenm,
      "schestartdate": formatDate(schestartdate),
      "scheenddate": isEvent ? formatDate(scheenddate) : null,
      "schestarttime": _schestarttime.value != null ? formatTime(_schestarttime.value!) : null,
      "scheendtime": isEvent ? (_scheendtime.value != null ? formatTime(_scheendtime.value!) : null) : null,
      "scheloc": isEvent ? scheloc : null,
      "scheremind": isEvent ? scheremind : null,
      "schedesc": !isReminder ? schedesc : null,
      "scheonline": isEvent ? scheonline : false,
      "scheonlink": isEvent ? scheonlink : null,
      "scheallday": scheallday,
      "schetypeid": _properties.dataSource.typeId(schetype),
      "schetz": isEvent ? schetz : null,
      "scheprivate": isEvent ? scheprivate : false,
      "schetowardid": isEvent ? schetoward?.userid : userDefault?.userid,
      "schebpid": isEvent ? schebpid : userDefault?.userdtbpid,
      "members": isEvent ? jsonEncode(guests.map((g) => g.toJson()).toList()) : null,
    };
  }
}
