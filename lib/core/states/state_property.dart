import 'package:flutter/material.dart';

abstract class StateProperty {
  @mustCallSuper
  void init() {}

  @mustCallSuper
  void ready() {}

  @mustCallSuper
  void close() {}
}
