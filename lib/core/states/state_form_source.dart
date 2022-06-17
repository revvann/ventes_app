import 'package:flutter/material.dart';

abstract class StateFormSource {
  void onSubmit();

  @mustCallSuper
  void init() {}

  @mustCallSuper
  void ready() {}

  @mustCallSuper
  void close() {}
  Map<String, dynamic> toJson();
}
