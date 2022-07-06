import 'package:flutter/cupertino.dart';
import 'package:ventes/app/states/typedefs/prospect_competitor_fc_typedef.dart';
import 'package:ventes/core/states/state_form_source.dart';

class ProspectCompetitorFormCreateFormSource extends StateFormSource with FormSourceMixin {
  Validator validator = Validator();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void init() {
    super.init();
    validator.formSource = this;
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  void onSubmit() {}
}
