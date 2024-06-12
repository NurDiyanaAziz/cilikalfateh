class YuranModel {
  String pendaftaranTahunan;
  String pendaftaranPeralatan;
  String pendaftaranProgram;
  String pendaftaranTakaful;
  String uniformP;
  String uniformL;
  String bulananPagi;
  String bulananPagiPetang;

  YuranModel({
    this.pendaftaranTahunan = '',
    this.pendaftaranPeralatan = '',
    this.pendaftaranProgram = '',
    this.pendaftaranTakaful = '',
    this.uniformL = '',
    this.uniformP = '',
    this.bulananPagi = '',
    this.bulananPagiPetang = '',
  });

  //add to firebase
  Map<String, dynamic> toJson() {
    return {
      'pendaftaranTahunan': pendaftaranTahunan,
      'pendaftaranPeralatan': pendaftaranPeralatan,
      'pendaftaranProgram': pendaftaranProgram,
      'pendaftaranTakaful': pendaftaranTakaful,
      'uniformP': uniformP,
      'uniformL': uniformL,
      'bulananPagi': bulananPagi,
      'bulananPagiPetang': bulananPagiPetang
    };
  }

  //generate from firebase
  static YuranModel fromJson(Map<String, dynamic> json) => YuranModel(
      pendaftaranTahunan: json['pendaftaranTahunan'],
      pendaftaranPeralatan: json['pendaftaranPeralatan'],
      pendaftaranProgram: json['pendaftaranProgram'],
      pendaftaranTakaful: json['pendaftaranTakaful'],
      uniformL: json['uniformL'],
      uniformP: json['uniformP'],
      bulananPagi: json['bulananPagi'],
      bulananPagiPetang: json['bulananPagiPetang']);
}
