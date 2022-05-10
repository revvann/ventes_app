import 'package:ventes/core/model.dart';

class Country extends Model {
  int? countryid;
  String? countryname;

  Country({
    this.countryid,
    this.countryname,
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

  Country.fromJson(Map<String, dynamic> json) {
    countryid = json['countryid'];
    countryname = json['countryname'];

    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['countryid'] = countryid;
    data['countryname'] = countryname;

    return data;
  }
}
