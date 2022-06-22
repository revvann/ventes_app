import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/prospect_typedef.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectProperty extends StateProperty with PropertyMixin {
  Prospect? selectedProspect;
  Task task = Task(ProspectString.taskCode);

  void refresh() {
    dataSource.prospectsHandler.fetcher.run();
    dataSource.statusesHandler.fetcher.run();
  }
}
