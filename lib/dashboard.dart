import 'package:flutter/material.dart';
import 'package:pustaka_ebook/login.dart';
import 'package:pustaka_ebook/tab_bar/tabbar_komik.dart';
import 'package:pustaka_ebook/tab_bar/tabbar_novel.dart';
import 'package:pustaka_ebook/tambah_buku.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Dashboard extends StatelessWidget {
  var myTabbar = TabBar(
    indicator: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(9.0),
    ),
    tabs: <Widget>[
      Tab(
//        text: "Novel",
        child: Text(
          "Komik",
          style: TextStyle(color: Color(0xff111d5e)),
        ),
      ),
      Tab(
        child: Text(
          "Novel",
          style: TextStyle(color: Color(0xff111d5e)),
        ),
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            leading: Container(),
            title: Center(
              child: Image(
                image: AssetImage('images/pustaka e-book.png'),
                width: 150,
              ),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.power_settings_new,
                    color: Colors.green,
                  ),
                  onPressed: () async {
                    SharedPreferences _pref =
                        await SharedPreferences.getInstance();
                    _pref.clear();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext ctx) => Login()));
                  })
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(myTabbar.preferredSize.height),
              child: Container(
                margin: EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    color: Colors.grey[300]),
                child: Container(
//                    padding: const EdgeInsets.all(4.0),
                  margin: EdgeInsets.all(2.0),
                  child: myTabbar,
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Image(
              fit: BoxFit.fill,
              image: AssetImage('images/bgpattern.jpg'),
            ),
            TabBarView(children: <Widget>[
//        Novel,
              TabbarKomik(),
//        Cerpen
              TabbarNovel(),
            ]),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return TambahBuku();
              }));
            },
            child: Icon(Icons.add)),
      ),
    );
  }
}
