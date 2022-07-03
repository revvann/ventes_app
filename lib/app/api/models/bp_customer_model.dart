import 'package:ventes/app/api/models/business_partner_model.dart';
import 'package:ventes/app/api/models/customer_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/core/api/model.dart';

class BpCustomer extends Model {
  int? sbcid;
  int? sbcbpid;
  int? sbccstmid;
  String? sbccstmname;
  String? sbccstmphone;
  String? sbccstmaddress;
  String? sbccstmpic;
  int? sbccstmstatusid;
  DBType? sbccstmstatus;
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
    this.sbccstmstatusid,
    this.sbccstmstatus,
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
    sbccstmstatusid = json['sbccstmstatusid'];

    if (json['sbcbp'] != null) {
      sbcbp = BusinessPartner.fromJson(json['sbcbp']);
    }

    if (json['sbccstm'] != null) {
      sbccstm = Customer.fromJson(json['sbccstm']);
    }

    if (json['sbccstmstatus'] != null) {
      sbccstmstatus = DBType.fromJson(json['sbccstmstatus']);
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
    data['sbccstmstatusid'] = sbccstmstatusid;

    if (sbcbp != null) {
      data['sbcbp'] = sbcbp?.toJson();
    }

    if (sbccstm != null) {
      data['sbccstm'] = sbccstm?.toJson();
    }

    if (sbccstmstatus != null) {
      data['sbccstmstatus'] = sbccstmstatus?.toJson();
    }

    return data;
  }
}
