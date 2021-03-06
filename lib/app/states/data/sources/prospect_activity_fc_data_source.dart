import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/prospect_activity_fc_presenter.dart';
import 'package:ventes/app/api/models/maps_loc.dart';
import 'package:ventes/app/api/models/prospect_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/controllers/prospect_activity_state_controller.dart';
import 'package:ventes/app/states/typedefs/prospect_activity_fc_typedef.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/utils/utils.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectActivityFormCreateDataSource extends StateDataSource<ProspectActivityFormCreatePresenter> with DataSourceMixin {
  final String categoriesID = 'cathdr';
  final String typesID = 'tpshdr';
  final String prospectID = 'prohdr';
  final String locationID = 'locID';
  final String createID = 'creID';

  late DataHandler<Map<int, String>, List, Function()> categoriesHandler;
  late DataHandler<List<KeyableDropdownItem<int, DBType>>, List, Function()> typesHandler;
  late DataHandler<Prospect?, Map<String, dynamic>, Function(int)> prospectHandler;
  late DataHandler<MapsLoc?, Map<String, dynamic>, Function(double, double)> locationHandler;
  late DataHandler<dynamic?, String, Function(Map<String, dynamic>)> createHandler;

  Map<int, String> get categoryItems => categoriesHandler.value;
  List<KeyableDropdownItem<int, DBType>> get typeItems => typesHandler.value;
  MapsLoc? get location => locationHandler.value;
  Prospect? get prospect => prospectHandler.value;

  String? get locationAddress => location?.adresses?.first.formattedAddress;

  Map<int, String> _categoriesSuccess(List data) {
    List<DBType> categoriesList = data.map<DBType>((item) => DBType.fromJson(item)).toList();
    formSource.prosdtcategory = categoriesList.isEmpty ? null : categoriesList.first.typeid!;
    return categoriesList.asMap().map((index, item) => MapEntry(item.typeid!, item.typename!));
  }

  List<KeyableDropdownItem<int, DBType>> _typesSuccess(List data) {
    List<DBType> types = data.map<DBType>((item) => DBType.fromJson(item)).toList();
    formSource.prosdttype = types.isNotEmpty ? types.first : null;
    return types.map<KeyableDropdownItem<int, DBType>>((item) => KeyableDropdownItem<int, DBType>(key: item.typeid!, value: item)).toList();
  }

  void _createSuccess(message) {
    Get.find<TaskHelper>().successPush(
      Task(
        createID,
        message: message,
        onFinished: (res) {
          Get.find<ProspectActivityStateController>().refreshStates();
          Get.back(id: Views.prospect.index);
        },
      ),
    );
  }

  @override
  void init() {
    super.init();
    categoriesHandler = Utils.createDataHandler(categoriesID, presenter.fetchCategories, {}, _categoriesSuccess);
    typesHandler = Utils.createDataHandler(typesID, presenter.fetchTypes, [], _typesSuccess);
    locationHandler = Utils.createDataHandler(locationID, presenter.fetchLocation, null, MapsLoc.fromJson);
    prospectHandler = Utils.createDataHandler(prospectID, presenter.fetchProspect, null, Prospect.fromJson, onComplete: () => formSource.prospect = prospect);
    createHandler = DataHandler(
      createID,
      fetcher: presenter.create,
      initialValue: null,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(createID)),
      onSuccess: _createSuccess,
      onFailed: (message) => Utils.showFailed(createID, message, false),
      onError: (message) => Utils.showError(createID, message),
      onComplete: () => Get.find<TaskHelper>().loaderPop(createID),
    );
  }

  @override
  ProspectActivityFormCreatePresenter presenterBuilder() => ProspectActivityFormCreatePresenter();
}
