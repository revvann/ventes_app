import 'package:get/get.dart';
import 'package:ventes/app/api/models/prospect_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/app/api/presenters/prospect_competitor_fc_presenter.dart';
import 'package:ventes/app/states/controllers/prospect_competitor_state_controller.dart';
import 'package:ventes/app/states/typedefs/prospect_competitor_fc_typedef.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/api/handler.dart';
import 'package:ventes/core/states/state_data_source.dart';
import 'package:ventes/helpers/task_helper.dart';
import 'package:ventes/utils/utils.dart';

class ProspectCompetitorFormCreateDataSource extends StateDataSource<ProspectCompetitorFormCreatePresenter> with DataSourceMixin {
  final String refTypesID = 'reftypehdr';
  final String prospectID = 'prospecthdr';
  final String createID = 'createhdr';

  late DataHandler<List<DBType>, List, Function()> refTypesHandler;
  late DataHandler<Prospect?, Map<String, dynamic>, Function(int)> prospectHandler;
  late DataHandler<dynamic, String, Function(FormData)> createHandler;

  List<DBType> get refTypes => refTypesHandler.value;
  Prospect? get prospect => prospectHandler.value;

  void _createSuccess(message) {
    Get.find<TaskHelper>().successPush(
      Task(
        createID,
        message: message,
        onFinished: (res) {
          Get.find<ProspectCompetitorStateController>().refreshStates();
          Get.back(id: Views.prospect.index);
        },
      ),
    );
  }

  @override
  void init() {
    super.init();
    refTypesHandler = Utils.createDataHandler(refTypesID, presenter.fetchRefTypes, [], (data) => data.map<DBType>((e) => DBType.fromJson(e)).toList(), onComplete: () {
      if (refTypes.isNotEmpty) {
        formSource.comptreftype = refTypes.firstWhere((element) => element.typename == "Prospect");
      }
    });
    prospectHandler = Utils.createDataHandler(prospectID, presenter.fetchProspect, null, Prospect.fromJson);
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
  ProspectCompetitorFormCreatePresenter presenterBuilder() => ProspectCompetitorFormCreatePresenter();
}
