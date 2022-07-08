import 'package:ventes/app/api/models/business_partner_model.dart';
import 'package:ventes/app/api/models/files_model.dart';
import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/core/api/model.dart';

class Competitor extends Model {
  int? comptid;
  int? comptbpid;
  int? comptreftypeid;
  int? comptrefid;
  String? comptname;
  String? comptproductname;
  String? description;
  BusinessPartner? comptbp;
  DBType? comptreftype;
  List<Files>? comptpics;

  Competitor({
    this.comptid,
    this.comptbpid,
    this.comptreftypeid,
    this.comptrefid,
    this.comptname,
    this.comptproductname,
    this.description,
    this.comptbp,
    this.comptreftype,
    this.comptpics,
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

  Competitor.fromJson(Map<String, dynamic> json) {
    comptid = json['comptid'];
    comptbpid = json['comptbpid'];
    comptreftypeid = json['comptreftypeid'];
    comptrefid = json['comptrefid'];
    comptname = json['comptname'];
    comptproductname = json['comptproductname'];
    description = json['description'];

    if (json['comptbp'] != null) {
      comptbp = BusinessPartner.fromJson(json['comptbp']);
    }

    if (json['comptreftype'] != null) {
      comptreftype = DBType.fromJson(json['comptreftype']);
    }

    if (json['comptpics'] != null) {
      comptpics = json['comptpics'].map<Files>((e) => Files.fromJson(e)).toList();
    }

    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['comptid'] = comptid;
    data['comptbpid'] = comptbpid;
    data['comptreftypeid'] = comptreftypeid;
    data['comptrefid'] = comptrefid;
    data['comptname'] = comptname;
    data['comptproductname'] = comptproductname;
    data['description'] = description;

    if (comptbp != null) {
      data['comptbp'] = comptbp?.toJson();
    }

    if (comptreftype != null) {
      data['comptreftype'] = comptreftype?.toJson();
    }

    return data;
  }
}
