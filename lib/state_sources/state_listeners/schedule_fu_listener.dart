import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/state_controllers/schedule_fu_state_controller.dart';

class ScheduleFormUpdateListener {
  ScheduleFormUpdateListener(this.$);
  ScheduleFormUpdateStateController $;

  void onLocationChanged() {
    $.formSource.schelocquiet = $.formSource.schelocTEC.text;
  }

  void onOnlineLinkChanged() {
    $.formSource.scheonlinkquiet = $.formSource.scheonlinkTEC.text;
  }

  void onAlldayValueChanged(value) {
    if (value) {
      $.formSource.schestarttimeDC.enabled = false;
      $.formSource.scheendtimeDC.enabled = false;
      $.formSource.schestarttimeDC.value = null;
      $.formSource.scheendtimeDC.value = null;
    } else {
      $.formSource.schestarttimeDC.enabled = true;
      $.formSource.scheendtimeDC.enabled = true;
      if ($.formSource.schestarttime != null) {
        $.formSource.schestarttimeDC.value = formatTime($.formSource.schestarttime!);
      }
      if ($.formSource.scheendtime != null) {
        $.formSource.scheendtimeDC.value = formatTime($.formSource.scheendtime!);
      }
    }
    $.formSource.scheallday = value;
  }

  void onPrivateValueChanged(value) {
    $.formSource.scheprivate = value;
  }

  void onOnlineValueChanged(value) {
    $.formSource.scheonline = value;
    if (value) {
      $.formSource.scheonlinkTEC.text = $.formSource.scheonlink;
      $.formSource.schelocTEC.text = "";
    } else {
      $.formSource.scheonlinkTEC.text = "";
      $.formSource.schelocTEC.text = $.formSource.scheloc;
    }
  }

  void onDateStartSelected(DateTime? value) {
    if (value != null) {
      $.formSource.schestartdate = value;
      if ($.formSource.schestartdate.isAfter($.formSource.scheenddate)) {
        $.formSource.scheenddate = $.formSource.schestartdate;
      }
    }
  }

  void onDateEndSelected(DateTime? value) {
    if (value != null) {
      $.formSource.scheenddate = value;
    }
  }

  void onTimeStartSelected(String? value) {
    if (value != null) {
      DateTime time = parseTime(value);
      if ($.formSource.schestarttime != null) {
        DateTime _dateStart = $.formSource.schestarttime!.subtract(Duration(
          hours: $.formSource.schestarttime!.hour,
          minutes: $.formSource.schestarttime!.minute,
          seconds: $.formSource.schestarttime!.second,
        ));
        $.formSource.schestarttimequiet = _dateStart.add(Duration(
          hours: time.hour,
          minutes: time.minute,
          seconds: time.second,
        ));
      } else {
        $.formSource.schestarttimequiet = DateTime(
          $.formSource.schestartdate.year,
          $.formSource.schestartdate.month,
          $.formSource.schestartdate.day,
          time.hour,
          time.minute,
          time.second,
        );
      }
    }
    $.formSource.setEndTimeList();
  }

  void onTimeEndSelected(String? value) {
    if (value != null) {
      DateTime time = parseTime(value);
      if ($.formSource.scheendtime != null) {
        DateTime _dateEnd = $.formSource.scheendtime!.subtract(Duration(
          hours: $.formSource.scheendtime!.hour,
          minutes: $.formSource.scheendtime!.minute,
          seconds: $.formSource.scheendtime!.second,
        ));
        $.formSource.scheendtimequiet = _dateEnd.add(Duration(
          hours: time.hour,
          minutes: time.minute,
          seconds: time.second,
        ));
      } else {
        $.formSource.scheendtimequiet = DateTime(
          $.formSource.scheenddate.year,
          $.formSource.scheenddate.month,
          $.formSource.scheenddate.day,
          time.hour,
          time.minute,
          time.second,
        );
      }
    }
  }

  void onGuestChanged(UserDetail? user) {
    if (user != null) {
      $.formSource.addGuest(user);
    }
  }

  void onRemoveGuest(item) {
    if (item != null) {
      $.formSource.removeGuest(item);
    }
  }

  void onReadOnlyValueChanged(int userid, bool value) {
    if (value) {
      $.formSource.setPermission(userid, [$.formSource.readOnlyId]);
    } else {
      $.formSource.removePermission(userid, $.formSource.readOnlyId);
    }
  }

  void onShareLinkValueChanged(int userid, bool value) {
    if (value) {
      $.formSource.addPermission(userid, $.formSource.shareLinkId);
    } else {
      $.formSource.removePermission(userid, $.formSource.shareLinkId);
    }
  }

  void onAddMemberValueChanged(int userid, bool value) {
    if (value) {
      $.formSource.addPermission(userid, $.formSource.addMemberId);
    } else {
      $.formSource.removePermission(userid, $.formSource.addMemberId);
    }
  }

  void onGuestSelected(UserDetail user) {
    if ($.formSource.guests.where((item) => item.scheuserid == user.userid).isEmpty) {
      $.formSource.addGuest(user);
    } else {
      $.formSource.removeGuest(user);
    }
  }

  void onTowardSelected(UserDetail value) {
    if ($.formSource.schetoward?.userdtid != value.userdtid) {
      $.formSource.schetoward = value;
    } else {
      $.formSource.schetoward = $.formSource.userDefault;
    }
  }

  Future<List<UserDetail>> onGuestFilter(String? search) async {
    List<UserDetail> userDetails = await $.formSource.dataSource.filterUser(search);
    userDetails = userDetails.where((item) => item.userid != $.formSource.schetoward?.userid).toList();
    return userDetails;
  }

  Future<List<UserDetail>> onTowardFilter(String? search) async {
    List<UserDetail> userDetails = await $.formSource.dataSource.allUser(search);
    List<int?> guestIds = $.formSource.guests.map((item) => item.scheuserid).toList();
    userDetails = userDetails.where((item) => !guestIds.contains(item.userid)).toList();
    return userDetails;
  }

  void onFormSubmit() {
    if ($.formSource.isValid()) {
      Map<String, dynamic> data = $.formSource.toJson();
      Loader().show();
      $.dataSource.updateSchedule(data);
    }
  }
}
