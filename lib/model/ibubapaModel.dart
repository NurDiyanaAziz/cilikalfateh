class ParentDetail {
  String nickname;
  String nama;
  String ic;
  String telefon;
  String emel;
  String hubungan;
  int bilAnak;
  String alamat;
  String pekerjaan;
  String gambar;
  String id;

  ParentDetail(
      {this.nickname = '',
      this.nama = '',
      this.ic = '',
      this.telefon = '',
      this.emel = '',
      this.hubungan = '',
      this.alamat = '',
      this.bilAnak = 0,
      this.pekerjaan = '',
      this.gambar = '',
      this.id = ''});

  //add to firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ic': ic,
      'nickname': nickname,
      'nama': nama,
      'telefon': telefon,
      'emel': emel,
      'hubungan': hubungan,
      'bilAnak': bilAnak,
      'alamat': alamat,
      'pekerjaan': pekerjaan,
      'gambar': gambar,
    };
  }

//generate from firebase
  static ParentDetail fromJson(Map<String, dynamic> json) => ParentDetail(
        id: json['id'],
        nama: json['nama'],
        ic: json['ic'],
      );
}
