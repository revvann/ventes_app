import 'package:get/get.dart';
import 'package:ventes/app/api/presenters/prospect_activity_presenter.dart';
import 'package:ventes/app/api/models/prospect_activity_model.dart';
import 'package:ventes/app/api/models/prospect_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/states/controllers/prospect_activity_state_controller.dart';
import 'package:ventes/app/states/typedefs/prospect_activity_typedef.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/utils/utils.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectActivityDataSource extends StateDataSource<ProspectActivityPresenter> with DataSourceMixin {
  final String stagesID = 'stgshdr';
  final String prospectID = 'prospecthdr';
  final String prospectActivitiesID = 'prosdtlshdr';
  final String deleteID = 'deltehdr';
  final String scheduleRefID = 'scherefhdr';

  late DataHandler<List<DBType>, List, Function()> scheduleRefTypesHandler;
  late DataHandler<List<DBType>, List, Function()> stagesHandler;
  late DataHandler<Prospect?, Map<String, dynamic>, Function(int)> prospectHandler;
  late DataHandler<List<ProspectActivity>, List, Function(int)> prospectActivitiesHandler;
  late DataHandler<dynamic, String, Function(int)> deleteHandler;

  Prospect? get prospect => prospectHandler.value;
  List<ProspectActivity> get prospectActivities => prospectActivitiesHandler.value;
  List<DBType> get stages => stagesHandler.value;
  List<DBType> get scheduleRefTypes => scheduleRefTypesHandler.value;
  DBType? get activityRefType => scheduleRefTypes.firstWhereOrNull((element) => element.typename == "Prospect Activity");

  void _deleteSuccess(message) {
    Get.find<TaskHelper>().successPush(Task(deleteID, message: message, onFinished: (res) {
      Get.find<ProspectActivityStateController>().refreshStates();
    }));
  }

  List<ProspectActivity> _prospectActivitiesComplete(data) {
    List<ProspectActivity> activities = data.map<ProspectActivity>((json) => ProspectActivity.fromJson(json)).toList();
    activities.removeWhere((element) => Utils.dbParseDate(element.prospectactivitydate!).isAfter(DateTime.now()));
    return activities;
  }

  @override
  void init() {
    super.init();
    scheduleRefTypesHandler = Utils.createDataHandler(scheduleRefID, presenter.fetchScheduleRefTypes, [], (data) => data.map<DBType>((json) => DBType.fromJson(json)).toList());
    stagesHandler = Utils.createDataHandler(stagesID, presenter.fetchStages, [], (data) => data.map<DBType>((json) => DBType.fromJson(json)).toList());
    prospectHandler = Utils.createDataHandler(prospectID, presenter.fetchProspect, null, (data) => Prospect.fromJson(data));
    prospectActivitiesHandler = Utils.createDataHandler(prospectActivitiesID, presenter.fetchProspectActivities, [], _prospectActivitiesComplete);
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
}
