import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/prospect_activity_presenter.dart';
import 'package:ventes/app/models/prospect_activity_model.dart';
import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/app/states/controllers/prospect_activity_state_controller.dart';
import 'package:ventes/app/states/typedefs/prospect_activity_typedef.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/function_helpers.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectActivityDataSource extends StateDataSource<ProspectActivityPresenter> with DataSourceMixin {
  final String stagesID = 'stgshdr';
  final String prospectID = 'prospecthdr';
  final String prospectActivitiesID = 'prosdtlshdr';
  final String deleteID = 'deltehdr';

  late DataHandler<List<DBType>, List, Function()> stagesHandler;
  late DataHandler<Prospect?, Map<String, dynamic>, Function(int)> prospectHandler;
  late DataHandler<List<ProspectActivity>, List, Function(int)> prospectActivitiesHandler;
  late DataHandler<dynamic, String, Function(int)> deleteHandler;

  Prospect? get prospect => prospectHandler.value;
  List<ProspectActivity> get prospectActivities => prospectActivitiesHandler.value;
  List<DBType> get stages => stagesHandler.value;

  void _deleteSuccess(message) {
    Get.find<TaskHelper>().successPush(Task(deleteID, message: message, onFinished: (res) {
      Get.find<ProspectActivityStateController>().refreshStates();
    }));
  }

  @override
  void init() {
    super.init();
    stagesHandler = createDataHandler(stagesID, presenter.fetchStages, [], (data) => data.map<DBType>((json) => DBType.fromJson(json)).toList());
    prospectHandler = createDataHandler(prospectID, presenter.fetchProspect, null, (data) => Prospect.fromJson(data));
    prospectActivitiesHandler =
        createDataHandler(prospectActivitiesID, presenter.fetchProspectActivities, [], (data) => data.map<ProspectActivity>((json) => ProspectActivity.fromJson(json)).toList());
    deleteHandler = DataHandler(
      deleteID,
      fetcher: presenter.delete,
      initialValue: null,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(deleteID)),
      onSuccess: _deleteSuccess,
      onFailed: (message) => Get.find<TaskHelper>().failedPush(Task(deleteID, message: message)),
      onError: (message) => Get.find<TaskHelper>().errorPush(Task(deleteID, message: message)),
      onComplete: () => Get.find<TaskHelper>().loaderPop(deleteID),
    );
  }

  @override
  ProspectActivityPresenter presenterBuilder() => ProspectActivityPresenter();

  @override
  onLoadError(String message) {}

  @override
  onLoadFailed(String message) {}

  @override
  onLoadSuccess(Map data) {}

  @override
  void onDeleteError(String message) {}

  @override
  void onDeleteFailed(String message) {}

  @override
  void onDeleteSuccess(String message) {}

  @override
  void onDeleteComplete() {}

  @override
  onLoadComplete() {}
}
