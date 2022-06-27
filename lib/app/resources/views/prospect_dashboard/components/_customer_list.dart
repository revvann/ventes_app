part of 'package:ventes/app/resources/views/prospect_dashboard/prospect_dashboard.dart';

class _CustomerList extends StatelessWidget {
  Controller state = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return HandlerContainer<Function(BpCustomer?)>(
      handlers: [state.dataSource.bpCustomerHandler],
      width: RegularSize.xl,
      builder: (bpCustomer) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (bpCustomer?.sbccstmpic != null) ...[
                Container(
                  width: 75,
                  height: 75,
                  alignment: Alignment.center,
                  child: Image.network(bpCustomer!.sbccstmpic!),
                  decoration: BoxDecoration(
                    color: RegularColor.green,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: RegularSize.s),
              ],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailItem(title: "Name", value: bpCustomer?.sbccstmname ?? "-"),
                    SizedBox(
                      height: RegularSize.s,
                    ),
                    Row(
                      children: [
                        _Tag(bpCustomer?.sbccstmstatus?.typename ?? "Unknown", RegularColor.purple),
                        SizedBox(width: RegularSize.s),
                        _Tag(bpCustomer?.sbccstm?.cstmtype?.typename ?? "Unknown", RegularColor.green),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: RegularSize.s),
          _DetailItem(title: "Phone", value: bpCustomer?.sbccstmphone ?? "-"),
          SizedBox(height: RegularSize.s),
          _DetailItem(title: "Address", value: bpCustomer?.sbccstmaddress ?? "-"),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  Color color;
  String text;
  _Tag(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
        ),
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: RegularSize.s,
        vertical: RegularSize.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(RegularSize.s),
      ),
    );
  }
}
