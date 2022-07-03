import 'package:ventes/app/api/models/product_model.dart';
import 'package:ventes/app/api/models/prospect_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/core/api/model.dart';

class ProspectProduct extends Model {
  int? prosproductid;
  int? prosproductprospectid;
  int? prosproductproductid;
  double? prosproductprice;
  int? prosproductqty;
  double? prosproducttax;
  double? prosproductdiscount;
  double? prosproductamount;
  int? prosproducttaxtypeid;
  Prospect? prosproductprospect;
  DBType? prosproducttaxtype;
  Product? prosproductproduct;

  ProspectProduct({
    this.prosproductid,
    this.prosproductproductid,
    this.prosproductprospectid,
    this.prosproductprice,
    this.prosproductqty,
    this.prosproducttax,
    this.prosproductdiscount,
    this.prosproductamount,
    this.prosproducttaxtypeid,
    this.prosproductprospect,
    this.prosproducttaxtype,
    this.prosproductproduct,
    String? createddate,
    String? updateddate,
    int? createdby,
    int? updatedby,
    bool? isactive,
  }) : super(
          createddate: createddate,
          createdby: createdby,
          updateddate: updateddate,
          updatedby: updatedby,
          isactive: isactive,
        );

  ProspectProduct.fromJson(Map<String, dynamic> json) {
    prosproductid = json['prosproductid'];
    prosproductproductid = json['prosproductproductid'];
    prosproductprospectid = json['prosproductprospectid'];
    prosproductprice = json['prosproductprice'] is String ? double.tryParse(json['prosproductprice']) : json['prosproductprice'];
    prosproductqty = json['prosproductqty'];
    prosproducttax = json['prosproducttax'] is String ? double.tryParse(json['prosproducttax']) : json['prosproducttax'];
    prosproductdiscount = json['prosproductdiscount'] is String ? double.tryParse(json['prosproductdiscount']) : json['prosproductdiscount'];
    prosproductamount = json['prosproductamount'] is String ? double.tryParse(json['prosproductamount']) : json['prosproductamount'];
    prosproducttaxtypeid = json['prosproducttaxtypeid'];

    if (json['prosproductprospect'] != null) {
      prosproductprospect = Prospect.fromJson(json['prosproductprospect']);
    }

    if (json['prosproducttaxtype'] != null) {
      prosproducttaxtype = DBType.fromJson(json['prosproducttaxtype']);
    }

    if (json['prosproductproduct'] != null) {
      prosproductproduct = Product.fromJson(json['prosproductproduct']);
    }

    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['prosproductid'] = prosproductid;
    data['prosproductproductid'] = prosproductproductid;
    data['prosproductprospectid'] = prosproductprospectid;
    data['prosproductprice'] = prosproductprice;
    data['prosproductqty'] = prosproductqty;
    data['prosproducttax'] = prosproducttax;
    data['prosproductdiscount'] = prosproductdiscount;
    data['prosproductamount'] = prosproductamount;
    data['prosproducttaxtypeid'] = prosproducttaxtypeid;

    if (prosproductprospect != null) {
      data['prosproductprospect'] = prosproductprospect?.toJson();
    }

    if (prosproducttaxtype != null) {
      data['prosproducttaxtype'] = prosproducttaxtype?.toJson();
    }

    if (prosproductproduct != null) {
      data['prosproductproduct'] = prosproductproduct?.toJson();
    }

    return data;
  }
}
