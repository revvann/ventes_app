part of 'package:ventes/app/resources/views/prospect_competitor_form/update/prospect_competitor_fu.dart';

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
              itemCount: state.formSource.images.isNotEmpty ? state.formSource.firstHalfImages.length : state.dataSource.firstHalfImages.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                Widget image;
                if (state.formSource.images.isNotEmpty) {
                  File file = state.formSource.firstHalfImages[index];
                  image = Image.file(file);
                } else {
                  Files file = state.dataSource.firstHalfImages[index];
                  image = Image.network(file.url!);
                }
                return Padding(
                  padding: EdgeInsets.all(RegularSize.xs),
                  child: image,
                );
              },
            );
          }),
        ),
        Expanded(
          child: Obx(() {
            return ListView.builder(
              itemCount: state.formSource.images.isNotEmpty ? state.formSource.secondHalfImages.length : state.dataSource.secondHalfImages.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                Widget image;
                if (state.formSource.images.isNotEmpty) {
                  File file = state.formSource.secondHalfImages[index];
                  image = Image.file(file);
                } else {
                  Files file = state.dataSource.secondHalfImages[index];
                  image = Image.network(file.url!);
                }
                return Padding(
                  padding: EdgeInsets.all(RegularSize.xs),
                  child: image,
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
