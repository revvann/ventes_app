part of 'package:ventes/app/resources/views/prospect_competitor/prospect_competitor.dart';

class _CompetitorDetail {
  Competitor competitor;
  _CompetitorDetail(this.competitor);

  List<Files> get secondHalfImages {
    int start = 0;
    int end = start + (competitor.comptpics?.length ?? 0) ~/ 2;
    return competitor.comptpics?.sublist(start, end) ?? [];
  }

  List<Files> get firstHalfImages {
    int start = (competitor.comptpics?.length ?? 0) ~/ 2;
    int end = start + ((competitor.comptpics?.length ?? 0) ~/ 2 + (competitor.comptpics?.length ?? 0) % 2);
    return competitor.comptpics?.sublist(start, end) ?? [];
  }

  Future show() {
    return RegularDialog(
      width: Get.width * 0.9,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        vertical: RegularSize.m,
        horizontal: RegularSize.m,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              competitor.comptname ?? "",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: RegularColor.dark,
              ),
            ),
            SizedBox(
              height: RegularSize.m,
            ),
            _DetailItem(title: "Product Name", value: competitor.comptproductname ?? "-"),
            SizedBox(
              height: RegularSize.m,
            ),
            _DetailItem(title: "Description", value: competitor.description ?? "-"),
            SizedBox(
              height: RegularSize.m,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: firstHalfImages.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      Files file = firstHalfImages[index];
                      Widget image = Image.network(file.url!);
                      return Padding(
                        padding: EdgeInsets.all(RegularSize.xs),
                        child: image,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: secondHalfImages.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      Files file = secondHalfImages[index];
                      Widget image = Image.network(file.url!);
                      return Padding(
                        padding: EdgeInsets.all(RegularSize.xs),
                        child: image,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).show();
  }
}

class _DetailItem extends StatelessWidget {
  String title;
  String value;
  Color color;

  _DetailItem({
    required this.title,
    required this.value,
    this.color = RegularColor.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(
          height: RegularSize.xs,
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: color,
          ),
        ),
      ],
    );
  }
}
