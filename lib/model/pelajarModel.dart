class PelajarModel {
  String id;
  String nama;
  String mykid;
  String noSijil;
  String tarikhLahir;
  String tempatLahir;
  String jantina;
  String bangsa;
  String agama;
  String anakNo;
  String jenisDarah;
  String statusVaksin;
  String tahapKesihatan;
  String statusOKU;
  String idPenjaga;
  String gambar;
  String sesi;
  String status;

  PelajarModel(
      {this.id = '',
      this.nama = '',
      this.mykid = '',
      this.noSijil = '',
      this.tarikhLahir = '',
      this.tempatLahir = '',
      this.jantina = '',
      this.bangsa = '',
      this.agama = '',
      this.anakNo = '',
      this.jenisDarah = '',
      this.statusVaksin = '',
      this.tahapKesihatan = '',
      this.statusOKU = '',
      this.idPenjaga = '',
      this.gambar = '',
      this.sesi = '',
      this.status = ''});

  //add to firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'noIC': mykid,
      'noSijil': noSijil,
      'tarikhLahir': tarikhLahir,
      'tempatLahir': tempatLahir,
      'jantina': jantina,
      'bangsa': bangsa,
      'agama': agama,
      'anakNo': anakNo,
      'jenisDarah': jenisDarah,
      'statusVaksin': statusVaksin,
      'tahapKesihatan': tahapKesihatan,
      'statusOKU': statusOKU,
      'idPenjaga': idPenjaga,
      'gambar': gambar,
      'sesi': sesi,
      'status': status
    };
  }

//generate from firebase
  static PelajarModel fromJson(Map<String, dynamic> json) => PelajarModel(
      id: json['id'],
      mykid: json['noIC'],
      nama: json['name'],
      idPenjaga: json['guardianID'],
      //gambar: json['profilePictureBase64'],
      //noSijil: json['noBirthCert'],
      tarikhLahir: json['dateOfBirth'],
      //tempatLahir: json['placeOfBirth'],
      jantina: json['gender'],
      bangsa: json['race'],
      agama: json['religion'],
      //anakNo: json['siblingPos'],
      //jenisDarah: json['jenisDarah'],
      //statusVaksin: json['statusVaksin'],
      //tahapKesihatan: json['tahapKesihatan'],
      //statusOKU: json['statusOKU'],
      //sesi: json['mode'],
      status: json['status']);
}
