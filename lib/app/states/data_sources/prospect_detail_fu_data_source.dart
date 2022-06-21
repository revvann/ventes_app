import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/prospect_detail_fu_presenter.dart';
import 'package:ventes/app/models/maps_loc.dart';
import 'package:ventes/app/models/prospect_detail_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/typedefs/prospect_detail_fu_typedef.dart';
import 'package:ventes/core/states/state_data_source.dart';

class ProspectDetailFormUpdateDataSource extends StateDataSource<ProspectDetailFormUpdatePresenter> with DataSourceMixin implements ProspectDetailUpdateContract {
  final Rx<List<KeyableDropdownItem<int, DBType>>> _typeItems = Rx<List<KeyableDropdownItem<int, DBType>>>([]);
  set typeItems(List<KeyableDropdownItem<int, DBType>> value) => _typeItems.value = value;
  List<KeyableDropdownItem<int, DBType>> get typeItems => _typeItems.value;

  final Rx<ProspectDetail?> _prospectdetail = Rx<ProspectDetail?>(null);
  set prospectdetail(ProspectDetail? value) => _prospectdetail.value = value;
  ProspectDetail? get prospectdetail => _prospectdetail.value;

  final Rx<MapsLoc?> _mapsLoc = Rx<MapsLoc?>(null);
  set mapsLoc(MapsLoc? value) => _mapsLoc.value = value;
  MapsLoc? get mapsLoc => _mapsLoc.value;

  String? get locationAddress => mapsLoc?.adresses?.first.formattedAddress;

  void fetchData(int id) => presenter.fetchData(id);
  void updateData(int id, Map<String, dynamic> data) => presenter.updateData(id, data);

  @override
  ProspectDetailFormUpdatePresenter presenterBuilder() => ProspectDetailFormUpdatePresenter();

  @override
  onLoadError(String message) => listener.onLoadError(message);

  @override
  onLoadFailed(String message) => listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['types'] != null) {
      List<DBType> types = data['types'].map<DBType>((item) => DBType.fromJson(item)).toList();
      typeItems = types.map<KeyableDropdownItem<int, DBType>>((item) => KeyableDropdownItem<int, DBType>(key: item.typeid!, value: item)).toList();
    }

    if (data['prospectdetail'] != null) {
      prospectdetail = ProspectDetail.fromJson(data['prospectdetail']);
      formSource.prepareFormValues();
    }

    if (data['locationaddress'] != null) {
      mapsLoc = MapsLoc.fromJson(data['locationaddress']);
    }
  }

  @override
  void onUpdateError(String message) => listener.onUpdateDataError(message);

  @override
  void onUpdateFailed(String message) => listener.onUpdateDataFailed(message);

  @override
  void onUpdateSuccess(String message) => listener.onUpdateDataSuccess(message);

  @override
  onLoadComplete() => listener.onComplete();

  @override
  void onUpdateComplete() => listener.onComplete();
}
