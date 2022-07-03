import 'package:ventes/app/api/models/business_partner_model.dart';
import 'package:ventes/core/api/model.dart';

class Product extends Model {
  int? productid;
  String? productname;
  int? productbpid;
  BusinessPartner? businesspartner;

  Product({
    this.productid,
    this.productname,
    this.productbpid,
    this.businesspartner,
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

  Product.fromJson(Map<String, dynamic> json) {
    productid = json['productid'];
    productname = json['productname'];
    productbpid = json['productbpid'];

    if (json['businesspartner'] != null) {
      businesspartner = BusinessPartner.fromJson(json['businesspartner']);
    }

    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['productid'] = productid;
    data['productname'] = productname;
    data['productbpid'] = productbpid;

    if (businesspartner != null) {
      data['businesspartner'] = businesspartner?.toJson();
    }

    return data;
  }
}
