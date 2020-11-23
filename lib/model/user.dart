class User {
  String id;
  String email;
  String password;
  String level;
  String nama;
  String status;
  String createDate;

  User(
      {this.id,
      this.email,
      this.password,
      this.level,
      this.nama,
      this.status,
      this.createDate});

  @override
  String toString() {
    return 'User{ id: $id, email: $email,password:$password, level: $level, nama: $nama, status: $status, createDate: $createDate}';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['data']['id'],
      email: json['data']['email'],
      password: json['data']['password'],
      level: json['data']['level'],
      nama: json['data']['nama'],
      status: json['data']['status'],
      createDate: json['data']['createData'],
    );
  }
}
