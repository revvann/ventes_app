import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/product_fc_typedef.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProductFormCreateProperty extends StateProperty with PropertyMixin {
  late int prospectid;

  Task task = Task(ProspectString.formCreateProductTaskCode);

  void refresh() {
    dataSource.taxesHandler.fetcher.run();
    dataSource.prospectHandler.fetcher.run(prospectid);
  }
}
