import 'dart:async';

import 'package:cilikalfateh/ibubapa/login.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ibubapa/nav.dart';

class PilihanScreen extends StatefulWidget {
  //const HomeScreen({super.key});
  var myObject = 0;
  PilihanScreen({super.key});

  @override
  State<PilihanScreen> createState() => _PilihanScreen();
}

class _PilihanScreen extends State<PilihanScreen> {
  String choice = '';

  late SharedPreferences logindata;
  late bool newuser;
  late String usernow;

  @override
  void initState() {
    // TODO: implement initState

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
      print(logindata.getString('ic').toString());
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(
                myObject: index,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Color.fromARGB(255, 247, 164, 68),
      child: Column(children: [
        SizedBox(
          height: 100,
        ),
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
            child: ElevatedButton(
              onPressed: () => {
                choice = "Ibubapa / Penjaga",
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginScreen(myObject: choice)),
                ),
              },
              child: Text(
                'IbuBapa / Penjaga',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 3,
                backgroundColor: Color.fromARGB(255, 77, 201, 184),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
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
            child: ElevatedButton(
              onPressed: () => {},
              child: Text(
                'Guru',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 3,
                backgroundColor: Color.fromARGB(255, 108, 201, 77),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
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
            child: ElevatedButton(
              onPressed: () => {},
              child: Text(
                'Guru Besar',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 3,
                backgroundColor: Color.fromARGB(255, 201, 77, 91),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
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
            child: ElevatedButton(
              onPressed: () => {},
              child: Text(
                'Pengurus',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 3,
                backgroundColor: Color.fromARGB(255, 197, 146, 75),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
            ),
            // Optional paramaters
            duration: Duration(milliseconds: 2000),
            curve: Curves.easeIn,
          ),
        ),
      ]),
    ));
  }
}
