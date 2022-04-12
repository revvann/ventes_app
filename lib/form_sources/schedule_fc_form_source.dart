// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ventes/constants/app.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/models/user_detail_model.dart';
import 'package:ventes/state_controllers/schedule_fc_state_controller.dart';

class ScheduleFormCreateSource {
  late ScheduleFormCreateStateController $;

  int readOnlyId = 14;
  int addMemberId = 15;
  int shareLinkId = 16;

  int eventId = 11;
  int taskId = 10;
  int reminderId = 12;

  final Rx<List<UserDetail>> _guestsSelected = Rx<List<UserDetail>>([]);
  final Rx<bool> rxonline = Rx<bool>(false);
  final _typeActive = 11.obs;
  final Rx<List<int>> _guestPermission = Rx<List<int>>([]);

  String get title => $.titleTEC.text;
  DateTime get dateStart => parseDateTime($.dateStartTEC.text + ' ' + ($.timeStartSelectController.value ?? '00:00'));
  DateTime get dateEnd => parseDateTime($.dateEndTEC.text + ' ' + ($.timeEndSelectController.value ?? '00:00'));
  bool allDay = false;
  String get location => $.locationTEC.text;
  bool get online => rxonline.value;
  String get link => $.linkTEC.text;
  int get remind => int.tryParse($.remindTEC.text) ?? 0;
  String get description => $.descriptionTEC.text;
  int get scheduleType => _typeActive.value;
  List<UserDetail> get guestsSelected => _guestsSelected.value;
  List<int> get guestPermission => _guestPermission.value;

  set guestPermission(List<int> value) => _guestPermission.value = value;
  set addGuestPermission(int value) => _guestPermission.update((val) => val!..add(value));
  set removeGuestPermission(int value) => _guestPermission.update((val) => val!..remove(value));
  set guestsSelected(List<UserDetail> value) => _guestsSelected.value = value;
  set addGuestsSelected(UserDetail value) => _guestsSelected.update((val) => val!..add(value));
  set removeGuestsSelected(UserDetail value) => _guestsSelected.update((val) => val!..remove(value));
  set stateController(ScheduleFormCreateStateController controller) => $ = controller;
  set scheduleType(int value) => _typeActive.value = value;
  set _online(bool value) => rxonline.value = value;
  set _dateStart(DateTime? value) {
    if (value != null) {
      $.dateStartTEC.text = DateFormat(viewDateFormat).format(value);
      $.timeStartSelectController.items = createTimeList();
      $.timeStartSelectController.value = formatTime(value);
    }
  }

  set _dateEnd(DateTime? value) {
    if (value != null) {
      $.dateEndTEC.text = DateFormat(viewDateFormat).format(value);
      $.timeEndSelectController.items = createTimeList(value.hour, value.minute);
      $.timeEndSelectController.value = formatTime(value);
    }
  }

  set location(String value) => $.locationTEC.text = value;

  void _createEndTimeList() {
    DateTime maxDate = DateTime(dateEnd.year, dateEnd.month, dateEnd.day, 23, 59);
    bool hasMoreTime = maxDate.difference(dateStart).inMinutes >= 15;
    if (hasMoreTime) {
      if (dateStart.difference(dateEnd).inSeconds >= 0) {
        DateTime _dateEnd = dateEnd.subtract(Duration(
          hours: dateEnd.hour,
          minutes: dateEnd.minute,
        ));
        this._dateEnd = _dateEnd.add(Duration(
          hours: dateStart.hour,
          minutes: dateStart.minute + 15,
        ));
      }
    } else {
      DateTime dateEnd = this.dateEnd.subtract(Duration(minutes: this.dateEnd.minute, hours: this.dateEnd.hour));
      _dateEnd = dateEnd.add(Duration(days: 1, minutes: 15));
    }
  }

  void createStartTimeList() {
    DateTime date = DateTime.now();
    _dateStart = DateTime(date.year, date.month, date.day, 0, 0);
    _dateEnd = DateTime(date.year, date.month, date.day, 0, 0);
    _createEndTimeList();
  }

  void allDayToggle(value) {
    if (value) {
      $.timeStartSelectController.enabled = false;
      $.timeEndSelectController.enabled = false;
    } else {
      $.timeStartSelectController.enabled = true;
      $.timeEndSelectController.enabled = true;
    }
    allDay = value;
  }

  void onlineToggle(value) {
    _online = value;
  }

  void onDateStartSelected(DateTime? value) {
    if (value != null) {
      _dateStart = value.add(Duration(
        hours: value.hour - dateStart.hour,
        minutes: value.minute - dateStart.minute,
        seconds: value.second - dateStart.second,
      ));
    }
  }

  void onDateEndSelected(DateTime? value) {
    if (value != null) {
      _dateEnd = value.add(Duration(
        hours: value.hour - dateEnd.hour,
        minutes: value.minute - dateEnd.minute,
        seconds: value.second - dateEnd.second,
      ));
    }
  }

  void onTimeStartSelected(String? value) {
    if (value != null) {
      DateTime time = DateFormat("HH:mm:ss").parse(value);
      DateTime _dateStart = dateStart.subtract(Duration(
        hours: dateStart.hour,
        minutes: dateStart.minute,
        seconds: dateStart.second,
      ));
      this._dateStart = _dateStart.add(Duration(
        hours: time.hour,
        minutes: time.minute,
        seconds: time.second,
      ));
    }
    _createEndTimeList();
  }

  void onTimeEndSelected(String? value) {
    if (value != null) {
      DateTime time = DateFormat("HH:mm:ss").parse(value);
      _dateEnd = dateEnd.add(Duration(
        hours: time.hour - dateEnd.hour,
        minutes: time.minute - dateEnd.minute,
        seconds: time.second - dateEnd.second,
      ));
    }
  }

  void onGuestChanged(UserDetail? user) {
    if (user != null) {
      // $.dropdownKey.currentState?.changeSelectedItem(user);
      addGuestsSelected = user;
      $.presenter.fetchUser();
    }
  }

  void onRemoveGuest(item) {
    removeGuestsSelected = item;
    $.presenter.fetchUser();
  }

  void readOnlyToggle(bool value) {
    if (value) {
      guestPermission = [readOnlyId];
    } else {
      removeGuestPermission = readOnlyId;
    }
  }

  void shareLinkToggle(bool value) {
    if (value) {
      addGuestPermission = shareLinkId;
    } else {
      removeGuestPermission = shareLinkId;
    }
  }

  void addMemberToggle(bool value) {
    if (value) {
      addGuestPermission = addMemberId;
    } else {
      removeGuestPermission = addMemberId;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "schenm": title,
      "schetypeid": scheduleType,
      "schestartdate": dbDateFormat(dateStart),
      "scheenddate": dbDateFormat(dateEnd),
      "schestarttime": allDay ? null : formatTime(dateStart),
      "scheendtime": allDay ? null : formatTime(dateEnd),
      "schedesc": description,
      "scheloc": online ? null : location,
      "scheonline": online,
      "scheonlink": online ? link : null,
      "scheallday": allDay,
      "scheremind": remind == 0 ? null : remind,
    };
  }
}
