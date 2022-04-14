import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/state_sources/form_sources/schedule_fc_form_source.dart';

class ScheduleFormCreateListener {
  ScheduleFormCreateListener(this.formSource);
  ScheduleFormCreateFormSource formSource;

  void onAlldayValueChanged(value) {
    if (value) {
      formSource.schestarttimeDC.enabled = false;
      formSource.scheendtimeDC.enabled = false;
    } else {
      formSource.schestarttimeDC.enabled = true;
      formSource.scheendtimeDC.enabled = true;
    }
    formSource.scheallday = value;
  }

  void onOnlineValueChanged(value) {
    formSource.scheonline = value;
  }

  void onDateStartSelected(DateTime? value) {
    if (value != null) {
      formSource.schestartdate = value.subtract(Duration(
        hours: value.hour,
        minutes: value.minute,
        seconds: value.second,
      ));
      if (formSource.schestartdate.isAfter(formSource.scheenddate)) {
        formSource.scheenddate = formSource.schestartdate;
      }
    }
  }

  void onDateEndSelected(DateTime? value) {
    if (value != null) {
      formSource.scheenddate = value.subtract(Duration(
        hours: value.hour,
        minutes: value.minute,
        seconds: value.second,
      ));
    }
  }

  void onTimeStartSelected(String? value) {
    if (value != null) {
      DateTime time = parseTime(value);
      if (formSource.schestarttime != null) {
        DateTime _dateStart = formSource.schestarttime!.subtract(Duration(
          hours: formSource.schestartdate.hour,
          minutes: formSource.schestartdate.minute,
          seconds: formSource.schestartdate.second,
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
          hours: formSource.scheenddate.hour,
          minutes: formSource.scheenddate.minute,
          seconds: formSource.scheenddate.second,
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

  void onGuestChanged(UserDetail? user) {
    if (user != null) {
      formSource.addGuest(user);
      formSource.dataSource.fetchUser();
    }
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

  void onGuestSelected(UserDetail user) {
    if (formSource.guests.where((item) => item.userid == user.userid).isEmpty) {
      formSource.addGuest(user);
    } else {
      formSource.removeGuest(user);
    }
  }
}
