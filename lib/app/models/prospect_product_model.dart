import 'package:ventes/app/models/prospect_model.dart';
import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/core/model.dart';

class ProspectProduct extends Model {
  int? prosproductid;
  int? prosproductprospectid;
  double? prosproductprice;
  int? prosproductqty;
  double? prosproducttax;
  double? prosproductdiscount;
  double? prosproductamount;
  int? prosproducttaxtypeid;
  Prospect? prosproductprospect;
  DBType? prosproducttaxtype;

  ProspectProduct({
    this.prosproductid,
    this.prosproductprospectid,
    this.prosproductprice,
    this.prosproductqty,
    this.prosproducttax,
    this.prosproductdiscount,
    this.prosproductamount,
    this.prosproducttaxtypeid,
    this.prosproductprospect,
    this.prosproducttaxtype,
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

    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['prosproductid'] = prosproductid;
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

    return data;
  }
}
