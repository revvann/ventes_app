import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/prospect_activity_fu_presenter.dart';
import 'package:ventes/app/api/models/maps_loc.dart';
import 'package:ventes/app/api/models/prospect_activity_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/controllers/prospect_activity_state_controller.dart';
import 'package:ventes/app/states/typedefs/prospect_activity_fu_typedef.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/utils/utils.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectActivityFormUpdateDataSource extends StateDataSource<ProspectActivityFormUpdatePresenter> with DataSourceMixin {
  final String typesID = 'typshdr';
  final String categoriesID = 'cathdr';
  final String prospectActivityID = 'prosdethdr';
  final String locationID = 'locatnhdr';
  final String updateID = 'updatehdr';

  late DataHandler<List<KeyableDropdownItem<int, DBType>>, List, Function()> typesHandler;
  late DataHandler<Map<int, String>, List, Function()> categoriesHandler;
  late DataHandler<ProspectActivity?, Map<String, dynamic>, Function(int)> prospectActivityHandler;
  late DataHandler<MapsLoc?, Map<String, dynamic>, Function(double, double)> locationHandler;
  late DataHandler<dynamic, String, Function(int, Map<String, dynamic>)> updateHandler;

  List<KeyableDropdownItem<int, DBType>> get typeItems => typesHandler.value;
  Map<int, String> get categoryItems => categoriesHandler.value;
  ProspectActivity? get prospectactivity => prospectActivityHandler.value;
  MapsLoc? get mapsLoc => locationHandler.value;

  String? get locationAddress => mapsLoc?.adresses?.first.formattedAddress;

  List<KeyableDropdownItem<int, DBType>> _typesSuccess(data) {
    List<DBType> types = data.map<DBType>((item) => DBType.fromJson(item)).toList();
    return types.map<KeyableDropdownItem<int, DBType>>((item) => KeyableDropdownItem<int, DBType>(key: item.typeid!, value: item)).toList();
  }

  Map<int, String> _categoriesSuccess(List data) {
    List<DBType> categoriesList = data.map<DBType>((item) => DBType.fromJson(item)).toList();
    formSource.prosdtcatid = categoriesList.isEmpty ? null : categoriesList.first.typeid!;
    return categoriesList.asMap().map((index, item) => MapEntry(item.typeid!, item.typename!));
  }

  void _updateSuccess(message) {
    Get.find<TaskHelper>().successPush(
      Task(
        updateID,
        message: message,
        onFinished: (res) {
          Get.find<ProspectActivityStateController>().refreshStates();
          Get.back(id: Views.prospect.index);
        },
      ),
    );
  }

  void _prospectActivityComplete() {
    formSource.prepareFormValues();

    double? latitude = prospectactivity?.prospectactivitylatitude;
    double? longitude = prospectactivity?.prospectactivitylongitude;
    if (latitude != null && longitude != null) {
      locationHandler.fetcher.run(latitude, longitude);
    }
  }

  @override
  void init() {
    super.init();
    categoriesHandler = Utils.createDataHandler(categoriesID, presenter.fetchCategories, {}, _categoriesSuccess);
    typesHandler = Utils.createDataHandler(typesID, presenter.fetchTypes, [], _typesSuccess);
    prospectActivityHandler = Utils.createDataHandler(prospectActivityID, presenter.fetchProspectActivity, null, ProspectActivity.fromJson, onComplete: _prospectActivityComplete);
    locationHandler = Utils.createDataHandler(locationID, presenter.fetchLocation, null, MapsLoc.fromJson);
    updateHandler = Utils.createDataHandler(updateID, presenter.update, null, _updateSuccess);
  }

  @override
  ProspectActivityFormUpdatePresenter presenterBuilder() => ProspectActivityFormUpdatePresenter();
}
