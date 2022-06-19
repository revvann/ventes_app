import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/prospect_detail_fc_presenter.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/resources/widgets/keyable_dropdown.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/app/states/typedefs/prospect_detail_fc_typedef.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectDetailFormCreateDataSource extends StateDataSource<ProspectDetailFormCreatePresenter> implements ProspectDetailCreateContract {
  Listener get _listener => Get.find<Listener>(tag: ProspectString.detailCreateTag);
  FormSource get _formSource => Get.find<FormSource>(tag: ProspectString.detailCreateTag);
  Property get _property => Get.find<Property>(tag: ProspectString.detailCreateTag);

  final Rx<List<KeyableDropdownItem<int, DBType>>> _categoryItems = Rx<List<KeyableDropdownItem<int, DBType>>>([]);
  set categoryItems(List<KeyableDropdownItem<int, DBType>> value) => _categoryItems.value = value;
  List<KeyableDropdownItem<int, DBType>> get categoryItems => _categoryItems.value;

  final Rx<List<KeyableDropdownItem<int, DBType>>> _typeItems = Rx<List<KeyableDropdownItem<int, DBType>>>([]);
  set typeItems(List<KeyableDropdownItem<int, DBType>> value) => _typeItems.value = value;
  List<KeyableDropdownItem<int, DBType>> get typeItems => _typeItems.value;

  final Rx<Prospect?> _prospect = Rx<Prospect?>(null);
  set prospect(Prospect? value) => _prospect.value = value;
  Prospect? get prospect => _prospect.value;

  void fetchData(int id) => presenter.fetchData(id);
  void createData(Map<String, dynamic> data) => presenter.createData(data);

  @override
  ProspectDetailFormCreatePresenter presenterBuilder() => ProspectDetailFormCreatePresenter();

  @override
  onLoadError(String message) => _listener.onLoadError(message);

  @override
  onLoadFailed(String message) => _listener.onLoadFailed(message);

  @override
  onLoadSuccess(Map data) {
    if (data['categories'] != null) {
      List<DBType> categories = data['categories'].map<DBType>((item) => DBType.fromJson(item)).toList();
      _formSource.prosdtcategory = categories.isNotEmpty ? categories.first : null;
      categoryItems = categories.map<KeyableDropdownItem<int, DBType>>((item) => KeyableDropdownItem<int, DBType>(key: item.typeid!, value: item)).toList();
    }

    if (data['types'] != null) {
      List<DBType> types = data['types'].map<DBType>((item) => DBType.fromJson(item)).toList();
      _formSource.prosdttype = types.isNotEmpty ? types.first : null;
      typeItems = types.map<KeyableDropdownItem<int, DBType>>((item) => KeyableDropdownItem<int, DBType>(key: item.typeid!, value: item)).toList();
    }

    if (data['prospect'] != null) {
      prospect = Prospect.fromJson(data['prospect']);
      _formSource.prospect = prospect;
    }
    Get.find<TaskHelper>().loaderPop(_property.task.name);
  }

  @override
  void onCreateError(String message) => _listener.onCreateDataError(message);

  @override
  void onCreateFailed(String message) => _listener.onCreateDataFailed(message);

  @override
  void onCreateSuccess(String message) => _listener.onCreateDataSuccess(message);
}
