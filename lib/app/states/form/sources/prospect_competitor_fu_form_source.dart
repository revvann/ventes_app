import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ventes/app/states/typedefs/prospect_competitor_fu_typedef.dart';
import 'package:ventes/core/states/update_form_source.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectCompetitorFormUpdateFormSource extends UpdateFormSource with FormSourceMixin {
  Validator validator = Validator();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool get isValid => formKey.currentState?.validate() ?? false;

  TextEditingController comptnameTEC = TextEditingController();
  TextEditingController comptproductnameTEC = TextEditingController();
  TextEditingController descriptionTEC = TextEditingController();

  @override
  Map<String, dynamic> toJson() {
    return {
      'comptname': comptnameTEC.text,
      'comptproductname': comptproductnameTEC.text,
      'description': descriptionTEC.text,
    };
  }

  @override
  void onSubmit() {
    if (isValid) {
      Map<String, dynamic> data = toJson();
      dataSource.updateHandler.fetcher.run(property.competitorid, data);
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
