import 'package:get/get.dart';
import 'package:ventes/app/api/models/competitor_model.dart';
import 'package:ventes/app/api/models/prospect_model.dart';
import 'package:ventes/app/api/presenters/prospect_competitor_fu_presenter.dart';
import 'package:ventes/app/states/controllers/prospect_competitor_state_controller.dart';
import 'package:ventes/app/states/typedefs/prospect_competitor_fu_typedef.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/utils/utils.dart';

class ProspectCompetitorFormUpdateDataSource extends StateDataSource<ProspectCompetitorFormUpdatePresenter> with DataSourceMixin {
  final String competitorID = 'competitorhdr';
  final String prospectID = 'prospecthdr';
  final String updateID = 'updatehdr';

  late DataHandler<Competitor?, Map<String, dynamic>, Function(int)> competitorHandler;
  late DataHandler<Prospect?, Map<String, dynamic>, Function(int)> prospectHandler;
  late DataHandler<dynamic, String, Function(int, Map<String, dynamic>)> updateHandler;

  Prospect? get prospect => prospectHandler.value;
  Competitor? get competitor => competitorHandler.value;

  void _updateSuccess(message) {
    Get.find<TaskHelper>().successPush(
      Task(
        updateID,
        message: message,
        onFinished: (res) {
          Get.find<ProspectCompetitorStateController>().refreshStates();
          Get.back(id: Views.prospect.index);
        },
      ),
    );
  }

  void _competitorComplete() {
    prospectHandler.fetcher.run(competitor!.comptrefid!);
    formSource.prepareFormValues();
  }

  @override
  void init() {
    super.init();
    competitorHandler = Utils.createDataHandler(competitorID, presenter.fetchCompetitor, null, Competitor.fromJson, onComplete: _competitorComplete);
    prospectHandler = Utils.createDataHandler(prospectID, presenter.fetchProspect, null, Prospect.fromJson);
    updateHandler = DataHandler(
      updateID,
      fetcher: presenter.update,
      initialValue: null,
      onStart: () => Get.find<TaskHelper>().loaderPush(Task(updateID)),
      onSuccess: _updateSuccess,
      onFailed: (message) => Utils.showFailed(updateID, message, false),
      onError: (message) => Utils.showError(updateID, message),
      onComplete: () => Get.find<TaskHelper>().loaderPop(updateID),
    );
  }

  @override
  ProspectCompetitorFormUpdatePresenter presenterBuilder() => ProspectCompetitorFormUpdatePresenter();
}
