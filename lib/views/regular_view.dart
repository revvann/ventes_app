import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

abstract class RegularView<T extends GetxController> extends GetView<T> {
  late T $;
  RegularView({Key? key}) : super(key: key) {
    $ = controller;
  }
}
