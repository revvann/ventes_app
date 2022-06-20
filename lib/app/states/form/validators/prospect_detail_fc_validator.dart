import 'package:ventes/app/states/typedefs/prospect_detail_fc_typedef.dart';

class ProspectDetailFormCreateValidator {
  late FormSource _formSource;
  set formSource(FormSource value) => _formSource = value;

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
