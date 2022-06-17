part of 'package:ventes/app/states/controllers/prospect_detail_fu_state_controller.dart';

class ProspectDetailFormUpdateDataSource extends StateDataSource<ProspectDetailFormUpdatePresenter> implements ProspectDetailUpdateContract {
  ProspectDetailFormUpdateListener get _listener => Get.find<ProspectDetailFormUpdateListener>(tag: ProspectString.detailUpdateTag);
  ProspectDetailFormUpdateFormSource get _formSource => Get.find<ProspectDetailFormUpdateFormSource>(tag: ProspectString.detailUpdateTag);
  ProspectDetailFormUpdateProperty get _properties => Get.find<ProspectDetailFormUpdateProperty>(tag: ProspectString.detailUpdateTag);

  final Rx<List<KeyableDropdownItem<int, DBType>>> _categoryItems = Rx<List<KeyableDropdownItem<int, DBType>>>([]);
  set categoryItems(List<KeyableDropdownItem<int, DBType>> value) => _categoryItems.value = value;
  List<KeyableDropdownItem<int, DBType>> get categoryItems => _categoryItems.value;

  final Rx<List<KeyableDropdownItem<int, DBType>>> _typeItems = Rx<List<KeyableDropdownItem<int, DBType>>>([]);
  set typeItems(List<KeyableDropdownItem<int, DBType>> value) => _typeItems.value = value;
  List<KeyableDropdownItem<int, DBType>> get typeItems => _typeItems.value;

  final Rx<List<KeyableDropdownItem<int, DBType>>> _taxItems = Rx<List<KeyableDropdownItem<int, DBType>>>([]);
  set taxItems(List<KeyableDropdownItem<int, DBType>> value) => _taxItems.value = value;
  List<KeyableDropdownItem<int, DBType>> get taxItems => _taxItems.value;

  final Rx<ProspectDetail?> _prospectdetail = Rx<ProspectDetail?>(null);
  set prospectdetail(ProspectDetail? value) => _prospectdetail.value = value;
  ProspectDetail? get prospectdetail => _prospectdetail.value;

  void fetchData(int id) => presenter.fetchData(id);
  void updateData(int id, Map<String, dynamic> data) => presenter.updateData(id, data);

  @override
  ProspectDetailFormUpdatePresenter presenterBuilder() => ProspectDetailFormUpdatePresenter();

  @override
  onLoadError(String message) => _listener.onLoadError(message);

  @override
  onLoadFailed(String message) => _listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['categories'] != null) {
      List<DBType> categories = data['categories'].map<DBType>((item) => DBType.fromJson(item)).toList();
      categoryItems = categories.map<KeyableDropdownItem<int, DBType>>((item) => KeyableDropdownItem<int, DBType>(key: item.typeid!, value: item)).toList();
    }

    if (data['types'] != null) {
      List<DBType> types = data['types'].map<DBType>((item) => DBType.fromJson(item)).toList();
      typeItems = types.map<KeyableDropdownItem<int, DBType>>((item) => KeyableDropdownItem<int, DBType>(key: item.typeid!, value: item)).toList();
    }

    if (data['prospectdetail'] != null) {
      prospectdetail = ProspectDetail.fromJson(data['prospectdetail']);
      _formSource.prepareFormValues();
    }
    Get.find<TaskHelper>().loaderPop(_properties.task.name);
  }

  @override
  void onUpdateError(String message) => _listener.onUpdateDataError(message);

  @override
  void onUpdateFailed(String message) => _listener.onUpdateDataFailed(message);

  @override
  void onUpdateSuccess(String message) => _listener.onUpdateDataSuccess(message);
}
