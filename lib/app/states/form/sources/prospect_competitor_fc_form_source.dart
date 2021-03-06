import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/states/typedefs/prospect_competitor_fc_typedef.dart';
import 'package:ventes/core/states/state_form_source.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:path/path.dart' as path;

class ProspectCompetitorFormCreateFormSource extends StateFormSource with FormSourceMixin {
  Validator validator = Validator();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool get isValid => formKey.currentState?.validate() ?? false;

  TextEditingController comptnameTEC = TextEditingController();
  TextEditingController comptproductnameTEC = TextEditingController();
  TextEditingController descriptionTEC = TextEditingController();

  final Rx<DBType?> _comptreftype = Rx(null);
  DBType? get comptreftype => _comptreftype.value;
  set comptreftype(DBType? value) => _comptreftype.value = value;

  final Rx<List<File>> _images = Rx([]);
  List<File> get images => _images.value;
  set images(List<File> images) => _images.value = images;
  List<File> get secondHalfImages {
    int start = 0;
    int end = start + images.length ~/ 2;
    return images.sublist(start, end);
  }

  List<File> get firstHalfImages {
    int start = images.length ~/ 2;
    int end = start + (images.length ~/ 2 + images.length % 2);
    return images.sublist(start, end);
  }

  List<MultipartFile> get multiparts => images.map<MultipartFile>((e) {
        String filename = path.basename(e.path);
        return MultipartFile(e, filename: filename);
      }).toList();

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'comptbpid': dataSource.prospect?.prospectbpid,
      'comptreftypeid': comptreftype?.typeid,
      'comptrefid': dataSource.prospect?.prospectid,
      'comptname': comptnameTEC.text,
      'comptproductname': comptproductnameTEC.text,
      'description': descriptionTEC.text,
    };
    if (multiparts.isNotEmpty) data['comptpics[]'] = multiparts;
    return data;
  }

  @override
  void onSubmit() {
    if (isValid) {
      Map<String, dynamic> data = toJson();
      FormData formData = FormData(data);
      dataSource.createHandler.fetcher.run(formData);
    } else {
      Get.find<TaskHelper>().failedPush(Task('failedsubmit', message: "Form is not valid"));
    }
  }
}
