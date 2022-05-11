import 'package:ventes/app/states/form_validators/example_validator.dart';

class ExampleFormSource {
  late ExampleValidator validator;

  init() {
    validator = ExampleValidator(this);
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
