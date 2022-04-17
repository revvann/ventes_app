// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:ventes/app/models/schedule_model.dart';
import 'package:ventes/app/models/user_model.dart';
import 'package:ventes/helpers/function_helpers.dart';

class ScheduleDataSource {
  final Rx<List<Schedule>> _appointments = Rx<List<Schedule>>([]);
  List<Schedule> get appointments => _appointments.value;
  set appointments(List<Schedule> value) => _appointments.value = value;

  void fetchSchedule() {
    List<Schedule> appointments = [];
    for (int i = 0; i < 5; i++) {
      Schedule appointment = Schedule(
        schestartdate: formatDate(DateTime.now()),
        scheenddate: formatDate(DateTime.now().add(Duration(hours: 1))),
        scheloc: "Lawrence, Massachusetts, USA",
        schenm: "Visit Essex Corporation",
        schedesc: "Watch how essex corp do their job as mutant genetic experiment.",
        schetypeid: 11,
        schetoward: User(
          userid: 1,
          userfullname: "Charles Xavier",
        ),
        scheallday: false,
      );
      appointments.add(appointment);
    }
    this.appointments = appointments;
  }
}
