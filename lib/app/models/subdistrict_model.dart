import 'package:ventes/app/models/city_model.dart';
import 'package:ventes/app/models/regular_model.dart';

class Subdistrict extends RegularModel {
  int? subdistrictid;
  int? subdistrictcityid;
  String? subdistrictname;
  City? subdistrictcity;

  Subdistrict({
    this.subdistrictid,
    this.subdistrictname,
    this.subdistrictcityid,
    this.subdistrictcity,
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

  Subdistrict.fromJson(Map<String, dynamic> json) {
    subdistrictid = json['subdistrictid'];
    subdistrictname = json['subdistrictname'];
    subdistrictcityid = json['subdistrictcityid'];

    if (json['subdistrictcity'] != null) {
      subdistrictcity = City.fromJson(json['subdistrictcity']);
    }

    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['subdistrictid'] = subdistrictid;
    data['subdistrictname'] = subdistrictname;
    data['subdistrictcityid'] = subdistrictcityid;

    if (subdistrictcity != null) {
      data['subdistrictcity'] = subdistrictcity?.toJson();
    }

    return data;
  }
}
