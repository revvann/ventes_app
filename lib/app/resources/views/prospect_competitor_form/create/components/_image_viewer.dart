part of 'package:ventes/app/resources/views/prospect_competitor_form/create/prospect_competitor_fc.dart';

class _ImageViewer extends StatelessWidget {
  Controller state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Obx(() {
            return ListView.builder(
              itemCount: state.formSource.firstHalfImages.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                File file = state.formSource.firstHalfImages[index];
                return Padding(
                  padding: EdgeInsets.all(RegularSize.xs),
                  child: Image.file(file),
                );
              },
            );
          }),
        ),
        Expanded(
          child: Obx(() {
            return ListView.builder(
              itemCount: state.formSource.secondHalfImages.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                File file = state.formSource.secondHalfImages[index];
                return Padding(
                  padding: EdgeInsets.all(RegularSize.xs),
                  child: Image.file(file),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
