import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pustaka_ebook/dashboard.dart';
import 'package:pustaka_ebook/database_connect.dart';
import 'package:pustaka_ebook/model/jenis_buku.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TambahBuku extends StatefulWidget {
  @override
  _TambahBukuState createState() => _TambahBukuState();
}

class _TambahBukuState extends State<TambahBuku> {
  bool isKomik = true;
  File image;
  List<JenisBuku> jenisBuku = List<JenisBuku>();
  String base64Image;
  String fileName;
  String jenisBukuDipilih;
  TextEditingController cJudulBuku = TextEditingController();
  TextEditingController cVolumeKomik = TextEditingController();
  TextEditingController cPengarangPenulis = TextEditingController();
  TextEditingController cPenerbit = TextEditingController();
  TextEditingController cTahunTerbit = TextEditingController();
  TextEditingController cTebalBuku = TextEditingController();
  TextEditingController cSinopsis = TextEditingController();

  Future getImageGalery() async {
    var imageFile = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      image = File(imageFile.path);
    });
  }

  List<DropdownMenuItem> generateItems(List<JenisBuku> jenis) {
    List<DropdownMenuItem> items = [];
    for (var item in jenis) {
      items.add(DropdownMenuItem(
        child: Text(item.jenisBuku),
        value: item.jenisBuku,
      ));
    }
    return items;
  }

  @override
  void initState() {
    getJenis();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah buku')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                color: (image == null) ? Colors.blue : Colors.transparent,
                child: (image == null)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          GestureDetector(
                              onTap: () {
                                getImageGalery();
                              },
                              child: Icon(Icons.cloud_upload)),
                          Text("Upload Cover Buku")
                        ],
                      )
                    : GestureDetector(
                        onTap: () {
                          getImageGalery();
                        },
                        child: Image.file(image)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: DropdownButton(
                  isExpanded: true,
                  value: jenisBukuDipilih,
                  hint: Text("Pilih Jenis Buku"),
                  items: generateItems(jenisBuku),
                  onChanged: (item) {
                    jenisBukuDipilih = item;
                    if (item == 'Komik') {
                      isKomik = true;
                    } else if (item == 'Novel') {
                      isKomik = false;
                    }
                    setState(() {});
                  },
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text("Judul Buku"),
                  ),
                  Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: cJudulBuku,
                        maxLines: 1,
                      ))
                ],
              ),
              (isKomik)
                  ? Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text("Volume Komik"),
                        ),
                        Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: cVolumeKomik,
                              maxLines: 1,
                            ))
                      ],
                    )
                  : SizedBox(),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: (isKomik) ? Text("Pengarang") : Text('Penulis'),
                  ),
                  Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: cPengarangPenulis,
                        maxLines: 1,
                      ))
                ],
              ),
              (isKomik)
                  ? SizedBox()
                  : Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text("Penerbit"),
                        ),
                        Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: cPenerbit,
                              maxLines: 1,
                            ))
                      ],
                    ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text("Tahun Terbit"),
                  ),
                  Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: cTahunTerbit,
                        maxLines: 1,
                      ))
                ],
              ),
              (isKomik)
                  ? SizedBox()
                  : Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text("Tebal Buku"),
                        ),
                        Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: cTebalBuku,
                              maxLines: 1,
                            ))
                      ],
                    ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text("Sinopsis"),
                  ),
                  Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: cSinopsis,
                        maxLines: 5,
                      ))
                ],
              ),
              RaisedButton(
                  onPressed: () {
                    if (image != null) {
                      DatabaseConnect()
                          .uploadBuku(
                              image,
                              cJudulBuku.text,
                              cVolumeKomik.text,
                              cPengarangPenulis.text,
                              cPenerbit.text,
                              cTahunTerbit.text,
                              cTebalBuku.text,
                              cSinopsis.text,
                              jenisBukuDipilih)
                          .then((value) {
                        Alert(
                          context: context,
                          title: "",
                          desc: value,
                          image: Image(
                              width: 50,
                              height: 50,
                              image: AssetImage("images/checked.png")),
                          buttons: [
                            DialogButton(
                              child: Text(
                                "OK",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () =>
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                return Dashboard();
                              })),
                              color: Color.fromRGBO(0, 179, 134, 1.0),
                              radius: BorderRadius.circular(0.0),
                            ),
                          ],
                        ).show();
                      });
                    } else {
                      print("upload gambar dahulu");
                    }
                  },
                  child: Text('Tambah Buku'))
            ],
          ),
        ),
      ),
    );
  }

  void getJenis() async {
    DatabaseConnect().listJenisBuku().then((value) {
      jenisBuku = value;
      setState(() {});
    });
  }
}
