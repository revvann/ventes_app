// ignore_for_file: unnecessary_getters_setters, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_guest_model.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/resources/widgets/regular_dropdown.dart';
import 'package:ventes/app/resources/widgets/searchable_dropdown.dart';
import 'package:ventes/app/states/typedefs/schedule_fu_typedef.dart';
import 'package:ventes/core/states/update_form_source.dart';
import 'package:ventes/helpers/function_helpers.dart';

class ScheduleFormUpdateFormSource extends UpdateFormSource with FormSourceMixin {
  Validator validator = Validator();

  int readOnlyId = 14;
  int addMemberId = 15;
  int shareLinkId = 16;

  UserDetail? userDefault;
  final Rx<List<KeyableDropdownItem<String, String>>> _timezones = Rx<List<KeyableDropdownItem<String, String>>>([]);

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
  SearchableDropdownController<UserDetail> guestDropdownController = Get.put(SearchableDropdownController<UserDetail>(), tag: "DropdownGuest");
  SearchableDropdownController<UserDetail> towardDropdownController = Get.put(SearchableDropdownController<UserDetail>(), tag: "DropdownToward");
  KeyableDropdownController<String, String> timezoneDropdownController = Get.put(KeyableDropdownController<String, String>(), tag: "DropdownTimezone");

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
  final Rx<String?> _schetz = Rx<String?>(null);

  bool get isEvent => dataSource.typeName(schetype) == "Event";
  bool get isTask => dataSource.typeName(schetype) == "Task";
  bool get isReminder => dataSource.typeName(schetype) == "Reminder";

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

  String? get schetz => _schetz.value;
  set schetz(String? value) {
    _schetz.value = value;
  }

  List<KeyableDropdownItem<String, String>> get timezones => _timezones.value;
  set timezones(List<KeyableDropdownItem<String, String>> value) {
    _timezones.value = value;
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
    guestDropdownController.selectedKeys = guestDropdownController.selectedKeys.where((g) => g.userid != userid).toList();
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

  @override
  void prepareFormValues() {
    if (dataSource.schedule != null) {
      Schedule schedule = dataSource.schedule!;
      scheid = schedule.scheid ?? -1;
      schenm = schedule.schenm ?? "";
      schetype = dataSource.typeIndex(schedule.schetypeid ?? 0);
      dataSource.types;
      schestartdate = dbParseDate(schedule.schestartdate!);
      scheenddate = dbParseDate(schedule.scheenddate ?? schedule.schestartdate!);
      schestarttime = !(schedule.scheallday ?? false) ? parseTime(schedule.schestarttime!) : null;
      scheendtime = !(schedule.scheallday ?? false) ? parseTime(schedule.scheendtime ?? schedule.schestarttime!) : null;
      schetz = schedule.schetz;
      timezoneDropdownController.selectedKeys = schetz != null ? [schetz!] : [];

      scheallday = schedule.scheallday ?? false;
      listener.onAlldayValueChanged(scheallday);

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
      guestDropdownController.selectedKeys = guests
          .map<UserDetail>((element) => UserDetail(
                user: element.scheuser,
                userid: element.scheuserid,
                userdtbpid: element.schebpid,
                businesspartner: element.businesspartner,
              ))
          .toList();
    }
  }

  @override
  close() {
    super.close();
    schenmTEC.dispose();
    schestartdateTEC.dispose();
    scheenddateTEC.dispose();
    schelocTEC.dispose();
    scheremindTEC.dispose();
    schedescTEC.dispose();
    scheonlinkTEC.dispose();
    Get.delete<SearchableDropdown<UserDetail>>(tag: "DropdownGuest");
    Get.delete<SearchableDropdown<UserDetail>>(tag: "DropdownToward");
    Get.delete<KeyableDropdownController<String, String>>(tag: "DropdownTimezone");
  }

  @override
  init() async {
    super.init();
    validator.formSource = this;
  }

  @override
  ready() async {
    super.ready();
    setStartTimeList();

    scheremindTEC.text = "0";
    scheonlinkTEC.addListener(listener.onOnlineLinkChanged);
    schelocTEC.addListener(listener.onLocationChanged);

    userDefault = await dataSource.userActive;
    towardDropdownController.selectedKeys = userDefault != null ? [userDefault!] : [];
    schetoward = userDefault;

    timezones = getTimezoneList().map<KeyableDropdownItem<String, String>>((e) => KeyableDropdownItem<String, String>(key: e['value']!, value: e['text']!)).toList();
  }

  @override
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
      "schetypeid": dataSource.typeId(schetype),
      "schetz": schetz,
      "scheprivate": isEvent ? scheprivate : false,
      "schetowardid": isEvent ? schetoward?.userid : userDefault?.userid,
      "schebpid": isEvent ? schebpid : userDefault?.userdtbpid,
      "members": isEvent ? jsonEncode(guests.map((g) => g.toJson()).toList()) : null,
    };
  }

  @override
  void onSubmit() {
    if (isValid()) {
      Map<String, dynamic> data = toJson();
      dataSource.updateHandler.fetcher.run(data);
    }
  }
}

enum SchedulePermission {
  readOnly,
  shareLink,
  addMember,
}
