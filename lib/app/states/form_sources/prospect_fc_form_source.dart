import 'package:get/get.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/helpers/function_helpers.dart';

class ProspectFormCreateFormSource {
  KeyableDropdownController<int, UserDetail> ownerDropdownController = Get.put(KeyableDropdownController<int, UserDetail>());
  KeyableDropdownController<int, BpCustomer> customerDropdownController = Get.put(KeyableDropdownController<int, BpCustomer>());

  final Rx<DateTime?> _prosstartdate = Rx<DateTime?>(null);
  final Rx<DateTime?> _prosenddate = Rx<DateTime?>(null);
  final Rx<DateTime?> _prosexpenddate = Rx<DateTime?>(null);

  DateTime? get prosstartdate => _prosstartdate.value;
  set prosstartdate(DateTime? value) => _prosstartdate.value = value;

  DateTime? get prosenddate => _prosenddate.value;
  set prosenddate(DateTime? value) => _prosenddate.value = value;

  DateTime? get prosexpenddate => _prosexpenddate.value;
  set prosexpenddate(DateTime? value) => _prosexpenddate.value = value;

  String? get prosstartdateString => prosstartdate == null ? null : formatDate(prosstartdate!);
  String? get prosenddateString => prosenddate == null ? null : formatDate(prosenddate!);
  String? get prosexpenddateString => prosexpenddate == null ? null : formatDate(prosexpenddate!);
}
