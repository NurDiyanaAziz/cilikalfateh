import 'dart:async';
import 'dart:convert';

import 'package:cilikalfateh/ibubapa/nav.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../env.sample.dart';

class LoginScreen extends StatefulWidget {
  //const HomeScreen({super.key});
  String myObject = '';
  LoginScreen({required this.myObject});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  bool isRememberMe = false;
  final ic = TextEditingController();
  final password = TextEditingController();

  late SharedPreferences logindata;
  late bool newuser;
  late String usernow;

  bool _isObscure = true;
  String choice = '';
  late String errormsg;
  late bool error, showprogress;
  late String username, password1;

  startLogin() async {
    if (username == password1) {
      print(username + ' hmm');
      var url = Uri.parse('${Env.URL_PREFIX}/login.php');
      var response = await http.post(url, body: {
        'id': username, //get the username text
      });

      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata["error"]) {
          setState(() {
            showprogress = false; //don't show progress indicator
            error = true;
            errormsg = jsondata["message"];
            var snackBar = SnackBar(content: Text('Pengguna belum mendaftar'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
        } else {
          if (jsondata["success"]) {
            setState(() {
              error = false;
              showprogress = false;
              logindata.setBool('login', false);
              logindata.setString('kadPengenalan', username);
              logindata.setString('ic', jsondata["id"].toString());

              logindata.setString('relation', jsondata["relation"].toString());
            });
            //save the data returned from server
            //and navigate to home page
            String uid = jsondata["id"];
            String fullname = jsondata["fullname"];
            final index = 2;

            print(fullname);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomeScreen(
                      myObject: index,
                    )));
            //user shared preference to save data
          } else {
            showprogress = false; //don't show progress indicator
            error = true;
            errormsg = "Something went wrong.";
            var snackBar = SnackBar(content: Text('Hello World'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      } else {
        setState(() {
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = "Error during connecting to server.";
          var snackBar = SnackBar(content: Text('Hello World'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    } else {
      print('different password');
      var snackBar =
          SnackBar(content: Text('Kad Pengenalan dan Kata Laluan berbeza'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void initState() {
    // TODO: implement initState
    choice = widget.myObject;
    super.initState();
    check_if_already_login();
  }

  void check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    usernow = logindata.getString('type').toString();
    print(newuser);
    final index = 2;
    if (newuser == false) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(
                myObject: index,
              )));
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    ic.dispose();

    super.dispose();
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future<void> validateAndSubmit() async {
    if (validateAndSave()) {
      final icFirst = ic.text.toString().trim();
      final icConfirm = password.text.toString().trim();
      if (choice == "Ibubapa / Penjaga") {
        if (icFirst == icConfirm) {
          QuerySnapshot snap = await FirebaseFirestore.instance
              .collection("ibubapa")
              .where("ic", isEqualTo: icFirst)
              .get();

          if (snap.size == 0) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("User Not Exist!")));
          } else {
            final ic = snap.docs[0]['ic'].toString();
            logindata.setBool('login', false);
            logindata.setString('ic', ic);

            final index = 1;

            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomeScreen(
                      myObject: index,
                    )));
          }
        }
      }

      //context.read<AuthService>().login(snap.docs[18]['phone']);
      //FirebaseUser user = await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }

  Widget buildEmailPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        Form(
            key: formKey,
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    username = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.black87, fontSize: 20),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: myinputborder(),
                    focusedBorder: myfocusborder(),
                    prefix: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(''),
                    ),
                    prefixIcon: Icon(Icons.person),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14, left: 1),
                    labelText: 'Kad Pengenalan / Passport',
                    hintStyle: TextStyle(color: Colors.black38),
                  ),
                  controller: ic,
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        password1 = value;
                      },
                      obscureText: _isObscure,
                      style: TextStyle(color: Colors.black87, fontSize: 20),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                        prefix: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(''),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 14, left: 1),
                        labelText: 'Kata Laluan',
                        hintStyle: TextStyle(color: Colors.black38),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                      controller: password,
                    )
                  ],
                )
              ],
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 247, 164, 68),
        body: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              height: double.maxFinite,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 80),
              child: Column(children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: FadeIn(
                    child: Image.asset(
                      'assets/images/myCilik_Logo.png',
                      scale: 3,
                    ),
                    // Optional paramaters
                    duration: Duration(milliseconds: 2000),
                    curve: Curves.easeIn,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: FadeIn(
                      child: Text(
                        choice,
                        style: TextStyle(fontSize: 20),
                      ),
                    )),
                SizedBox(
                  height: 30,
                ),
                buildEmailPassword(),
                SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: FadeIn(
                    child: ElevatedButton(
                      onPressed: startLogin,
                      child: Text(
                        'Log masuk',
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        backgroundColor: Color.fromARGB(255, 89, 165, 64),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                      ),
                    ),
                    // Optional paramaters
                    duration: Duration(milliseconds: 2000),
                    curve: Curves.easeIn,
                  ),
                ),
              ]),
            )));
  }
}

OutlineInputBorder myinputborder() {
  //return type is OutlineInputBorder
  return OutlineInputBorder(
      //Outline border type for TextFeild
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        color: Color.fromARGB(255, 255, 255, 255),
        width: 3,
      ));
}

OutlineInputBorder myfocusborder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        color: Colors.greenAccent,
        width: 3,
      ));
}
