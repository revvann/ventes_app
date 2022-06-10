part of 'package:ventes/app/states/controllers/customer_fu_state_controller.dart';

class _Validator {
  String? cstmname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }
  }

  String? cstmphone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone cannot be empty';
    }
  }

  String? cstmaddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address cannot be empty';
    }
  }
}
