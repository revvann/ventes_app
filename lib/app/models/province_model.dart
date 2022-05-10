import 'package:ventes/app/models/country_model.dart';
import 'package:ventes/core/model.dart';

class Province extends Model {
  int? provid;
  int? provcountryid;
  String? provname;
  Country? provcountry;

  Province({
    this.provid,
    this.provname,
    this.provcountryid,
    this.provcountry,
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

  Province.fromJson(Map<String, dynamic> json) {
    provid = json['provid'];
    provname = json['provname'];
    provcountryid = json['provcountryid'];

    if (json['provcountry'] != null) {
      provcountry = Country.fromJson(json['provcountry']);
    }

    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['provid'] = provid;
    data['provname'] = provname;
    data['provcountryid'] = provcountryid;

    if (provcountry != null) {
      data['provcountry'] = provcountry?.toJson();
    }

    return data;
  }
}
