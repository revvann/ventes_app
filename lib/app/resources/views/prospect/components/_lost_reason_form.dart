part of 'package:ventes/app/resources/views/prospect/prospect.dart';

class _LostReasonForm {
  Controller state = Get.find<Controller>();
  Future<Map<String, dynamic>?> show() async {
    Map<String, dynamic>? data;
    await RegularDialog(
      width: Get.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Lost Reason",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: RegularColor.dark,
            ),
          ),
          SizedBox(
            height: RegularSize.m,
          ),
          _ReasonDropdown(),
          SizedBox(
            height: RegularSize.s,
          ),
          EditorInput(
            label: "Description",
            hintText: "Enter description",
            controller: state.formSource.lostDescriptionTEC,
          ),
          SizedBox(
            height: RegularSize.m,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Get.close(1);
                },
                style: TextButton.styleFrom(
                  primary: RegularColor.red,
                ),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: RegularColor.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  data = {
                    'prospectlostreasonid': state.formSource.lostReason?.typeid,
                    'prospectlostdesc': state.formSource.lostDescriptionTEC.text,
                  };
                  Get.close(1);
                },
                style: TextButton.styleFrom(
                  primary: RegularColor.green,
                ),
                child: Text(
                  "Okay",
                  style: TextStyle(
                    color: RegularColor.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).show();
    state.formSource.lostDescriptionTEC.clear();
    state.formSource.reasonDropdownController.reset();
    return data;
  }
}
