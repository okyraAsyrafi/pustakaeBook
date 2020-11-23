import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pustaka_ebook/model/Novel.dart';
import 'package:pustaka_ebook/model/jenis_buku.dart';
import 'package:pustaka_ebook/model/komik.dart';
import 'package:pustaka_ebook/shared_preferences.dart';

class DatabaseConnect {
  String baseUrl = 'http://10.0.2.2/flutter_belajar_database';

  Future<List<Novel>> listNovel() async {
    String urlDatabase = '$baseUrl/get_data_novel.php';
    var listNovel = List<Novel>();

    final respon = await http.get(urlDatabase);
    final data = jsonDecode(respon.body);

    if (respon.statusCode == 200) {
      if (data['value'] == 1) {
        var dataNovel = data['data'];
        for (var dataJson in dataNovel) {
          listNovel.add(Novel.fromJson(dataJson));
        }
        return listNovel;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<List<Komik>> listKomik() async {
    String urlDatabase = '$baseUrl/get_data_komik.php';
    var listKomik = List<Komik>();

    final respon = await http.get(urlDatabase);
    final data = jsonDecode(respon.body);

    if (respon.statusCode == 200) {
      if (data['value'] == 1) {
        var dataKomik = data['data'];
        for (var dataJson in dataKomik) {
          listKomik.add(Komik.fromJson(dataJson));
        }
        return listKomik;
      } else {
        print('selain 200');
        return null;
      }
    } else {
      print('fefefef');
      return null;
    }
  }

  Future<List<JenisBuku>> listJenisBuku() async {
    String urlDatabase = '$baseUrl/get_jenis_buku.php';
    var listJenis = List<JenisBuku>();

    final respon = await http.get(urlDatabase);
    final data = jsonDecode(respon.body);

    if (respon.statusCode == 200) {
      if (data['value'] == 1) {
        var dataJenisBuku = data['data'];
        for (var dataJson in dataJenisBuku) {
          listJenis.add(JenisBuku.fromJson(dataJson));
        }
        return listJenis;
      } else {
        print('selain 200');
        return null;
      }
    } else {
      print('fefefef');
      return null;
    }
  }

  Future uploadBuku(
      File imageFile,
      String judulBuku,
      String volumeKomik,
      String pengarangPenulis,
      String penerbit,
      String tahunTerbit,
      String tebalBuku,
      String sinopsis,
      String jenisBuku) async {
    String urlDatabase = '$baseUrl/upload_buku.php';

    var idUser = await getIdUser();
    var stream = imageFile.readAsBytes().asStream();
    var length = imageFile.lengthSync();
    var filename = imageFile.path.split('/').last;
    var multipartfile =
        http.MultipartFile('image', stream, length, filename: filename);

    var request = http.MultipartRequest('POST', Uri.parse(urlDatabase));
    request.fields['judulBuku'] = judulBuku;
    request.fields['volumeKomik'] = volumeKomik;
    request.fields['pengarangPenulis'] = judulBuku;
    request.fields['penerbit'] = penerbit;
    request.fields['tahunTerbit'] = tahunTerbit;
    request.fields['tebalBuku'] = tebalBuku;
    request.fields['sinopsis'] = sinopsis;
    request.fields['created_by'] = idUser;
    request.fields['jenisBuku'] = jenisBuku;

    request.files.add(multipartfile);

    http.Response response =
        await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      var respon = response.body;

      if (respon == '1') {
        return "Buku telah berhasil ditambahkan";
      } else {
        return "Buku tidak berhasil ditambahkan";
      }
    } else {
      print('upload gagal');
    }
  }

  Future hapusBuku(var id) async {
    String urlDatabase = '$baseUrl/hapus_buku.php';
    var body = {
      'id': id,
    };
    final response = await http.post(urlDatabase, body: body);
    final data = response.body;
    return data;
  }

  Future<Komik> getBukuFromIDKomik(var id) async {
    Komik komik = Komik();

    String urlDatabase = '$baseUrl/get_buku_id_komik.php';
    var body = {
      'id': id,
    };

    final respon = await http.post(urlDatabase, body: body);
    final data = jsonDecode(respon.body);

    if (respon.statusCode == 200) {
      komik = Komik.fromJson(data['data']);
      // print(komik);
      return komik;
    } else {
      return null;
    }
  }

  Future<Novel> getBukuFromIDNovel(var id) async {
    Novel novel = Novel();

    String urlDatabase = '$baseUrl/get_buku_id_komik.php';
    var body = {
      'id': id,
    };

    final respon = await http.post(urlDatabase, body: body);
    final data = jsonDecode(respon.body);

    if (respon.statusCode == 200) {
      novel = Novel.fromJson(data['data']);
      // print(komik);
      return novel;
    } else {
      return null;
    }
  }
}
