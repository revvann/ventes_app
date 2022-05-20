import 'package:get/get.dart';
import 'package:ventes/helpers/function_helpers.dart';

class ProspectFormSource {
  final Rx<DateTime> _prosstartdate = Rx<DateTime>(DateTime.now());
  final Rx<DateTime> _prosenddate = Rx<DateTime>(DateTime.now());

  DateTime get prosstartdate => _prosstartdate.value;
  set prosstartdate(DateTime value) => _prosstartdate.value = value;

  DateTime get prosenddate => _prosenddate.value;
  set prosenddate(DateTime value) => _prosenddate.value = value;

  String get prosstartdateString => formatDate(prosstartdate);
  String get prosenddateString => formatDate(prosenddate);
}
