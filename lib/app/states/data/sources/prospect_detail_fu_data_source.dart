import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/prospect_detail_fu_presenter.dart';
import 'package:ventes/app/models/maps_loc.dart';
import 'package:ventes/app/models/prospect_detail_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/controllers/prospect_detail_state_controller.dart';
import 'package:ventes/app/states/typedefs/prospect_detail_fu_typedef.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/routing/navigators/prospect_navigator.dart';

class ProspectDetailFormUpdateDataSource extends StateDataSource<ProspectDetailFormUpdatePresenter> with DataSourceMixin {
  final String typesID = 'typshdr';
  final String prospectDetailID = 'prosdethdr';
  final String locationID = 'locatnhdr';
  final String updateID = 'updatehdr';

  late DataHandler<List<KeyableDropdownItem<int, DBType>>, List, Function()> typesHandler;
  late DataHandler<ProspectDetail?, Map<String, dynamic>, Function(int)> prospectDetailHandler;
  late DataHandler<MapsLoc?, Map<String, dynamic>, Function(double, double)> locationHandler;
  late DataHandler<dynamic, String, Function(int, Map<String, dynamic>)> updateHandler;

  List<KeyableDropdownItem<int, DBType>> get typeItems => typesHandler.value;
  ProspectDetail? get prospectdetail => prospectDetailHandler.value;
  MapsLoc? get mapsLoc => locationHandler.value;

  String? get locationAddress => mapsLoc?.adresses?.first.formattedAddress;

  List<KeyableDropdownItem<int, DBType>> _typesSuccess(data) {
    List<DBType> types = data.map<DBType>((item) => DBType.fromJson(item)).toList();
    return types.map<KeyableDropdownItem<int, DBType>>((item) => KeyableDropdownItem<int, DBType>(key: item.typeid!, value: item)).toList();
  }

  void _updateSuccess(message) {
    Get.find<TaskHelper>().successPush(
      Task(
        updateID,
        message: message,
        onFinished: (res) {
          Get.find<ProspectDetailStateController>().refreshStates();
          Get.back(id: ProspectNavigator.id);
        },
      ),
    );
  }

  void _prospectDetailComplete() {
    formSource.prepareFormValues();

    double? latitude = prospectdetail?.prospectdtlatitude;
    double? longitude = prospectdetail?.prospectdtlongitude;
    if (latitude != null && longitude != null) {
      locationHandler.fetcher.run(latitude, longitude);
    }
  }

  @override
  void init() {
    super.init();
    typesHandler = createDataHandler(typesID, presenter.fetchTypes, [], _typesSuccess);
    prospectDetailHandler = createDataHandler(prospectDetailID, presenter.fetchProspectDetail, null, ProspectDetail.fromJson, onComplete: _prospectDetailComplete);
    locationHandler = createDataHandler(locationID, presenter.fetchLocation, null, MapsLoc.fromJson);
    updateHandler = createDataHandler(updateID, presenter.update, null, _updateSuccess);
  }

  @override
  ProspectDetailFormUpdatePresenter presenterBuilder() => ProspectDetailFormUpdatePresenter();

  @override
  onLoadError(String message) {}

  @override
  onLoadFailed(String message) {}

  @override
  onLoadSuccess(Map data) {}

  @override
  void onUpdateError(String message) {}

  @override
  void onUpdateFailed(String message) {}

  @override
  void onUpdateSuccess(String message) {}

  @override
  onLoadComplete() {}

  @override
  void onUpdateComplete() {}
}
