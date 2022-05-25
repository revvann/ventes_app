import 'package:ventes/app/models/bp_customer_model.dart';
import 'package:ventes/app/models/type_model.dart';
import 'package:ventes/core/model.dart';

class ContactPerson extends Model {
  int? contactpersonid;
  int? contactcustomerid;
  int? contacttypeid;
  int? contactvalueid;
  BpCustomer? contactcustomer;
  DBType? contacttype;

  ContactPerson({
    this.contactpersonid,
    this.contactcustomerid,
    this.contacttypeid,
    this.contactvalueid,
    this.contactcustomer,
    this.contacttype,
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

  ContactPerson.fromJson(Map<String, dynamic> json) {
    contactpersonid = json['contactpersonid'];
    contactcustomerid = json['contactcustomerid'];
    contacttypeid = json['contacttypeid'];
    contactvalueid = json['contactvalueid'];

    if (json['contactcustomer'] != null) {
      contactcustomer = BpCustomer.fromJson(json['contactcustomer']);
    }

    if (json['contacttype'] != null) {
      contacttype = DBType.fromJson(json['contacttype']);
    }

    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['contactpersonid'] = contactpersonid;
    data['contactcustomerid'] = contactcustomerid;
    data['contacttypeid'] = contacttypeid;
    data['contactvalueid'] = contactvalueid;

    if (contactcustomer != null) {
      data['contactcustomer'] = contactcustomer?.toJson();
    }

    if (contacttype != null) {
      data['contacttype'] = contacttype?.toJson();
    }

    return data;
  }
}
