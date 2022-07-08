import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ventes/app/states/typedefs/prospect_competitor_fu_typedef.dart';
import 'package:ventes/core/states/update_form_source.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:path/path.dart' as path;

class ProspectCompetitorFormUpdateFormSource extends UpdateFormSource with FormSourceMixin {
  Validator validator = Validator();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool get isValid => formKey.currentState?.validate() ?? false;

  TextEditingController comptnameTEC = TextEditingController();
  TextEditingController comptproductnameTEC = TextEditingController();
  TextEditingController descriptionTEC = TextEditingController();

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
      data['_method'] = 'PUT';

      FormData formData = FormData(data);
      dataSource.updateHandler.fetcher.run(property.competitorid, formData);
    } else {
      Get.find<TaskHelper>().failedPush(Task('failedsubmit', message: "Form is not valid"));
    }
  }

  @override
  void prepareFormValues() {
    comptnameTEC.text = dataSource.competitor?.comptname ?? "";
    comptproductnameTEC.text = dataSource.competitor?.comptproductname ?? "";
    descriptionTEC.text = dataSource.competitor?.description ?? "";
  }
}
