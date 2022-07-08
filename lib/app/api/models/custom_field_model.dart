import 'package:ventes/app/api/models/business_partner_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/core/api/model.dart';

class CustomField extends Model {
  int? custfid;
  int? custfbpid;
  String? custfname;
  int? custftypeid;
  bool? isinvisiblesidebar;
  bool? onlyinnewprospect;
  int? lastprospectid;
  DBType? custftype;
  BusinessPartner? businesspartner;

  CustomField({
    this.custfid,
    this.custfbpid,
    this.custfname,
    this.custftypeid,
    this.isinvisiblesidebar,
    this.onlyinnewprospect,
    this.lastprospectid,
    this.custftype,
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

  CustomField.fromJson(Map<String, dynamic> json) {
    custfid = json['custfid'];
    custfbpid = json['custfbpid'];
    custfname = json['custfname'];
    custftypeid = json['custftypeid'];
    isinvisiblesidebar = json['isinvisiblesidebar'];
    onlyinnewprospect = json['onlyinnewprospect'];
    lastprospectid = json['lastprospectid'];

    if (json['custftype'] != null) {
      custftype = DBType.fromJson(json['custftype']);
    }

    if (json['businesspartner'] != null) {
      businesspartner = BusinessPartner.fromJson(json['businesspartner']);
    }

    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['custfid'] = custfid;
    data['custfbpid'] = custfbpid;
    data['custfname'] = custfname;
    data['custftypeid'] = custftypeid;
    data['isinvisiblesidebar'] = isinvisiblesidebar;
    data['onlyinnewprospect'] = onlyinnewprospect;
    data['lastprospectid'] = lastprospectid;

    if (custftype != null) {
      data['custftype'] = custftype?.toJson();
    }

    if (businesspartner != null) {
      data['businesspartner'] = businesspartner?.toJson();
    }

    return data;
  }
}
