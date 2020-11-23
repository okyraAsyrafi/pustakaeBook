import 'package:flutter/material.dart';
import 'package:pustaka_ebook/model/Novel.dart';
import 'package:pustaka_ebook/database_connect.dart';
import 'package:pustaka_ebook/novel_komik_detail.dart';

class TabbarNovel extends StatefulWidget {
  @override
  _TabbarNovelState createState() => _TabbarNovelState();
}

class _TabbarNovelState extends State<TabbarNovel> {
  List<Novel> novelList = List<Novel>();

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
            children: novelList.map((novel) {
              return FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NoKoDetail(
                      id: novel.id,
                      bagian: 'Novel',
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
                            'http://10.0.2.2/flutter_belajar_database/image/${novel.gambarBuku}')),
                  ),
                ),
              );
            }).toList(),
          ),
        ));
  }

  void getNovel() {
    DatabaseConnect().listNovel().then((value) {
      novelList = value;
      setState(() {});
    });
  }
}
