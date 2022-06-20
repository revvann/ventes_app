import 'dart:async';

import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/confirm_alert.dart';
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
  List<Task<bool>> confirms = [];

  bool taskExists(String taskName) => tasks.firstWhereOrNull((task) => task.name == taskName) != null;
  bool failedExists(String taskName) => faileds.firstWhereOrNull((task) => task.name == taskName) != null;
  bool errorExists(String taskName) => errors.firstWhereOrNull((task) => task.name == taskName) != null;
  bool successExists(String taskName) => success.firstWhereOrNull((task) => task.name == taskName) != null;
  bool confirmExists(String taskName) => confirms.firstWhereOrNull((task) => task.name == taskName) != null;

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
        task.result = await FailedSnackbar(task.message!).show();
      } else {
        task.result = await FailedAlert(task.message!).show();
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
        task.result = await ErrorSnackbar(task.message!).show();
      } else {
        task.result = await ErrorAlert(task.message!).show();
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
        task.result = await SuccessSnackbar(task.message!).show();
      } else {
        task.result = await SuccessAlert(task.message!).show();
      }

      successPop(task.name);
      task.finish();
      return successShow();
    }
    return;
  }

  Future confirmPush(Task<bool> task) async {
    confirms.add(task);
    if (tasks.isEmpty) {
      await confirmShow();
    }
  }

  confirmPop(String taskName) {
    if (confirmExists(taskName)) {
      confirms.removeWhere((item) => item.name == taskName);
    }
  }

  Future confirmShow() async {
    if (confirms.isNotEmpty) {
      Task<bool> task = confirms.first;
      task.result = await ConfirmAlert(task.message!).show();

      confirmPop(task.name);
      task.finish();
      return confirmShow();
    }
    return;
  }
}

class Task<T> {
  String name;
  String? message;
  Function(T result)? onFinished;
  bool snackbar;
  late T result;

  Task(this.name, {this.message, this.onFinished, this.snackbar = false});

  void finish() {
    onFinished?.call(result);
  }

  Task<S> copyWith<S>({String? name, String? message, Function(S result)? onFinished, bool snackbar = false}) {
    return Task<S>(name ?? this.name, message: message, onFinished: onFinished, snackbar: snackbar);
  }
}
