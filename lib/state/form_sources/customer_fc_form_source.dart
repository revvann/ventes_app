import 'package:flutter/cupertino.dart';
import 'package:ventes/state/form_validators/customer_fc_validator.dart';

class CustomerFormCreateFormSource {
  late CustomerFormCreateValidator validator;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  init() {
    validator = CustomerFormCreateValidator(this);
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
