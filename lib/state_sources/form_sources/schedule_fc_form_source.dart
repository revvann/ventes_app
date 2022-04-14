// ignore_for_file: unnecessary_getters_setters, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/app/models/schedule_guest_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/state_sources/data_sources/schedule_fc_data_source.dart';
import 'package:ventes/state_sources/form_listeners/schedule_fc_listener.dart';
import 'package:ventes/state_sources/form_validators/schedule_fc_validator.dart';
import 'package:ventes/app/resources/widgets/regular_dropdown.dart';

class ScheduleFormCreateFormSource {
  int readOnlyId = 14;
  int addMemberId = 15;
  int shareLinkId = 16;

  int eventId = 11;
  int taskId = 10;
  int reminderId = 12;

  late ScheduleFormCreateDataSource dataSource;
  late ScheduleFormCreateValidator validator;
  late ScheduleFormCreateListener listener;

  final schenmTEC = TextEditingController();
  final schestartdateTEC = TextEditingController();
  final scheenddateTEC = TextEditingController();
  final schelocTEC = TextEditingController();
  final scheremindTEC = TextEditingController();
  final schedescTEC = TextEditingController();
  final scheonlinkTEC = TextEditingController();
  final schestarttimeDC = DropdownController<String?>(null);
  final scheendtimeDC = DropdownController<String?>(null);
  final formKey = GlobalKey<FormState>();

  String _schenm = "";
  String _scheloc = "";
  String _schedesc = "";
  String _scheonlink = "";
  int _scheremind = 0;
  final Rx<DateTime> _schestartdate = Rx<DateTime>(DateTime.now());
  final Rx<DateTime> _scheenddate = Rx<DateTime>(DateTime.now());
  final Rx<DateTime?> _schestarttime = Rx<DateTime?>(null);
  final Rx<DateTime?> _scheendtime = Rx<DateTime?>(null);
  final Rx<int> _schetype = Rx<int>(11);
  final Rx<bool> _scheallday = Rx<bool>(false);
  final Rx<bool> _scheonline = Rx<bool>(false);
  final Rx<List<ScheduleGuest>> _guests = Rx<List<ScheduleGuest>>([]);

  String get schenm => _schenm;
  set schenm(String value) {
    schenmTEC.text = value;
    _schenm = value;
  }

  DateTime get schestartdate => _schestartdate.value;
  set schestartdate(DateTime value) {
    schestartdateTEC.text = formatDate(value);
    _schestartdate.value = value;
  }

  DateTime get scheenddate => _scheenddate.value;
  set scheenddate(DateTime value) {
    scheenddateTEC.text = formatDate(value);
    _scheenddate.value = value;
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
    if (value == null) {
      _schestarttime.value = null;
    } else {
      _schestarttime.value = value;
    }
  }

  DateTime? get scheendtime => _scheendtime.value;
  set scheendtime(DateTime? value) {
    if (value == null) {
      scheendtimeDC.value = null;
      _scheendtime.value = null;
    } else {
      scheendtimeDC.items = createTimeList(value.hour, value.minute);
      scheendtimeDC.value = formatTime(value);
      _scheendtime.value = value;
    }
  }

  set scheendtimequiet(DateTime? value) {
    if (value == null) {
      _scheendtime.value = null;
    } else {
      _scheendtime.value = value;
    }
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

  bool get scheonline => _scheonline.value;
  set scheonline(bool value) => _scheonline.value = value;

  int get scheremind => _scheremind;
  set scheremind(int value) {
    scheremindTEC.text = value.toString();
    _scheremind = value;
  }

  String get schedescription => _schedesc;
  set schedescription(String value) {
    schedescTEC.text = value;
    _schedesc = value;
  }

  String get scheonlink => _scheonlink;
  set scheonlink(String value) {
    scheonlinkTEC.text = value;
    _scheonlink = value;
  }

  List<ScheduleGuest> get guests => _guests.value;
  set guests(List<ScheduleGuest> value) => _guests.value = value;

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
    _guests.update((value) => value!
      ..add(
        ScheduleGuest(
          userid: guest.userid,
          schebpid: guest.userdtbpid,
          user: guest.user,
          businesspartner: guest.businesspartner,
        ),
      ));
  }

  void removeGuest(guest) {
    _guests.update((value) => value!..removeWhere((g) => g.userid == guest.userid));
  }

  void setPermission(int userid, List<int> permission) {
    _guests.update((value) => value!..firstWhere((g) => g.userid == userid).schepermisid = permission);
  }

  void removePermission(int userid, int permission) {
    _guests.update((value) {
      if (value != null) {
        var guest = value.firstWhere((g) => g.userid == userid);
        if (guest.schepermisid != null) {
          guest.schepermisid!.remove(permission);
        }
      }
    });
  }

  void addPermission(int userid, int permission) {
    _guests.update((value) {
      if (value != null) {
        var guest = value.firstWhere((g) => g.userid == userid);
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
        return _guests.value.firstWhere((g) => g.userid == userid).schepermisid?.contains(readOnlyId) ?? false;
      case SchedulePermission.addMember:
        return _guests.value.firstWhere((g) => g.userid == userid).schepermisid?.contains(addMemberId) ?? false;
      case SchedulePermission.shareLink:
        return _guests.value.firstWhere((g) => g.userid == userid).schepermisid?.contains(shareLinkId) ?? false;
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

  dispose() {
    schenmTEC.dispose();
    schestartdateTEC.dispose();
    scheenddateTEC.dispose();
    schelocTEC.dispose();
    scheremindTEC.dispose();
    schedescTEC.dispose();
    scheonlinkTEC.dispose();
  }

  init() {
    validator = ScheduleFormCreateValidator(this);
    listener = ScheduleFormCreateListener(this);
    setStartTimeList();
    scheremindTEC.text = _scheremind.toString();
    _scheonline.stream.listen((value) {
      if (value) {
        scheonlinkTEC.text = _scheonlink;
        schelocTEC.text = "";
      } else {
        scheonlinkTEC.text = "";
        schelocTEC.text = _scheloc;
      }
    });
    _scheallday.stream.listen((value) {
      if (value) {
        schestarttimeDC.enabled = false;
        scheendtimeDC.enabled = false;
        schestarttimeDC.value = null;
        scheendtimeDC.value = null;
      } else {
        schestarttimeDC.enabled = true;
        scheendtimeDC.enabled = true;
        if (_schestarttime.value != null) {
          schestarttimeDC.value = formatTime(_schestarttime.value!);
        }
        if (_scheendtime.value != null) {
          scheendtimeDC.value = formatTime(_scheendtime.value!);
        }
      }
    });
  }

  Map<String, dynamic> toJson() {
    return {
      "schenm": schenm,
      "schestartdate": formatDate(_schestartdate.value),
      "scheenddate": formatDate(_scheenddate.value),
      "schestarttime": _schestarttime.value != null ? formatTime(_schestarttime.value!) : null,
      "scheendtime": _scheendtime.value != null ? formatTime(_scheendtime.value!) : null,
      "scheloc": scheloc,
      "scheremind": scheremind,
      "schedescription": schedescription,
      "scheonline": scheonline,
      "scheonlink": scheonlink,
      "scheallday": scheallday,
      "schetype": schetype,
    };
  }
}

enum SchedulePermission {
  readOnly,
  shareLink,
  addMember,
}
