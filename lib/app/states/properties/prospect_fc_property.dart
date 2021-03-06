import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/prospect_fc_typedef.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectFormCreateProperty extends StateProperty with PropertyMixin {
  Task task = Task(ProspectString.formCreateTaskCode);

  void refresh() {
    dataSource.stagesHandler.fetcher.run();
    dataSource.statusesHandler.fetcher.run();
    dataSource.taxesHandler.fetcher.run();
  }
}
