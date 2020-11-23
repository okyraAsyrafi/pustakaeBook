class Komik {
  String id;
  String judulBuku;
  String gambarBuku;
  String jenisBuku;
  String pengarang; //ditable pengarang_or_penullis
  String sinopsis;
  String tahunTerbit;
  String volumekomik;

  Komik(
      {this.id,
      this.judulBuku,
      this.gambarBuku,
      this.jenisBuku,
      this.pengarang,
      this.sinopsis,
      this.tahunTerbit,
      this.volumekomik});

  @override
  String toString() {
    return "data:{id: $id, judulBuku: $judulBuku, gambarBuku: $gambarBuku, jenisBuku: $jenisBuku, pengarang: $pengarang, sinopsis: $sinopsis, tahunTerbit: $tahunTerbit, volumeKomik: $volumekomik )";
  }

  factory Komik.fromJson(Map<String, dynamic> json) {
    return Komik(
        id: json['id'],
        judulBuku: json['judul_buku'],
        gambarBuku: json['gambar_buku'],
        jenisBuku: json['jenis_buku'],
        pengarang: json['pengarang_or_penulis'],
        sinopsis: json['sinopsis'],
        tahunTerbit: json['tahun_terbit'],
        volumekomik: json['volume_komik']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judulBuku': judulBuku,
      'gambarBuku': gambarBuku,
      'jenisBuku': jenisBuku,
      'pengarang': pengarang,
      'sinopsis': sinopsis,
      'tahunTerbit': tahunTerbit,
      'volumeKomik': volumekomik
    };
  }
}
