import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pustaka_ebook/dashboard.dart';
import 'package:pustaka_ebook/database_connect.dart';
import 'package:pustaka_ebook/model/Novel.dart';
import 'package:pustaka_ebook/model/komik.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NoKoDetail extends StatefulWidget {
  String id;
  String bagian;

  NoKoDetail({this.id, this.bagian});

  @override
  _NoKoDetailState createState() => _NoKoDetailState(id, bagian);
}

class _NoKoDetailState extends State<NoKoDetail> {
  Novel novel;
  Komik komik;
  String bagian;
  String id;
  _NoKoDetailState(this.id, this.bagian);

  bool isKomik = true;
  bool isEdit = false;
  final _formkey = GlobalKey<FormState>();
  File image;
  Pinjam pinjam;
  String judulBuku;
  String volumeKomik = '';
  String pengarangPenulis = '';
  String penulis = '';
  String tahunTerbit = '';
  String tebalBuku = '';
  String sinopsis = '';
  String gambarBuku;
  String penerbit = '';
  var idBuku;

  Future getImageGalery() async {
    var imageFile = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      image = File(imageFile.path);
    });
  }

  List<Pinjam> pinjamHari = [
    Pinjam(jumlahHari: '3 hari'),
    Pinjam(jumlahHari: '5 hari'),
    Pinjam(jumlahHari: '7 hari'),
  ];

  List<DropdownMenuItem> generateItems(List<Pinjam> pinjaman) {
    List<DropdownMenuItem> items = [];
    for (var item in pinjamHari) {
      items.add(DropdownMenuItem(
        child: Text(item.jumlahHari),
        value: item,
      ));
    }
    return items;
  }

  void _validasiUpdate() {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      // koneksikan ke function database => update buku

    }
  }

  void cekKomikatauNovel() {
    if (bagian == 'Komik') {
      DatabaseConnect().getBukuFromIDKomik(id).then((value) {
        komik = value;
        isKomik = true;
        idBuku = komik.id;
        judulBuku = komik.judulBuku;
        volumeKomik = komik.volumekomik;
        pengarangPenulis = komik.pengarang;
        tahunTerbit = komik.tahunTerbit;
        sinopsis = komik.sinopsis;
        gambarBuku = komik.gambarBuku;
        setState(() {});
      });
    } else {
      DatabaseConnect().getBukuFromIDNovel(id).then((value) {
        novel = value;
        isKomik = false;
        idBuku = novel.id;
        judulBuku = novel.judulBuku;
        pengarangPenulis = novel.penulis;
        penerbit = novel.penerbit;
        tahunTerbit = novel.tahunTerbit;
        tebalBuku = novel.tebalBuku;
        sinopsis = novel.sinopsis;
        gambarBuku = novel.gambarBuku;
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    super.initState();
    cekKomikatauNovel();
  }

  @override
  Widget build(BuildContext context) {
    double tinggiforContainer = MediaQuery.of(context).size.height * 0.30;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2),
                  child: RaisedButton(onPressed: () {})),
              (gambarBuku == null)
                  ? SizedBox()
                  : Image(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.4,
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'http://10.0.2.2/flutter_belajar_database/image/$gambarBuku'),
                    ),
              (isEdit)
                  ? Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.22),
                      child: RaisedButton(
                        onPressed: () {
                          getImageGalery();
                        },
                        color: Colors.green,
                        child: Icon(Icons.image),
                      ))
                  : SizedBox(),
              SafeArea(
                  child: Row(
                mainAxisAlignment: (isEdit)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  (isEdit)
                      ? SizedBox()
                      : IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.green),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                  (isEdit)
                      ? IconButton(
                          icon: Icon(Icons.delete, color: Colors.green),
                          onPressed: () {
                            DatabaseConnect().hapusBuku(idBuku).then((value) {
                              Alert(
                                context: context,
                                title: "",
                                desc: value,
                                image: Image(
                                  width: 50,
                                  height: 50,
                                  image: AssetImage("images/checked.png"),
                                ),
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "OK",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                      return Dashboard();
                                    })),
                                    color: Color.fromRGBO(0, 179, 134, 1.0),
                                    radius: BorderRadius.circular(0.0),
                                  ),
                                ],
                              ).show();
                            });
                          })
                      : SizedBox(),
                  (isEdit)
                      ? IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            setState(() {
                              isEdit = false;
                            });
                          })
                      : IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            setState(() {
                              isEdit = true;
                            });
                          }),
                ],
              )),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: tinggiforContainer),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 9,
                  offset: Offset(0, -2), // changes position of shadow
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Center(child: Text(bagian)),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Text("Kategori")
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Center(child: Text("131")),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Text("Nomor")
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Center(child: Text("131-1")),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Text("Kode")
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(flex: 1, child: Text("Judul $bagian")),
                          Expanded(
                              flex: 2,
                              child: (isEdit)
                                  ? TextFormField(
                                      initialValue: judulBuku,
                                      onSaved: (String judulbuku) {
                                        judulBuku = judulbuku;
                                      },
                                      // controller: controllerJudulBuku,
                                      maxLines: 1,
                                    )
                                  : Container(child: Text(': $judulBuku'))),
                        ],
                      ),
                    ),
                    (isKomik)
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(flex: 1, child: Text("Volume Komik")),
                                Expanded(
                                    flex: 2,
                                    child: (isEdit)
                                        ? TextFormField(
                                            initialValue: volumeKomik,
                                            onSaved: (String volumekomik) {
                                              volumeKomik = volumekomik;
                                            },
                                            maxLines: 1,
                                          )
                                        : Container(
                                            child: Text(': $volumeKomik'))),
                              ],
                            ),
                          )
                        : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: (isKomik)
                                  ? Text("Pengarang")
                                  : Text("Penulis")),
                          Expanded(
                              flex: 2,
                              child: Container(
                                  child: (isEdit)
                                      ? TextFormField(
                                          initialValue: pengarangPenulis,
                                          maxLines: 1,
                                          onSaved: (String pp) {
                                            pengarangPenulis = pp;
                                          },
                                        )
                                      : Text(': $pengarangPenulis'))),
                        ],
                      ),
                    ),
                    (isKomik)
                        ? SizedBox()
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(flex: 1, child: Text("Penerbit")),
                                Expanded(
                                    flex: 2,
                                    child: (isEdit)
                                        ? TextFormField(
                                            initialValue: penerbit,
                                            maxLines: 1,
                                            onSaved: (String pnbt) {
                                              penerbit = pnbt;
                                            },
                                          )
                                        : Container(
                                            child: Text(": $penerbit"))),
                              ],
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(flex: 1, child: Text("tahun terbit")),
                          Expanded(
                              flex: 2,
                              child: Container(
                                  child: (isEdit)
                                      ? TextFormField(
                                          initialValue: tahunTerbit,
                                          maxLines: 1,
                                          onSaved: (String tt) {
                                            tahunTerbit = tt;
                                          },
                                        )
                                      : Text(": $tahunTerbit"))),
                        ],
                      ),
                    ),
                    (isKomik)
                        ? SizedBox()
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(flex: 1, child: Text("tebal buku")),
                                Expanded(
                                    flex: 2,
                                    child: (isEdit)
                                        ? TextFormField(
                                            initialValue: tebalBuku,
                                            maxLines: 1,
                                            onSaved: (String tb) {
                                              tebalBuku = tb;
                                            },
                                          )
                                        : Container(
                                            child: Text(": $tebalBuku"))),
                              ],
                            ),
                          ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: (isEdit)
                          ? TextFormField(
                              initialValue: sinopsis,
                              maxLines: 5,
                              onSaved: (String snps) {
                                sinopsis = snps;
                              },
                            )
                          : Text(
                              sinopsis,
                              textAlign: TextAlign.center,
                            ),
                    ),
                    (isEdit)
                        ? RaisedButton(
                            onPressed: () {
                              // _formkey.currentState.save();
                              // print(judulBuku);
                              _validasiUpdate();
                            },
                            child: Text('UPDATE'))
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Pinjam {
  String jumlahHari;
  Pinjam({this.jumlahHari});
}
