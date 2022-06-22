import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/prospect_detail_fc_presenter.dart';
import 'package:ventes/app/models/maps_loc.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/app/states/typedefs/prospect_detail_fc_typedef.dart';
import 'package:ventes/core/states/state_data_source.dart';

class ProspectDetailFormCreateDataSource extends StateDataSource<ProspectDetailFormCreatePresenter> with DataSourceMixin implements ProspectDetailCreateContract {
  final Rx<Map<int, String>> _categoryItems = Rx<Map<int, String>>({});
  set categoryItems(Map<int, String> value) => _categoryItems.value = value;
  Map<int, String> get categoryItems => _categoryItems.value;

  final Rx<List<KeyableDropdownItem<int, DBType>>> _typeItems = Rx<List<KeyableDropdownItem<int, DBType>>>([]);
  set typeItems(List<KeyableDropdownItem<int, DBType>> value) => _typeItems.value = value;
  List<KeyableDropdownItem<int, DBType>> get typeItems => _typeItems.value;

  final Rx<MapsLoc?> _location = Rx<MapsLoc?>(null);
  set location(MapsLoc? value) => _location.value = value;
  MapsLoc? get location => _location.value;

  final Rx<Prospect?> _prospect = Rx<Prospect?>(null);
  set prospect(Prospect? value) => _prospect.value = value;
  Prospect? get prospect => _prospect.value;

  String? get locationAddress => location?.adresses?.first.formattedAddress;

  void fetchData(int id, double latitude, double longitude) => presenter.fetchData(id, latitude, longitude);
  void createData(Map<String, dynamic> data) => presenter.createData(data);

  @override
  ProspectDetailFormCreatePresenter presenterBuilder() => ProspectDetailFormCreatePresenter();

  @override
  onLoadError(String message) => listener.onLoadError(message);

  @override
  onLoadFailed(String message) => listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['categories'] != null) {
      List<DBType> followUpList = data['categories'].map<DBType>((item) => DBType.fromJson(item)).toList();
      formSource.prosdtcategory = followUpList.isEmpty ? null : followUpList.first.typeid!;
      categoryItems = followUpList.asMap().map((index, item) => MapEntry(item.typeid!, item.typename!));
    }

    if (data['types'] != null) {
      List<DBType> types = data['types'].map<DBType>((item) => DBType.fromJson(item)).toList();
      formSource.prosdttype = types.isNotEmpty ? types.first : null;
      typeItems = types.map<KeyableDropdownItem<int, DBType>>((item) => KeyableDropdownItem<int, DBType>(key: item.typeid!, value: item)).toList();
    }

    if (data['prospect'] != null) {
      prospect = Prospect.fromJson(data['prospect']);
      formSource.prospect = prospect;
    }

    if (data['location'] != null) {
      location = MapsLoc.fromJson(data['location']);
    }
  }

  @override
  void onCreateError(String message) => listener.onCreateDataError(message);

  @override
  void onCreateFailed(String message) => listener.onCreateDataFailed(message);

  @override
  void onCreateSuccess(String message) => listener.onCreateDataSuccess(message);

  @override
  void onCreateComplete() => listener.onComplete();

  @override
  onLoadComplete() => listener.onComplete();
}
