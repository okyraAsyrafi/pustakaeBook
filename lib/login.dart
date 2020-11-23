import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pustaka_ebook/dashboard.dart';
import 'package:pustaka_ebook/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isError = false;
  bool isLoading = false;
  bool isLogin = true;
  String messageError = '';

  double getLingkaranBawah(BuildContext context) => 300;
  final _formkey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cekLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingOverlay(
        isLoading: isLoading,
        color: Colors.transparent,
        progressIndicator: CircularProgressIndicator(),
        child: Stack(children: <Widget>[
          //        background login bagian atas
          ShaderMask(
            shaderCallback: (gambar) {
              return LinearGradient(
                      colors: [Colors.black, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)
                  .createShader(
                      Rect.fromLTRB(0, 0, gambar.width, gambar.height));
            },
            blendMode: BlendMode.dstIn,
            child: Image(
                width: MediaQuery.of(context).size.width,
                height: 145,
                fit: BoxFit.cover,
                image: AssetImage('images/bgataslogin.jpg')),
          ),
          //        background login bagian bawah
          Positioned(
            bottom: -getLingkaranBawah(context) * 0.6,
            child: ClipOval(
              child: SizedBox(
                height: getLingkaranBawah(context),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Image(
                        width: MediaQuery.of(context).size.width,
                        image: AssetImage('images/bgbawahlogin.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.transparent,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          //        bagian login
          Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                //            logo
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.30),
                  width: 200,
                  height: 75,
                  child: Image(image: AssetImage('images/pustaka e-book.png')),
                ),
                //            input username
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 4),
                  child: TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                        hintText: 'Input username',
                        hintStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.green,
                        )),
                    maxLines: 1,
                    validator: validasiUser,
                  ),
                ),
                //            input password
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 4, 32, 0),
                  child: TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        hintText: 'Input password',
                        hintStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.green,
                        )),
                    maxLines: 1,
                    obscureText: true,
                    validator: validasiPassword,
                  ),
                ),
                //            info username atau password salah
                (isError == false)
                    ? SizedBox()
                    : Container(
                        margin: EdgeInsets.fromLTRB(32, 4, 32, 0),
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4)),
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isError = false;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 2.0, right: 2.0),
                                    child: Icon(
                                      Icons.close,
                                      size: 10,
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                messageError,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ), //
                // button login
                Container(
                  height: 50,
                  margin: EdgeInsets.fromLTRB(32, 16, 32, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      gradient: LinearGradient(
                          colors: [Colors.green, Colors.blue],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)),
                  child: Material(
                    borderRadius: BorderRadius.circular(4.0),
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4.0),
                      splashColor: Colors.black26,
                      onTap: () {
                        _validasiLogin(
                            usernameController.text, passwordController.text);
                      },
                      child: Center(
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  // validasi user pada textform field
  String validasiUser(String value) {
    if (value.isEmpty) {
      return 'Username tidak boleh kosong';
    }

    return null;
  }

  // validasi password pada textform field
  String validasiPassword(String value) {
    if (value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    return null;
  }

  // validasi login ketika menekan tombol login
  _validasiLogin(String username, String password) {
    if (_formkey.currentState.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());

      setState(() {
        isLoading = true;
      });

      Future.delayed(Duration(seconds: 3), () async {
        SharedPreferences _pref = await SharedPreferences.getInstance();
        final url = 'http://10.0.2.2/flutter_belajar_database/login.php';
        var body = {
          'email': username,
          'password': password,
        };

        final response = await http.post(url, body: body);
        final data = jsonDecode(response.body);
        print(data);

        if (data['value'] == 1) {
          _pref.setBool('isLogin', isLogin);
          _pref.setString('idUser', data['data']['id']);
          _pref.setString('emailUser', data['data']['email']);
          _pref.setString('namaUser', data['data']['nama']);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return Dashboard();
          }));
        } else {
          setState(() {
            messageError = data['message'];
            isError = true;
          });
        }
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  void cekLogin() {
    getIsLogin().then((tORf) {
      if (tORf == true) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Dashboard();
        }));
      }
    });
  }
}
