class Novel {
  String id;
  String judulBuku;
  String gambarBuku;
  String jenisBuku;
  String penerbit;
  String penulis; //ditable pengarang_or_penullis
  String sinopsis;
  String tahunTerbit;
  String tebalBuku;

  Novel(
      {this.id,
      this.judulBuku,
      this.gambarBuku,
      this.jenisBuku,
      this.penerbit,
      this.penulis,
      this.sinopsis,
      this.tahunTerbit,
      this.tebalBuku});

  @override
  String toString() {
    return "data:{ id: $id, judulBuku: $judulBuku, gambarBuku: $gambarBuku, jenisBuku: $jenisBuku, penerbit: $penerbit, penulis: $penulis, sinopsis: $sinopsis, tahunTerbit: $tahunTerbit, tebalBuku: $tebalBuku )";
  }

  factory Novel.fromJson(Map<String, dynamic> json) {
    return Novel(
      id: json['id'],
      judulBuku: json['judul_buku'],
      gambarBuku: json['gambar_buku'],
      penerbit: json['penerbit'],
      penulis: json['pengarang_or_penulis'],
      sinopsis: json['sinopsis'],
      tahunTerbit: json['tahun_terbit'],
      tebalBuku: json['tebal_buku'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judulBuku': judulBuku,
      'gambarBuku': gambarBuku,
      'penerbit': penerbit,
      'penulis': penulis,
      'sinopsis': sinopsis,
      'tahunTerbit': tahunTerbit,
      'tebalBuku': tebalBuku,
    };
  }
}
