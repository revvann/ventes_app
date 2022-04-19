import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/state_controllers/regular_state_controller.dart';
import 'package:ventes/state_sources/data_sources/daily_schedule_data_source.dart';
import 'package:ventes/state_sources/state_listeners/daily_schedule_listener.dart';

class DailyScheduleStateController extends RegularStateController {
  DailyScheduleDataSource dataSource = DailyScheduleDataSource();
  late DailyScheduleListener listener;

  final Rx<DateTime> _date = Rx<DateTime>(DateTime.now());
  DateTime get date => _date.value;
  set date(DateTime value) => _date.value = value;

  @override
  void onInit() {
    super.onInit();
    listener = DailyScheduleListener(this);
  }

  @override
  void onReady() {
    super.onReady();
    Loader().show();
    dataSource.fetchSchedules(dbFormatDate(date));
  }
}
