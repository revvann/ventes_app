import 'package:ventes/app/api/models/subdistrict_model.dart';
import 'package:ventes/core/api/model.dart';

class Village extends Model {
  int? villageid;
  int? villagesubdistrictid;
  String? villagename;
  Subdistrict? villagesubdistrict;

  Village({
    this.villageid,
    this.villagename,
    this.villagesubdistrictid,
    this.villagesubdistrict,
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

  Village.fromJson(Map<String, dynamic> json) {
    villageid = json['villageid'];
    villagename = json['villagename'];
    villagesubdistrictid = json['villagesubdistrictid'];

    if (json['villagesubdistrict'] != null) {
      villagesubdistrict = Subdistrict.fromJson(json['villagesubdistrict']);
    }

    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['villageid'] = villageid;
    data['villagename'] = villagename;
    data['villagesubdistrictid'] = villagesubdistrictid;

    if (villagesubdistrict != null) {
      data['villagesubdistrict'] = villagesubdistrict?.toJson();
    }

    return data;
  }
}
