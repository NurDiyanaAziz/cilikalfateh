import 'dart:async';

import 'package:cilikalfateh/ibubapa/senaraiPelajar.dart';
import 'package:cilikalfateh/ibubapa/statusPendaftaran.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:auto_size_text/auto_size_text.dart';

class PelajarScreen extends StatefulWidget {
  //const HomeScreen({super.key});
  var myObject = 0;
  PelajarScreen({super.key});

  @override
  State<PelajarScreen> createState() => _PelajarScreen();
}

class _PelajarScreen extends State<PelajarScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/myCilik_Logo.png',
              scale: 6,
            ),
          ),
          backgroundColor: Color.fromARGB(0, 46, 41, 41),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: LoaderOverlay(
          reverseDuration: const Duration(milliseconds: 250),
          duration: Duration(milliseconds: 250),
          child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Container(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Pelajar',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w300),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Color(0xFF51A7F5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          height: 250,
                          width: double.maxFinite,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Senarai pelajar',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minWidth: 60.0,
                                            maxWidth: 150.0,
                                            minHeight: 30.0,
                                            maxHeight: 100.0,
                                          ),
                                          //SET max width
                                          child: AutoSizeText(
                                            'Mengemaskini maklumat terkini pelajar, memuatnaik gambar pelajar',
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white),
                                            overflow: TextOverflow.visible,
                                          ))
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Image.asset(
                                      'assets/images/iconpelajarmeja.png',
                                      scale: 1.15,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                child: Container(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF54D159),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Lihat',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SenaraiPelajarScreen()),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Color(0xFFCC3E8A),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          height: 250,
                          width: double.maxFinite,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Status pendaftaran',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minWidth: 60.0,
                                            maxWidth: 150.0,
                                            minHeight: 30.0,
                                            maxHeight: 100.0,
                                          ),
                                          //SET max width
                                          child: AutoSizeText(
                                            'Mengakses status pelajar dan membayar yuran pendaftaran secara atas talian',
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white),
                                            overflow: TextOverflow.visible,
                                          ))
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Image.asset(
                                      'assets/images/tanganklik.png',
                                      scale: 1.15,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                child: Container(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF54D159),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Lihat',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StatusPendaftaranScreen()),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
