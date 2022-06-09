import 'package:flutter/material.dart';

abstract class RegularFormSource {
  @mustCallSuper
  void init() {}
  @mustCallSuper
  void close() {}
  Map<String, dynamic> toJson();
}
