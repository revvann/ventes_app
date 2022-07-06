import 'package:ventes/app/states/typedefs/prospect_competitor_fc_typedef.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectCompetitorFormCreateProperty extends StateProperty with PropertyMixin {
  late int prospectid;
  Task task = Task(ProspectString.formCreateCompetitorTaskCode);

  void refresh() {}
}
