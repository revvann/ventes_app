import 'package:get/get.dart';
import 'package:ventes/app/states/form/sources/prospect_fu_form_source.dart';
import 'package:ventes/constants/strings/prospect_string.dart';

class ProspectFormUpdateValidator {
  ProspectFormUpdateFormSource get _formSource => Get.find<ProspectFormUpdateFormSource>(tag: ProspectString.prospectUpdateTag);

  String? prosname(String? value) {
    if (value == null || value.isEmpty) {
      return "Prospect name can't be empty";
    }
    return null;
  }

  String? prosvalue(String? value) {
    if (value == null) {
      return "Prospect value can't be empty";
    }

    try {
      double.parse(_formSource.prosvalue!);
    } catch (e) {
      return "Prospect value must be a number";
    }

    return null;
  }

  String? prosstartdate(String? value) {
    if (_formSource.prosstartdate == null) {
      return "Start date can't be empty";
    }
    return null;
  }

  String? prosenddate(String? value) {
    if (_formSource.prosenddate == null) {
      return "End date can't be empty";
    }
    return null;
  }

  String? prosexpenddate(String? value) {
    if (_formSource.prosexpenddate == null) {
      return "Expectation date can't be empty";
    }
    return null;
  }
}
