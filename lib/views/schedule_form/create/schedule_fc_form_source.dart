// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ventes/constants/app.dart';
import 'package:ventes/constants/regular_size.dart';
import 'package:ventes/widgets/editor_input.dart';
import 'package:ventes/widgets/field_dropdown.dart';
import 'package:ventes/widgets/icon_input.dart';
import 'package:ventes/widgets/regular_checkbox.dart';
import 'package:ventes/widgets/regular_date_picker.dart';
import 'package:ventes/widgets/regular_dropdown.dart';
import 'package:ventes/widgets/regular_input.dart';
import 'package:ventes/widgets/regular_select_box.dart';

class ScheduleFormCreateSource {
  final _titleTEC = TextEditingController();
  final _dateStartTEC = TextEditingController();
  final _dateEndTEC = TextEditingController();
  final _timeStartSelectController = DropdownController<String?>(null);
  final _timeEndSelectController = DropdownController<String?>(null);
  final _locationTEC = TextEditingController();
  final _linkTEC = TextEditingController();
  final _remindTEC = TextEditingController();
  final _descriptionTEC = TextEditingController();

  final Rx<bool> _online = Rx<bool>(false);
  final _typeActive = ScheduleType.event.obs;

  String get title => _titleTEC.text;
  DateTime get dateStart => DateFormat(viewDateFormat).parse(
      _dateStartTEC.text + ' ' + (_timeStartSelectController.value ?? '00:00'));
  DateTime get dateEnd => DateFormat(viewDateFormat).parse(
      _dateEndTEC.text + ' ' + (_timeEndSelectController.value ?? '00:00'));
  bool allDay = false;
  String get location => _locationTEC.text;
  bool get online => _online.value;
  String get link => _linkTEC.text;
  int get remind => int.tryParse(_remindTEC.text) ?? 0;
  String get description => _descriptionTEC.text;
  ScheduleType get scheduleType => _typeActive.value;

  set scheduleType(ScheduleType value) => _typeActive.value = value;
  set online(bool value) => _online.value = value;
  set _dateStart(DateTime? value) {
    if (value != null) {
      _dateStartTEC.text = DateFormat(viewDateFormat).format(value);
      _timeStartSelectController.value =
          DateFormat(DateFormat.HOUR24_MINUTE_SECOND).format(value);
    }
  }

  set _dateEnd(DateTime? value) {
    if (value != null) {
      _dateEndTEC.text = DateFormat(viewDateFormat).format(value);
      _timeEndSelectController.items = _createItems(value.hour, value.minute);
      _timeEndSelectController.value =
          DateFormat(DateFormat.HOUR24_MINUTE_SECOND).format(value);
    }
  }

  set location(String value) => _locationTEC.text = value;

  dispose() {
    _dateStartTEC.dispose();
    _dateEndTEC.dispose();
    _locationTEC.dispose();
    _linkTEC.dispose();
    _remindTEC.dispose();
    _descriptionTEC.dispose();
  }

  ready() {
    _createStartTimeList();
  }

  List<Map<String, dynamic>> _createItems([int? minHour, int? minMinutes]) {
    List<Map<String, dynamic>> items = [];
    DateTime time = DateTime(0, 0, 0, minHour ?? 0, minMinutes ?? 0);
    int limit = DateTime(0, 0, 0, 23, 59).difference(time).inMinutes ~/ 15;
    String text = DateFormat(DateFormat.HOUR_MINUTE).format(time);
    String value = DateFormat(DateFormat.HOUR24_MINUTE_SECOND).format(time);
    items.add({
      "text": text,
      "value": value,
    });

    for (int i = 1; i <= limit; i++) {
      time = time.add(Duration(minutes: 15));
      String text = DateFormat(DateFormat.HOUR_MINUTE).format(time);
      String value = DateFormat(DateFormat.HOUR24_MINUTE_SECOND).format(time);
      items.add({
        "text": text,
        "value": value,
      });
    }
    return items;
  }

  void _createEndTimeList() {
    DateTime maxDate =
        DateTime(dateEnd.year, dateEnd.month, dateEnd.day, 23, 59);
    bool hasMoreTime = maxDate.difference(dateStart).inMinutes >= 15;
    if (hasMoreTime) {
      if (dateStart.difference(dateEnd).inSeconds >= 0) {
        _dateEnd = dateStart.add(Duration(
          hours: dateEnd.hour - dateStart.hour,
          minutes: (dateEnd.minute - dateStart.minute) + 15,
        ));
      }
    } else {
      DateTime _dateEnd = dateEnd
          .subtract(Duration(minutes: dateEnd.minute, hours: dateEnd.hour));
      _dateEnd = _dateEnd.add(Duration(days: 1, minutes: 15));
    }
  }

  void _createStartTimeList() {
    DateTime date = DateTime.now();
    _dateStart = DateTime(date.year, date.month, date.day, 0, 0);
    _dateEnd = DateTime(date.year, date.month, date.day, 0, 0);
    _createEndTimeList();
  }

  void _allDayToggle(value) {
    if (value) {
      _timeStartSelectController.enabled = false;
      _timeEndSelectController.enabled = false;
    } else {
      _timeStartSelectController.enabled = true;
      _timeEndSelectController.enabled = true;
    }
    allDay = value;
  }

  void onlineToggle(value) {
    online = value;
  }

  Widget get titleInput {
    return RegularInput(
      controller: _titleTEC,
      label: "Title",
      hintText: "Enter title",
    );
  }

  Widget get scheduleTypeSelectbox {
    return RegularSelectBox<ScheduleType>(
      label: "Type",
      onSelected: (value) {
        scheduleType = ScheduleType.values[value];
      },
      activeIndex: scheduleType.index,
      items: [
        ScheduleType.event,
        ScheduleType.task,
        ScheduleType.reminder,
      ],
    );
  }

  Widget get dateStartInput {
    return GestureDetector(
      onTap: () {
        RegularDatePicker(
          onSelected: (value) {
            if (value != null) {
              _dateStart = value.add(Duration(
                hours: value.hour - dateStart.hour,
                minutes: value.minute - dateStart.minute,
                seconds: value.second - dateStart.second,
              ));
            }
          },
          initialdate: dateStart,
        ).show();
      },
      child: IconInput(
        icon: "assets/svg/calendar.svg",
        label: "Date Start",
        enabled: false,
        controller: _dateStartTEC,
      ),
    );
  }

  Widget get dateEndInput {
    return GestureDetector(
      onTap: () {
        RegularDatePicker(
          onSelected: (value) {
            if (value != null) {
              _dateEnd = value.add(Duration(
                hours: value.hour - dateEnd.hour,
                minutes: value.minute - dateEnd.minute,
                seconds: value.second - dateEnd.second,
              ));
            }
          },
          initialdate: dateEnd,
        ).show();
      },
      child: IconInput(
        icon: "assets/svg/calendar.svg",
        label: "Date End",
        enabled: false,
        controller: _dateEndTEC,
      ),
    );
  }

  Widget get twinTimeInput {
    return Row(
      children: [
        Expanded(
          child: RegularDropdown<String?>(
            label: "Time Start",
            controller: _timeStartSelectController,
            icon: "assets/svg/history.svg",
            onSelected: (value) {
              if (value != null) {
                DateTime time = DateFormat("HH:mm:ss").parse(value);
                _dateStart = dateStart.add(Duration(
                  hours: time.hour - dateStart.hour,
                  minutes: time.minute - dateStart.minute,
                  seconds: time.second - dateStart.second,
                ));
              }
              _createEndTimeList();
            },
          ),
        ),
        SizedBox(
          width: RegularSize.s,
        ),
        Expanded(
          child: RegularDropdown<String?>(
            label: "Time End",
            icon: "assets/svg/history.svg",
            controller: _timeEndSelectController,
            onSelected: (value) {
              // parse value to DateTime
              if (value != null) {
                DateTime time = DateFormat("HH:mm:ss").parse(value);
                _dateEnd = dateEnd.add(Duration(
                  hours: time.hour - dateEnd.hour,
                  minutes: time.minute - dateEnd.minute,
                  seconds: time.second - dateEnd.second,
                ));
              }
            },
          ),
        ),
      ],
    );
  }

  Widget get allDayCheckbox {
    return RegularCheckbox(
      label: "All Day",
      onChecked: _allDayToggle,
    );
  }

  Widget get locationInput {
    return IconInput(
      icon: "assets/svg/marker.svg",
      label: "Location",
      hintText: "Choose location",
      controller: _locationTEC,
      enabled: false,
    );
  }

  Widget get onlineCheckbox {
    return RegularCheckbox(
      label: "Online",
      onChecked: onlineToggle,
    );
  }

  Widget get linkInput {
    return IconInput(
      icon: "assets/svg/share.svg",
      label: "Meeting Link",
      hintText: "Enter meeting link",
      controller: _linkTEC,
      enabled: online,
    );
  }

  Widget get remindInput {
    return IconInput(
      icon: "assets/svg/alarm.svg",
      label: "Remind (In Minute)",
      hintText: "try 5",
      controller: _remindTEC,
      inputType: TextInputType.number,
    );
  }

  Widget get descriptionInput {
    return EditorInput(
      label: "Description",
      hintText: "Write about this event",
      controller: _descriptionTEC,
    );
  }

  Widget get guestDropdown {
    return FieldDropdown<String>(
      label: "Guest",
      hintText: "Invite guest",
      items: [
        "Marc Spector",
        "Steven Grant",
        "Arthur Harrow",
        "Jack Lockly",
        "Layla El Faoula",
        "Date Whiteman",
      ],
    );
  }
}

enum ScheduleType { event, task, reminder }
