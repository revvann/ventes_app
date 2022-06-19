import 'package:get/get.dart';
import 'package:ventes/app/states/typedefs/prospect_detail_fc_typedef.dart';
import 'package:ventes/constants/strings/prospect_string.dart';

class ProspectDetailFormCreateValidator {
  FormSource get _formSource => Get.find<FormSource>(tag: ProspectString.detailCreateTag);

  String? prosdtdesc(String? value) {
    if (value == null) {
      return 'Description is required';
    }

    if (value.isEmpty) {
      return 'Description is required';
    }

    return null;
  }

  String? prosdtdate(String? value) {
    if (_formSource.date == null) {
      return 'Date is required';
    }
    return null;
  }
}
