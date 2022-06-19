import 'dart:async';

import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_guest_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/states/controllers/daily_schedule_state_controller.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/app/states/typedefs/schedule_fc_typedef.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';

class ScheduleFormCreateListener extends StateListener {
  Property get _property => Get.find<Property>(tag: ScheduleString.scheduleCreateTag);
  FormSource get _formSource => Get.find<FormSource>(tag: ScheduleString.scheduleCreateTag);
  DataSource get _dataSource => Get.find<DataSource>(tag: ScheduleString.scheduleCreateTag);

  void onLocationChanged() {
    _formSource.schelocquiet = _formSource.schelocTEC.text;
  }

  void onOnlineLinkChanged() {
    _formSource.scheonlinkquiet = _formSource.scheonlinkTEC.text;
  }

  void onAlldayValueChanged(value) {
    if (value) {
      _formSource.schestarttimeDC.enabled = false;
      _formSource.scheendtimeDC.enabled = false;
      _formSource.schestarttimeDC.value = null;
      _formSource.scheendtimeDC.value = null;
    } else {
      _formSource.schestarttimeDC.enabled = true;
      _formSource.scheendtimeDC.enabled = true;
      if (_formSource.schestarttime != null) {
        _formSource.schestarttimeDC.value = formatTime(_formSource.schestarttime!);
      }
      if (_formSource.scheendtime != null) {
        _formSource.scheendtimeDC.value = formatTime(_formSource.scheendtime!);
      }
    }
    _formSource.scheallday = value;
  }

  void onPrivateValueChanged(value) {
    _formSource.scheprivate = value;
  }

  void onOnlineValueChanged(value) {
    _formSource.scheonline = value;
    if (value) {
      _formSource.scheonlinkTEC.text = _formSource.scheonlink;
      _formSource.schelocTEC.text = "";
    } else {
      _formSource.scheonlinkTEC.text = "";
      _formSource.schelocTEC.text = _formSource.scheloc;
    }
  }

  void onDateStartSelected(DateTime? value) {
    if (value != null) {
      _formSource.schestartdate = value;
      if (_formSource.schestartdate.isAfter(_formSource.scheenddate)) {
        _formSource.scheenddate = _formSource.schestartdate;
      }
    }
  }

  void onDateEndSelected(DateTime? value) {
    if (value != null) {
      _formSource.scheenddate = value;
    }
  }

  void onTimeStartSelected(String? value) {
    if (value != null) {
      DateTime time = parseTime(value);
      if (_formSource.schestarttime != null) {
        DateTime _dateStart = _formSource.schestarttime!.subtract(Duration(
          hours: _formSource.schestarttime!.hour,
          minutes: _formSource.schestarttime!.minute,
          seconds: _formSource.schestarttime!.second,
        ));
        _formSource.schestarttimequiet = _dateStart.add(Duration(
          hours: time.hour,
          minutes: time.minute,
          seconds: time.second,
        ));
      } else {
        _formSource.schestarttimequiet = DateTime(
          _formSource.schestartdate.year,
          _formSource.schestartdate.month,
          _formSource.schestartdate.day,
          time.hour,
          time.minute,
          time.second,
        );
      }
    }
    _formSource.setEndTimeList();
  }

  void onTimeEndSelected(String? value) {
    if (value != null) {
      DateTime time = parseTime(value);
      if (_formSource.scheendtime != null) {
        DateTime _dateEnd = _formSource.scheendtime!.subtract(Duration(
          hours: _formSource.scheendtime!.hour,
          minutes: _formSource.scheendtime!.minute,
          seconds: _formSource.scheendtime!.second,
        ));
        _formSource.scheendtimequiet = _dateEnd.add(Duration(
          hours: time.hour,
          minutes: time.minute,
          seconds: time.second,
        ));
      } else {
        _formSource.scheendtimequiet = DateTime(
          _formSource.scheenddate.year,
          _formSource.scheenddate.month,
          _formSource.scheenddate.day,
          time.hour,
          time.minute,
          time.second,
        );
      }
    }
  }

  void onTimezoneChanged(selectedItem) {
    _formSource.schetz = selectedItem.key;
  }

  bool onGuestCompared(dynamic a, UserDetail b) {
    return a?.any((element) => element?.userid == b.userid) ?? false;
  }

  bool onTowardCompared(dynamic a, UserDetail? b) {
    return a.userdtid == b?.userdtid;
  }

  void onGuestChanged(dynamic user) {
    _formSource.guests = List<ScheduleGuest>.from(
      _formSource.guestDropdownController.selectedKeys.map(
        (user) => ScheduleGuest(
          scheuserid: user.userid,
          schebpid: user.userdtbpid,
          scheuser: user.user,
          businesspartner: user.businesspartner,
        ),
      ),
    );
  }

  void onRemoveGuest(item) {
    if (item != null) {
      _formSource.removeGuest(item);
    }
  }

  void onReadOnlyValueChanged(int userid, bool value) {
    if (value) {
      _formSource.setPermission(userid, [_formSource.readOnlyId]);
    } else {
      _formSource.removePermission(userid, _formSource.readOnlyId);
    }
  }

  void onShareLinkValueChanged(int userid, bool value) {
    if (value) {
      _formSource.addPermission(userid, _formSource.shareLinkId);
    } else {
      _formSource.removePermission(userid, _formSource.shareLinkId);
    }
  }

  void onAddMemberValueChanged(int userid, bool value) {
    if (value) {
      _formSource.addPermission(userid, _formSource.addMemberId);
    } else {
      _formSource.removePermission(userid, _formSource.addMemberId);
    }
  }

  void onTowardSelected(dynamic selectedItem) {
    _formSource.schetoward = selectedItem?.value;
  }

  Future<List<UserDetail>> onGuestFilter(String? search) async {
    List<UserDetail> userDetails = await _dataSource.filterUser(search);
    userDetails = userDetails.where((item) => item.userid != _formSource.schetoward?.userid).toList();
    return userDetails;
  }

  Future<List<UserDetail>> onTowardFilter(String? search) async {
    List<UserDetail> userDetails = await _dataSource.allUser(search);
    List<int?> guestIds = _formSource.guests.map((item) => item.scheuserid).toList();
    userDetails = userDetails.where((item) => !guestIds.contains(item.userid)).toList();
    return userDetails;
  }

  void onFormSubmit() {
    Get.find<TaskHelper>().confirmPush(
      _property.task.copyWith<bool>(
        message: ScheduleString.createScheduleConfirm,
        onFinished: (res) {
          if (res) {
            _formSource.onSubmit();
          }
        },
      ),
    );
  }

  void onCameraMove(position) {
    _property.markerLatLng = position.target;
    _formSource.scheloc = "https://maps.google.com?q=${position.target.latitude},${position.target.longitude}";
  }

  void onCreateDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: ScheduleString.createFailed));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onCreateDataSuccess(String message) {
    Get.find<TaskHelper>().successPush(_property.task.copyWith(
        message: ScheduleString.createSuccess,
        onFinished: (res) async {
          await _property.scheduleNotification();
          Get.find<DailyScheduleStateController>().property.refresh();
          Get.back(id: ScheduleNavigator.id);
        }));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  void onCreateDataError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: ScheduleString.createError));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  onLoadDataError(String message) {
    Get.find<TaskHelper>().errorPush(_property.task.copyWith(message: ScheduleString.createError));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  onLoadDataFailed(String message) {
    Get.find<TaskHelper>().failedPush(_property.task.copyWith(message: ScheduleString.createFailed));
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  @override
  Future onReady() async {
    _property.refresh();
  }
}
