import 'dart:async';

import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/error_alert.dart';
import 'package:ventes/app/resources/widgets/failed_alert.dart';
import 'package:ventes/app/resources/widgets/loader.dart';
import 'package:ventes/app/resources/widgets/success_alert.dart';

class TaskHelper {
  List<String> tasks = [];
  List<Map<String, dynamic>> faileds = [];
  List<Map<String, dynamic>> errors = [];
  List<Map<String, dynamic>> success = [];

  loaderPush(String task) {
    if (tasks.isEmpty) {
      Loader().show();
    }
    tasks.add(task);
  }

  loaderPop(String task) async {
    tasks.remove(task);
    if (tasks.isEmpty) {
      Get.close(1);
      successShow().then((__) => failedShow().then((_) => errorShow()));
    }
  }

  Future failedPush(String task, String message, [Function()? onFinished]) async {
    faileds.add({'message': message, 'task': task, 'onFinished': onFinished});
    if (tasks.isEmpty) {
      await failedShow();
    }
  }

  failedPop(String task) {
    faileds.removeWhere((item) => item.containsValue(task));
  }

  Future failedShow() async {
    if (faileds.isNotEmpty) {
      Map data = faileds.first;
      String task = data['task'];
      String message = data['message'];
      Function()? onFinished = data['onFinished'];

      await FailedAlert(message).show();
      failedPop(task);
      onFinished?.call();
      return failedShow();
    }
    return;
  }

  Future errorPush(String task, String message, [Function()? onFinished]) async {
    errors.add({'message': message, 'task': task, 'onFinished': onFinished});
    if (tasks.isEmpty) {
      await errorShow();
    }
  }

  errorPop(String task) {
    errors.removeWhere((item) => item.containsValue(task));
  }

  Future errorShow() async {
    if (errors.isNotEmpty) {
      Map data = errors.first;
      String task = data['task'];
      String message = data['message'];
      Function()? onFinished = data['onFinished'];

      await FailedAlert(message).show();
      errorPop(task);
      onFinished?.call();
      return errorShow();
    }
    return;
  }

  Future successPush(String task, String message, [Function()? onFinished]) async {
    success.add({'message': message, 'task': task, 'onFinished': onFinished});
    if (tasks.isEmpty) {
      await successShow();
    }
  }

  successPop(String task) {
    success.removeWhere((item) => item.containsValue(task));
  }

  Future successShow() async {
    if (success.isNotEmpty) {
      Map data = success.first;
      String task = data['task'];
      String message = data['message'];
      Function()? onFinished = data['onFinished'];

      await SuccessAlert(message).show();
      successPop(task);
      onFinished?.call();
      return successShow();
    }
    return;
  }
}
