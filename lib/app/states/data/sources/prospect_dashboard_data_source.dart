import 'package:ventes/app/api/presenters/prospect_dashboard_presenter.dart';
import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/prospect_assign_model.dart';
import 'package:ventes/app/models/prospect_activity_model.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/prospect_product_model.dart';
import 'package:ventes/app/models/user_detail_model.dart';
import 'package:ventes/app/states/typedefs/prospect_dashboard_typedef.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/function_helpers.dart';

class ProspectDashboardDataSource extends StateDataSource<ProspectDashboardPresenter> with DataSourceMixin {
  final String prospectID = 'prospehdr';
  final String userID = 'userhdr';
  final String bpCustomerID = 'bpcusthdr';
  final String productsID = 'productshdr';
  final String detailsID = 'detailshdr';
  final String assignUsersID = 'assignhdr';

  late DataHandler<Prospect?, Map<String, dynamic>, Function(int)> prospectHandler;
  late DataHandler<UserDetail?, Map<String, dynamic>, Function(int)> userHandler;
  late DataHandler<BpCustomer?, Map<String, dynamic>, Function(int)> bpCustomerHandler;
  late DataHandler<List<ProspectProduct>, List, Function(int)> productsHandler;
  late DataHandler<List<ProspectActivity>, List, Function(int)> detailsHandler;
  late DataHandler<List<ProspectAssign>, List, Function(int)> assignUsersHandler;

  Prospect? get prospect => prospectHandler.value;
  UserDetail? get userDetail => userHandler.value;
  BpCustomer? get bpCustomer => bpCustomerHandler.value;
  List<ProspectProduct> get products => productsHandler.value;
  List<ProspectActivity> get prospectActivities => detailsHandler.value;
  List<ProspectAssign> get assignUsers => assignUsersHandler.value;

  void _prospectComplete() {
    if (prospect?.prospectowner != null) userHandler.fetcher.run(prospect!.prospectowner!);
    if (prospect?.prospectcustid != null) bpCustomerHandler.fetcher.run(prospect!.prospectcustid!);
  }

  @override
  void init() {
    super.init();
    prospectHandler = createDataHandler(prospectID, presenter.fetchProspect, null, Prospect.fromJson, onComplete: _prospectComplete);
    userHandler = createDataHandler(prospectID, presenter.fetchUser, null, UserDetail.fromJson);
    bpCustomerHandler = createDataHandler(prospectID, presenter.fetchBpCustomer, null, BpCustomer.fromJson);
    productsHandler = createDataHandler(productsID, presenter.fetchProducts, [], (data) => data.map((e) => ProspectProduct.fromJson(e)).toList());
    detailsHandler = createDataHandler(detailsID, presenter.fetchDetails, [], (data) => data.map((e) => ProspectActivity.fromJson(e)).toList());
    assignUsersHandler = createDataHandler(assignUsersID, presenter.fetchAssignedUsers, [], (data) => data.map((e) => ProspectAssign.fromJson(e)).toList());
  }

  @override
  ProspectDashboardPresenter presenterBuilder() => ProspectDashboardPresenter();
}
