import 'package:get/get.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/state/controllers/schedule_fu_state_controller.dart';

mixin ScheduleFormUpdateListener {
  ScheduleFormUpdateStateController get _$ => Get.find<ScheduleFormUpdateStateController>();

  void onLocationChanged() {
    _$.schelocquiet = _$.schelocTEC.text;
  }

  void onOnlineLinkChanged() {
    _$.scheonlinkquiet = _$.scheonlinkTEC.text;
  }

  void onAlldayValueChanged(value) {
    if (value) {
      _$.schestarttimeDC.enabled = false;
      _$.scheendtimeDC.enabled = false;
      _$.schestarttimeDC.value = null;
      _$.scheendtimeDC.value = null;
    } else {
      _$.schestarttimeDC.enabled = true;
      _$.scheendtimeDC.enabled = true;
      if (_$.schestarttime != null) {
        _$.schestarttimeDC.value = formatTime(_$.schestarttime!);
      }
      if (_$.scheendtime != null) {
        _$.scheendtimeDC.value = formatTime(_$.scheendtime!);
      }
    }
    _$.scheallday = value;
  }

  void onPrivateValueChanged(value) {
    _$.scheprivate = value;
  }

  void onOnlineValueChanged(value) {
    _$.scheonline = value;
    if (value) {
      _$.scheonlinkTEC.text = _$.scheonlink;
      _$.schelocTEC.text = "";
    } else {
      _$.scheonlinkTEC.text = "";
      _$.schelocTEC.text = _$.scheloc;
    }
  }

  void onDateStartSelected(DateTime? value) {
    if (value != null) {
      _$.schestartdate = value;
      if (_$.schestartdate.isAfter(_$.scheenddate)) {
        _$.scheenddate = _$.schestartdate;
      }
    }
  }

  void onDateEndSelected(DateTime? value) {
    if (value != null) {
      _$.scheenddate = value;
    }
  }

  void onTimeStartSelected(String? value) {
    if (value != null) {
      DateTime time = parseTime(value);
      if (_$.schestarttime != null) {
        DateTime _dateStart = _$.schestarttime!.subtract(Duration(
          hours: _$.schestarttime!.hour,
          minutes: _$.schestarttime!.minute,
          seconds: _$.schestarttime!.second,
        ));
        _$.schestarttimequiet = _dateStart.add(Duration(
          hours: time.hour,
          minutes: time.minute,
          seconds: time.second,
        ));
      } else {
        _$.schestarttimequiet = DateTime(
          _$.schestartdate.year,
          _$.schestartdate.month,
          _$.schestartdate.day,
          time.hour,
          time.minute,
          time.second,
        );
      }
    }
    _$.setEndTimeList();
  }

  void onTimeEndSelected(String? value) {
    if (value != null) {
      DateTime time = parseTime(value);
      if (_$.scheendtime != null) {
        DateTime _dateEnd = _$.scheendtime!.subtract(Duration(
          hours: _$.scheendtime!.hour,
          minutes: _$.scheendtime!.minute,
          seconds: _$.scheendtime!.second,
        ));
        _$.scheendtimequiet = _dateEnd.add(Duration(
          hours: time.hour,
          minutes: time.minute,
          seconds: time.second,
        ));
      } else {
        _$.scheendtimequiet = DateTime(
          _$.scheenddate.year,
          _$.scheenddate.month,
          _$.scheenddate.day,
          time.hour,
          time.minute,
          time.second,
        );
      }
    }
  }

  void onGuestChanged(UserDetail? user) {
    if (user != null) {
      _$.addGuest(user);
    }
  }

  void onRemoveGuest(item) {
    if (item != null) {
      _$.removeGuest(item);
    }
  }

  void onReadOnlyValueChanged(int userid, bool value) {
    if (value) {
      _$.setPermission(userid, [_$.readOnlyId]);
    } else {
      _$.removePermission(userid, _$.readOnlyId);
    }
  }

  void onShareLinkValueChanged(int userid, bool value) {
    if (value) {
      _$.addPermission(userid, _$.shareLinkId);
    } else {
      _$.removePermission(userid, _$.shareLinkId);
    }
  }

  void onAddMemberValueChanged(int userid, bool value) {
    if (value) {
      _$.addPermission(userid, _$.addMemberId);
    } else {
      _$.removePermission(userid, _$.addMemberId);
    }
  }

  void onGuestSelected(UserDetail user) {
    if (_$.guests.where((item) => item.scheuserid == user.userid).isEmpty) {
      _$.addGuest(user);
    } else {
      _$.removeGuest(user);
    }
  }

  void onTowardSelected(UserDetail value) {
    if (_$.schetoward?.userdtid != value.userdtid) {
      _$.schetoward = value;
    } else {
      _$.schetoward = _$.userDefault;
    }
  }

  Future<List<UserDetail>> onGuestFilter(String? search) async {
    List<UserDetail> userDetails = await _$.dataSource.filterUser(search);
    userDetails = userDetails.where((item) => item.userid != _$.schetoward?.userid).toList();
    return userDetails;
  }

  Future<List<UserDetail>> onTowardFilter(String? search) async {
    List<UserDetail> userDetails = await _$.dataSource.allUser(search);
    List<int?> guestIds = _$.guests.map((item) => item.scheuserid).toList();
    userDetails = userDetails.where((item) => !guestIds.contains(item.userid)).toList();
    return userDetails;
  }

  void onFormSubmit() {
    if (_$.isValid()) {
      Map<String, dynamic> data = _$.toJson();
      Loader().show();
      _$.dataSource.updateSchedule(data);
    }
  }
}
