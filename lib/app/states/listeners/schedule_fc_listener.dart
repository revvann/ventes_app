import 'dart:async';

import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_guest_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/states/typedefs/schedule_fc_typedef.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';

class ScheduleFormCreateListener extends StateListener with ListenerMixin {
  void onLocationChanged() {
    formSource.schelocquiet = formSource.schelocTEC.text;
  }

  void onOnlineLinkChanged() {
    formSource.scheonlinkquiet = formSource.scheonlinkTEC.text;
  }

  void onAlldayValueChanged(value) {
    if (value) {
      formSource.schestarttimeDC.enabled = false;
      formSource.scheendtimeDC.enabled = false;
      formSource.schestarttimeDC.value = null;
      formSource.scheendtimeDC.value = null;
    } else {
      formSource.schestarttimeDC.enabled = true;
      formSource.scheendtimeDC.enabled = true;
      if (formSource.schestarttime != null) {
        formSource.schestarttimeDC.value = formatTime(formSource.schestarttime!);
      }
      if (formSource.scheendtime != null) {
        formSource.scheendtimeDC.value = formatTime(formSource.scheendtime!);
      }
    }
    formSource.scheallday = value;
  }

  void onPrivateValueChanged(value) {
    formSource.scheprivate = value;
  }

  void onOnlineValueChanged(value) {
    formSource.scheonline = value;
    if (value) {
      formSource.scheonlinkTEC.text = formSource.scheonlink;
      formSource.schelocTEC.text = "";
    } else {
      formSource.scheonlinkTEC.text = "";
      formSource.schelocTEC.text = formSource.scheloc;
    }
  }

  void onDateStartSelected(DateTime? value) {
    if (value != null) {
      formSource.schestartdate = value;
      if (formSource.schestartdate.isAfter(formSource.scheenddate)) {
        formSource.scheenddate = formSource.schestartdate;
      }
    }
  }

  void onDateEndSelected(DateTime? value) {
    if (value != null) {
      formSource.scheenddate = value;
    }
  }

  void onTimeStartSelected(String? value) {
    if (value != null) {
      DateTime time = parseTime(value);
      if (formSource.schestarttime != null) {
        DateTime _dateStart = formSource.schestarttime!.subtract(Duration(
          hours: formSource.schestarttime!.hour,
          minutes: formSource.schestarttime!.minute,
          seconds: formSource.schestarttime!.second,
        ));
        formSource.schestarttimequiet = _dateStart.add(Duration(
          hours: time.hour,
          minutes: time.minute,
          seconds: time.second,
        ));
      } else {
        formSource.schestarttimequiet = DateTime(
          formSource.schestartdate.year,
          formSource.schestartdate.month,
          formSource.schestartdate.day,
          time.hour,
          time.minute,
          time.second,
        );
      }
    }
    formSource.setEndTimeList();
  }

  void onTimeEndSelected(String? value) {
    if (value != null) {
      DateTime time = parseTime(value);
      if (formSource.scheendtime != null) {
        DateTime _dateEnd = formSource.scheendtime!.subtract(Duration(
          hours: formSource.scheendtime!.hour,
          minutes: formSource.scheendtime!.minute,
          seconds: formSource.scheendtime!.second,
        ));
        formSource.scheendtimequiet = _dateEnd.add(Duration(
          hours: time.hour,
          minutes: time.minute,
          seconds: time.second,
        ));
      } else {
        formSource.scheendtimequiet = DateTime(
          formSource.scheenddate.year,
          formSource.scheenddate.month,
          formSource.scheenddate.day,
          time.hour,
          time.minute,
          time.second,
        );
      }
    }
  }

  void onTimezoneChanged(selectedItem) {
    formSource.schetz = selectedItem.key;
  }

  bool onGuestCompared(dynamic a, UserDetail b) {
    return a?.any((element) => element?.userid == b.userid) ?? false;
  }

  bool onTowardCompared(dynamic a, UserDetail? b) {
    return a.userdtid == b?.userdtid;
  }

  void onGuestChanged(dynamic user) {
    formSource.guests = List<ScheduleGuest>.from(
      formSource.guestDropdownController.selectedKeys.map(
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
      formSource.removeGuest(item);
    }
  }

  void onReadOnlyValueChanged(int userid, bool value) {
    if (value) {
      formSource.setPermission(userid, [formSource.readOnlyId]);
    } else {
      formSource.removePermission(userid, formSource.readOnlyId);
    }
  }

  void onShareLinkValueChanged(int userid, bool value) {
    if (value) {
      formSource.addPermission(userid, formSource.shareLinkId);
    } else {
      formSource.removePermission(userid, formSource.shareLinkId);
    }
  }

  void onAddMemberValueChanged(int userid, bool value) {
    if (value) {
      formSource.addPermission(userid, formSource.addMemberId);
    } else {
      formSource.removePermission(userid, formSource.addMemberId);
    }
  }

  void onTowardSelected(dynamic selectedItem) {
    formSource.schetoward = selectedItem?.value;
  }

  Future<List<UserDetail>> onGuestFilter(String? search) async {
    List<UserDetail> userDetails = await dataSource.filterUser(search);
    userDetails = userDetails.where((item) => item.userid != formSource.schetoward?.userid).toList();
    return userDetails;
  }

  Future<List<UserDetail>> onTowardFilter(String? search) async {
    List<UserDetail> userDetails = await dataSource.allUser(search);
    List<int?> guestIds = formSource.guests.map((item) => item.scheuserid).toList();
    userDetails = userDetails.where((item) => !guestIds.contains(item.userid)).toList();
    return userDetails;
  }

  void onFormSubmit() {
    Get.find<TaskHelper>().confirmPush(
      property.task.copyWith<bool>(
        message: ScheduleString.createScheduleConfirm,
        onFinished: (res) {
          if (res) {
            formSource.onSubmit();
          }
        },
      ),
    );
  }

  void onCameraMove(position) {
    property.markerLatLng = position.target;
    formSource.scheloc = "https://maps.google.com?q=${position.target.latitude},${position.target.longitude}";
  }

  @override
  Future onReady() async {
    property.refresh();
  }
}
