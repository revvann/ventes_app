import 'package:ventes/app/api/models/customer_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/core/api/model.dart';

class ContactPerson extends Model {
  int? contactpersonid;
  int? contactcustomerid;
  int? contacttypeid;
  String? contactname;
  String? contactvalueid;
  Customer? contactcustomer;
  DBType? contacttype;

  ContactPerson({
    this.contactpersonid,
    this.contactcustomerid,
    this.contacttypeid,
    this.contactvalueid,
    this.contactname,
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
    contactname = json['contactname'];
    contactvalueid = json['contactvalueid'];

    if (json['contactcustomer'] != null) {
      contactcustomer = Customer.fromJson(json['contactcustomer']);
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
    data['contactname'] = contactname;
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
