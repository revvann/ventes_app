import 'dart:async';

import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/error_alert.dart';
import 'package:ventes/app/resources/widgets/error_snackbar.dart';
import 'package:ventes/app/resources/widgets/failed_alert.dart';
import 'package:ventes/app/resources/widgets/failed_snackbar.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/app/resources/widgets/success_alert.dart';
import 'package:ventes/app/resources/widgets/success_snackbar.dart';

class TaskHelper {
  List<Task> tasks = [];
  List<Task> faileds = [];
  List<Task> errors = [];
  List<Task> success = [];

  bool taskExists(String taskName) => tasks.firstWhereOrNull((task) => task.name == taskName) != null;
  bool failedExists(String taskName) => faileds.firstWhereOrNull((task) => task.name == taskName) != null;
  bool errorExists(String taskName) => errors.firstWhereOrNull((task) => task.name == taskName) != null;
  bool successExists(String taskName) => success.firstWhereOrNull((task) => task.name == taskName) != null;

  loaderPush(Task task) {
    if (tasks.isEmpty) {
      Loader().show();
    }
    tasks.add(task);
  }

  loaderPop(String taskName) async {
    if (taskExists(taskName)) {
      tasks.removeWhere((task) => task.name == taskName);
      if (tasks.isEmpty) {
        Get.close(1);
        successShow().then((__) => failedShow().then((_) => errorShow()));
      }
    }
  }

  Future failedPush(Task task) async {
    faileds.add(task);
    if (tasks.isEmpty) {
      await failedShow();
    }
  }

  failedPop(String taskName) {
    if (failedExists(taskName)) {
      faileds.removeWhere((item) => item.name == taskName);
    }
  }

  Future failedShow() async {
    if (faileds.isNotEmpty) {
      Task task = faileds.first;

      if (task.snackbar) {
        await FailedSnackbar(task.message!).show();
      } else {
        await FailedAlert(task.message!).show();
      }
      failedPop(task.name);
      task.finish();
      return failedShow();
    }
    return;
  }

  Future errorPush(Task task) async {
    errors.add(task);
    if (tasks.isEmpty) {
      await errorShow();
    }
  }

  errorPop(String taskName) {
    if (errorExists(taskName)) {
      errors.removeWhere((item) => item.name == taskName);
    }
  }

  Future errorShow() async {
    if (errors.isNotEmpty) {
      Task task = errors.first;

      if (task.snackbar) {
        await ErrorSnackbar(task.message!).show();
      } else {
        await ErrorAlert(task.message!).show();
      }

      errorPop(task.name);
      task.finish();
      return errorShow();
    }
    return;
  }

  Future successPush(Task task) async {
    success.add(task);
    if (tasks.isEmpty) {
      await successShow();
    }
  }

  successPop(String taskName) {
    if (successExists(taskName)) {
      success.removeWhere((item) => item.name == taskName);
    }
  }

  Future successShow({bool snackbar = false}) async {
    if (success.isNotEmpty) {
      Task task = success.first;

      if (task.snackbar) {
        await SuccessSnackbar(task.message!).show();
      } else {
        await SuccessAlert(task.message!).show();
      }

      successPop(task.name);
      task.finish();
      return successShow();
    }
    return;
  }
}

class Task {
  String name;
  String? message;
  Function()? onFinished;
  bool snackbar;

  Task(this.name, {this.message, this.onFinished, this.snackbar = false});

  void finish() {
    onFinished?.call();
  }

  Task copyWith({String? message, Function()? onFinished, bool snackbar = false}) {
    return Task(name, message: message, onFinished: onFinished, snackbar: snackbar);
  }
}
