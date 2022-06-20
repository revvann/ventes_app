part of 'package:ventes/app/states/controllers/product_fu_state_controller.dart';

class _FormSource extends UpdateFormSource {
  _DataSource get _dataSource => Get.find<_DataSource>(tag: ProspectString.productUpdateTag);
  _Properties get _properties => Get.find<_Properties>(tag: ProspectString.productUpdateTag);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  _Validator validator = _Validator();

  TextEditingController nameTEC = TextEditingController();
  TextEditingController priceTEC = TextEditingController();
  TextEditingController qtyTEC = TextEditingController();
  TextEditingController discTEC = TextEditingController();
  TextEditingController taxTEC = TextEditingController();

  KeyableDropdownController<int, DBType> taxDropdownController = Get.put(
    KeyableDropdownController<int, DBType>(),
    tag: ProspectString.taxDropdownTag,
  );

  final _prosproducttax = Rx<DBType?>(null);
  DBType? get prosproducttax => _prosproducttax.value;
  set prosproducttax(DBType? value) => _prosproducttax.value = value;

  bool get isValid => formKey.currentState?.validate() ?? false;

  String get prosproductname => nameTEC.text;
  String get prosproductprice => priceTEC.text;
  String get prosproductqty => qtyTEC.text;
  String get prosproductdiscount => discTEC.text;
  String get prosproducttaxstring => taxTEC.text;

  @override
  void prepareFormValues() {
    nameTEC.text = _dataSource.product?.prosproductproduct?.productname ?? "";
    priceTEC.text = currencyFormat(_dataSource.product?.prosproductprice?.toString().replaceAll('.', ',') ?? "");
    qtyTEC.text = _dataSource.product?.prosproductqty?.toString().replaceAll('.', ',') ?? "";
    discTEC.text = _dataSource.product?.prosproductdiscount?.toString().replaceAll('.', ',') ?? "";
    taxTEC.text = currencyFormat(_dataSource.product?.prosproducttax?.toString().replaceAll('.', ',') ?? "");
    prosproducttax = _dataSource.product?.prosproducttaxtype;
    taxDropdownController.selectedKeys = prosproducttax != null ? [prosproducttax!.typeid!] : [];
  }

  @override
  Map<String, dynamic> toJson() {
    String priceString = priceTEC.text.replaceAll(RegExp(r'[.]'), '').replaceAll(RegExp(r'[,]'), '.');
    String qtyString = qtyTEC.text.replaceAll(RegExp(r'[.]'), '').replaceAll(RegExp(r'[,]'), '.');
    String taxString = taxTEC.text.replaceAll(RegExp(r'[.]'), '').replaceAll(RegExp(r'[,]'), '.');
    String discString = discTEC.text.replaceAll(RegExp(r'[.]'), '').replaceAll(RegExp(r'[,]'), '.');

    double price = double.tryParse(priceString) ?? 0;
    double qty = double.tryParse(qtyString) ?? 0;

    double total = price * qty;

    return {
      'productname': prosproductname,
      'prosproductprice': priceString,
      'prosproductqty': qtyString,
      'prosproducttax': taxString,
      'prosproductdiscount': discString,
      'prosproductamount': total.toString(),
      'prosproducttaxtypeid': prosproducttax?.typeid.toString(),
    };
  }

  @override
  void onSubmit() {
    if (isValid) {
      Map<String, dynamic> data = toJson();
      _dataSource.updateData(_properties.productid, data);
      Get.find<TaskHelper>().loaderPush(_properties.task);
    } else {
      Get.find<TaskHelper>().failedPush(_properties.task.copyWith(message: "Please fill all required fields"));
    }
  }
}
