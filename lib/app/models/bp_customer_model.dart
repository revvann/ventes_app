import 'package:ventes/app/models/business_partner_model.dart';
import 'package:ventes/app/models/customer_model.dart';
import 'package:ventes/core/model.dart';

class BpCustomer extends Model {
  int? sbcid;
  int? sbcbpid;
  int? sbccstmid;
  String? sbccstmname;
  String? sbccstmphone;
  String? sbccstmaddress;
  String? sbccstmpic;
  BusinessPartner? sbcbp;
  Customer? sbccstm;

  ///
  /// radus in meter
  double? radius;

  BpCustomer({
    this.sbcid,
    this.sbcbpid,
    this.sbccstmid,
    this.sbccstmname,
    this.sbccstmphone,
    this.sbccstmaddress,
    this.sbccstmpic,
    this.sbcbp,
    this.sbccstm,
    this.radius,
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

  BpCustomer.fromJson(Map<String, dynamic> json) {
    sbcid = json['sbcid'];
    sbcbpid = json['sbcbpid'];
    sbccstmid = json['sbccstmid'];
    sbccstmname = json['sbccstmname'];
    sbccstmphone = json['sbccstmphone'];
    sbccstmaddress = json['sbccstmaddress'];
    sbccstmpic = json['sbccstmpic'];

    if (json['sbcbp'] != null) {
      sbcbp = BusinessPartner.fromJson(json['sbcbp']);
    }

    if (json['sbccstm'] != null) {
      sbccstm = Customer.fromJson(json['sbccstm']);
    }

    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['sbcid'] = sbcid;
    data['sbcbpid'] = sbcbpid;
    data['sbccstmid'] = sbccstmid;
    data['sbccstmname'] = sbccstmname;
    data['sbccstmphone'] = sbccstmphone;
    data['sbccstmaddress'] = sbccstmaddress;
    data['sbccstmpic'] = sbccstmpic;

    if (data['sbcbp'] != null) {
      data['sbcbp'] = sbcbp?.toJson();
    }

    if (data['sbccstm'] != null) {
      data['sbccstm'] = sbccstm?.toJson();
    }

    return data;
  }
}
