import 'package:get/get.dart';
import 'package:ventes/app/states/typedefs/prospect_competitor_fu_typedef.dart';
import 'package:ventes/constants/strings/prospect_string.dart';
import 'package:ventes/constants/views.dart';
import 'package:ventes/core/states/state_listener.dart';
import 'package:ventes/helpers/task_helper.dart';

class ProspectCompetitorFormUpdateListener extends StateListener with ListenerMixin {
  void goBack() {
    Get.back(
      id: Views.prospect.index,
    );
  }

  void onSubmitButtonClicked() {
    Get.find<TaskHelper>().confirmPush(
      Task<bool>(
        'submitform',
        message: ProspectString.updateCompetitorConfirm,
        onFinished: (res) {
          if (res) {
            formSource.onSubmit();
          }
        },
      ),
    );
  }

  @override
  Future onReady() async {
    property.refresh();
  }
}
