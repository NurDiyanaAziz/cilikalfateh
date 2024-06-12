class PengumumanModel {
  String anjuran;
  String nama;
  String penerangan;
  String yuran;
  String tarikhMula;
  String tarikhTamat;
  String id;

  PengumumanModel({
    this.anjuran = '',
    this.nama = '',
    this.penerangan = '',
    this.yuran = '',
    this.tarikhMula = '',
    this.tarikhTamat = '',
    this.id = '',
  });

  //add to firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'anjuran': anjuran,
      'nama': nama,
      'penerangan': penerangan,
      'yuran': yuran,
      'tarikhMula': tarikhMula,
      'tarikhTamat': tarikhTamat,
    };
  }

  //generate from firebase
  static PengumumanModel fromJson(Map<String, dynamic> json) => PengumumanModel(
      id: json['id'],
      anjuran: json['anjuran'],
      nama: json['nama'],
      penerangan: json['penerangan'],
      yuran: json['yuran'],
      tarikhMula: json['tarikhMula'],
      tarikhTamat: json['tarikhTamat']);
}
