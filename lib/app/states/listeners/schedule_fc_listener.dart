import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_guest_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/resources/widgets/error_alert.dart';
import 'package:ventes/app/resources/widgets/failed_alert.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/app/resources/widgets/success_alert.dart';
import 'package:ventes/app/states/controllers/daily_schedule_state_controller.dart';
import 'package:ventes/app/states/data_sources/schedule_fc_data_source.dart';
import 'package:ventes/constants/strings/schedule_string.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/app/states/controllers/schedule_fc_state_controller.dart';
import 'package:ventes/app/states/form_sources/schedule_fc_form_source.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/schedule_navigator.dart';

class ScheduleFormCreateListener {
  ScheduleFormCreateProperties get _properties => Get.find<ScheduleFormCreateProperties>();
  ScheduleFormCreateFormSource get _formSource => Get.find<ScheduleFormCreateFormSource>();
  ScheduleFormCreateDataSource get _dataSource => Get.find<ScheduleFormCreateDataSource>();

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

  bool onGuestCompared(UserDetail a, List<UserDetail?>? b) {
    return b?.any((element) => element?.userid == a.userid) ?? false;
  }

  bool onTowardCompared(UserDetail a, UserDetail? b) {
    return a.userid == b?.userid;
  }

  void onGuestChanged(List<UserDetail?>? user) {
    _formSource.guests = List<ScheduleGuest>.from(
      user!.map(
        (UserDetail? user) => ScheduleGuest(
          scheuserid: user?.userid,
          schebpid: user?.userdtbpid,
          scheuser: user?.user,
          businesspartner: user?.businesspartner,
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

  void onTowardSelected(UserDetail? value) {
    if (value != null) {
      _formSource.schetoward = value;
    } else {
      _formSource.schetoward = _formSource.userDefault;
    }
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
    if (_formSource.isValid()) {
      Map<String, dynamic> data = _formSource.toJson();
      Get.find<TaskHelper>().add(ScheduleString.createScheduleTaskCode);
      _dataSource.createSchedule(data);
    }
  }

  void onCameraMove(position) {
    _properties.markerLatLng = position.target;
    _formSource.scheloc = "https://maps.google.com?q=${position.target.latitude},${position.target.longitude}";
  }

  void onCreateDataFailed(String message) {
    Get.find<TaskHelper>().remove(ScheduleString.createScheduleTaskCode);
    FailedAlert(ScheduleString.createFailed).show();
  }

  void onCreateDataSuccess(String message) {
    Get.find<TaskHelper>().remove(ScheduleString.createScheduleTaskCode);
    SuccessAlert(ScheduleString.createSuccess).show().then((value) {
      Get.find<DailyScheduleStateController>().properties.refetch();
      Get.back(id: ScheduleNavigator.id);
    });
  }

  void onCreateDataError(String message) {
    Get.find<TaskHelper>().remove(ScheduleString.createScheduleTaskCode);
    ErrorAlert(ScheduleString.createError).show();
  }

  onLoadDataError(String message) {
    ErrorAlert(ScheduleString.createError).show();
  }

  onLoadDataFailed(String message) {
    FailedAlert(ScheduleString.createFailed).show();
  }
}
