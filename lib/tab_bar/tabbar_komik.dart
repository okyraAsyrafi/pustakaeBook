import 'package:flutter/material.dart';
import 'package:pustaka_ebook/database_connect.dart';
import 'package:pustaka_ebook/model/komik.dart';
import 'package:pustaka_ebook/novel_komik_detail.dart';

class TabbarKomik extends StatefulWidget {
  @override
  _TabbarKomikState createState() => _TabbarKomikState();
}

class _TabbarKomikState extends State<TabbarKomik> {
  List<Komik> komikList = List<Komik>();

  @override
  void initState() {
    super.initState();
    getNovel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.only(left: 32.0, top: 8.0),
          child: GridView.count(
            crossAxisCount: 2,
            children: komikList.map((komik) {
              return FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NoKoDetail(
                      bagian: "Komik",
                      id: komik.id,
                    );
                  }));
                },
                child: Container(
                  margin: EdgeInsets.only(right: 32.0, bottom: 8.0, top: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9.0),
                    child: Image(
                        height: 500,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            'http://10.0.2.2/flutter_belajar_database/image/${komik.gambarBuku}')),
                  ),
                ),
              );
            }).toList(),
          ),
        ));
  }

  void getNovel() {
    DatabaseConnect().listKomik().then((value) {
      komikList = value;
      setState(() {});
    });
  }
}
