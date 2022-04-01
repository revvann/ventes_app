import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ventes/state_controllers/regular_state_controller.dart';
import 'package:ventes/widgets/regular_dropdown.dart';

class ScheduleFormCreateStateController extends RegularStateController {
  final _typeActive = 0.obs;
  int get typeActive => _typeActive.value;
  set typeActive(int value) => _typeActive.value = value;

  final timeStartSelectController = DropdownController<String?>(null);
  final timeEndSelectController = DropdownController<String?>(null);

  final _timeStartList = Rx<List<Map>>([]);
  List<Map> get timeStartList => _timeStartList.value;
  set timeStartList(List<Map> value) => _timeStartList.value = value;

  final _timeEndList = Rx<List<Map>>([]);
  List<Map> get timeEndList => _timeEndList.value;
  set timeEndList(List<Map> value) => _timeEndList.value = value;

  @override
  void onReady() {
    super.onReady();
    createStartTimeList();
  }

  void createStartTimeList() {
    timeStartList = _createItems();
    timeStartSelectController.value = timeStartList.first['value'];
    createEndTimeList();
  }

  void createEndTimeList() {
    DateTime time = DateTime.parse("0000-00-00 ${timeStartSelectController.value}");
    timeEndList = _createItems(time.hour, time.minute);
    timeEndSelectController.value = timeEndList.first['value'];
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
}
