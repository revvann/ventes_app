import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/product_fu_typedef.dart';
import 'package:ventes/core/states/state_property.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProductFormUpdateProperty extends StateProperty with PropertyMixin {
  late int productid;

  Task task = Task(ProspectString.formUpdateProductTaskCode);

  void refresh() {
    dataSource.productHandler.fetcher.run(productid);
    dataSource.taxesHandler.fetcher.run();
  }
}
