import 'package:ventes/app/api/models/type_model.dart';
import 'package:ventes/core/api/model.dart';

class Files extends Model {
  int? fileid;
  int? transtypeid;
  int? refid;
  String? directories;
  String? filename;
  String? mimetype;
  String? filesize;
  String? url;
  DBType? transtype;

  Files({
    this.fileid,
    this.transtypeid,
    this.refid,
    this.directories,
    this.filename,
    this.mimetype,
    this.filesize,
    this.url,
    this.transtype,
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

  Files.fromJson(Map<String, dynamic> json) {
    fileid = json['fileid'];
    transtypeid = json['transtypeid'];
    refid = json['refid'];
    directories = json['directories'];
    filename = json['filename'];
    mimetype = json['mimetype'];
    filesize = json['filesize'];
    url = json['url'];

    if (json['transtype'] != null) {
      transtype = DBType.fromJson(json['transtype']);
    }

    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['fileid'] = fileid;
    data['transtypeid'] = transtypeid;
    data['refid'] = refid;
    data['directories'] = directories;
    data['filename'] = filename;
    data['mimetype'] = mimetype;
    data['filesize'] = filesize;

    if (transtype != null) {
      data['transtype'] = transtype?.toJson();
    }

    return data;
  }
}
