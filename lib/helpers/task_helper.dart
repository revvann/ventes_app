import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/loader.dart';

class TaskHelper {
  List<String> tasks = [];

  add(String task) {
    if (tasks.isEmpty) {
      Loader().show();
    }
    tasks.add(task);
  }

  remove(String task) {
    tasks.remove(task);
    if (tasks.isEmpty) {
      Get.close(1);
    }
  }
}
