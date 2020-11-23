import 'dart:convert';

import 'package:pustaka_ebook/model/Novel.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences sharedPreferences;

Future<bool> getIsLogin() async {
  sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getBool("isLogin") ?? false;
  //  return true;
}

Future<String> getIdUser() async {
  sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("idUser") ?? false;
  //  return true;
}

class ForSavePreferences {
  static getListNovel() async {
    var data = List<Novel>();
    var sharedPreferences = await SharedPreferences.getInstance();
    // shared preferences menggunakan format key value pair
    // untuk membaca data kita perlu memasukkan key pada method getString
    // pastikan key adalah unik, jadi lebih baik gunakan nama domain
    var savedDataList = sharedPreferences.get('itemListNovel');
    // jika nilai masih null, misal saat pertama kali install
    // kita beri nilai default agar tidak error saat diconvert dengan perintah json.decode
    if (savedDataList == null) {
      savedDataList = "[]";
    }

    // data yang disimpan di shared preferences sebaiknya string dengan fomat json
    // agar bisa dengan mudah diolah menjadi list atau map dart
//    return json.decode(savedDataList);
    var responJson = json.decode(savedDataList);
    for (var dataJson in responJson) {
      data.add(Novel.fromJson(dataJson));
    }
    return data;
  }

  static saveListNovel(data) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    // untuk menulis data kita memasukkkan key dan value
    // value dalam hal ini adalah variabel data yang masih dalam bentuk list atau map
    // jadi perlu diubah jadi string dengan format json2
    sharedPreferences.setString('itemListNovel', json.encode(data));
  }
}
