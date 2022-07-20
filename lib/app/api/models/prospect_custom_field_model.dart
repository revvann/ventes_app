import 'package:ventes/app/api/models/custom_field_model.dart';
import 'package:ventes/app/api/models/prospect_model.dart';
import 'package:ventes/core/api/model.dart';

class ProspectCustomField extends Model {
  int? prospectcfid;
  int? prospectid;
  int? prospectcustfid;
  String? prospectcfvalue;
  CustomField? customfield;
  Prospect? prospect;

  ProspectCustomField({
    this.prospectcfid,
    this.prospectid,
    this.prospectcustfid,
    this.prospectcfvalue,
    this.customfield,
    this.prospect,
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

  ProspectCustomField.fromJson(Map<String, dynamic> json) {
    prospectcfid = json['prospectcfid'];
    prospectid = json['prospectid'];
    prospectcustfid = json['prospectcustfid'];
    prospectcfvalue = json['prospectcfvalue'];

    if (json['customfield'] != null) {
      customfield = CustomField.fromJson(json['customfield']);
    }

    if (json['prospect'] != null) {
      prospect = Prospect.fromJson(json['prospect']);
    }

    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['prospectcfid'] = prospectcfid;
    data['prospectid'] = prospectid;
    data['prospectcustfid'] = prospectcustfid;
    data['prospectcfvalue'] = prospectcfvalue;

    if (customfield != null) {
      data['customfield'] = customfield?.toJson();
    }

    if (prospect != null) {
      data['prospect'] = prospect?.toJson();
    }

    return data;
  }
}
