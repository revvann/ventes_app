import 'package:ventes/app/models/regular_model.dart';

class DBType extends RegularModel {
  int? typeid;
  String? typename;
  String? typecd;
  int? typeseq;
  int? typemasterid;
  String? typedesc;

  DBType({
    this.typeid,
    this.typename,
    this.typecd,
    this.typedesc,
    String? createddate,
    String? updateddate,
    int? createdby,
    int? updatedby,
    bool? isactive,
  }) : super(
          createdby: createdby,
          updatedby: updatedby,
          createddate: createddate,
          updateddate: updateddate,
          isactive: isactive,
        );

  DBType.fromJson(Map<String, dynamic> json) {
    typeid = json['typeid'];
    typename = json['typename'];
    typecd = json['typecd'];
    typeseq = json['typeseq'];
    typedesc = json['typedesc'];
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['typeid'] = typeid;
    data['typename'] = typename;
    data['typecd'] = typecd;
    data['typedesc'] = typedesc;
    return data;
  }
}
