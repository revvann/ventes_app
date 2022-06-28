import 'package:flutter/material.dart' hide MenuItem;
import 'package:get/get.dart';
import 'package:ventes/app/resources/widgets/loading_container.dart';
import 'package:ventes/core/api/handler.dart';

///
/// [F] must be [Function] with [Widget] return type
///
class HandlerContainer<F extends Function> extends StatelessWidget {
  double width;
  F builder;
  List<DataHandler> handlers;
  bool loadable;

  HandlerContainer({this.width = 15, required this.builder, required this.handlers, this.loadable = true});

  List<bool> get processes => handlers.map((e) => e.onProcess).toList();
  List get values => handlers.map((e) => e.value).toList();
  bool get onProcess => processes.reduce((value, element) => value || element);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return LoadingContainer(width: width, isLoading: onProcess && loadable, child: Function.apply(builder, values));
    });
  }
}
