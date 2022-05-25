import 'dart:async';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class KeyboardStateController extends GetxController {
  late StreamSubscription<bool> keyboardSubscription;

  final List<Function(bool)> _keyboardListeners = [];

  @override
  void onInit() {
    super.onInit();

    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription = keyboardVisibilityController.onChange.listen(listener);
  }

  void listener(bool visible) {
    Future.forEach(_keyboardListeners, (Function(bool) listener) async {
      listener(visible);
    });
  }

  add(Function(bool) listener) {
    _keyboardListeners.add(listener);
  }

  remove(Function(bool) listener) {
    _keyboardListeners.remove(listener);
  }

  bool get isVisible => KeyboardVisibilityController().isVisible;

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }
}
