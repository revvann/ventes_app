import 'package:ventes/app/states/typedefs/contact_person_fu_typedef.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';

class ContactPersonFormUpdateProperty extends StateProperty with PropertyMixin {
  Task task = Task(ProspectString.formUpdateContactTaskCode);
  late int contactid;

  void refresh() {
    dataSource.contactHandler.fetcher.run(contactid);
  }
}
