import 'dart:async';

import 'package:cilikalfateh/ibubapa/login.dart';
import 'package:cilikalfateh/pilihan.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mysql1/mysql1.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  // definition of ParticlesOptions.
  ParticleOptions particles = const ParticleOptions(
    baseColor: Color.fromARGB(255, 183, 116, 58),
    spawnOpacity: 0.0,
    opacityChangeRate: 0.25,
    minOpacity: 0.1,
    maxOpacity: 0.4,
    particleCount: 70,
    spawnMaxRadius: 15.0,
    spawnMaxSpeed: 100.0,
    spawnMinSpeed: 30,
    spawnMinRadius: 7.0,
  );
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => PilihanScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // In body we have a AnimatedBackgound,
        // behavior RandomParticleBehaviour.
        body: AnimatedBackground(
            // vsync uses singleTicketProvider state mixin.
            vsync: this,
            behaviour: RandomParticleBehaviour(options: particles),
            child: Center(
              child: Stack(alignment: Alignment.center, children: <Widget>[
                Positioned(
                  left: 0.0,
                  bottom: 0.0,
                  right: 0.0,
                  top: 0.0,
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
              ]),
            )),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          ElevatedButton(
            onPressed: () => {},
            child: Text('IbuBapa /  Penjaga'),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            )),
          )
        ],
      ),
    ));
  }
}
