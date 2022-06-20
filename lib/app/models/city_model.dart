import 'package:ventes/app/models/province_model.dart';
import 'package:ventes/core/api/model.dart';

class City extends Model {
  int? cityid;
  int? cityprovid;
  String? cityname;
  Province? cityprov;

  City({
    this.cityid,
    this.cityname,
    this.cityprovid,
    this.cityprov,
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

  City.fromJson(Map<String, dynamic> json) {
    cityid = json['cityid'];
    cityname = json['cityname'];
    cityprovid = json['cityprovid'];

    if (json['cityprov'] != null) {
      cityprov = Province.fromJson(json['cityprov']);
    }

    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['cityid'] = cityid;
    data['cityname'] = cityname;
    data['cityprovid'] = cityprovid;

    if (cityprov != null) {
      data['cityprov'] = cityprov?.toJson();
    }

    return data;
  }
}
