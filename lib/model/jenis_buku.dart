class JenisBuku {
  String jenisBuku;

  JenisBuku({this.jenisBuku});

  @override
  String toString() {
    return 'JenisBuku{jenis_buku: $jenisBuku}';
  }

  factory JenisBuku.fromJson(Map<String, dynamic> json) {
    return JenisBuku(jenisBuku: json['jenis_buku']);
  }

  Map<String, dynamic> toJson() {
    return {
      'jenis_buku': jenisBuku,
    };
  }
}
