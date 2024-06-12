import 'dart:async';
import 'dart:convert';

import 'package:cilikalfateh/model/pelajarModel.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../env.sample.dart';
import '../model/pelajarModel.dart';

class PelajarMaklumatScreen extends StatefulWidget {
  //const HomeScreen({super.key});
  final String student;

  PelajarMaklumatScreen({required this.student});

  @override
  State<PelajarMaklumatScreen> createState() => _PelajarMaklumatScreen();
}

class _PelajarMaklumatScreen extends State<PelajarMaklumatScreen> {
  @override
  String index = '';
  late SharedPreferences logindata;
  late Future<List<PelajarModel>> pelajar;
  final studentListKey = GlobalKey<_PelajarMaklumatScreen>();
  late String fullname;
  late String noIC;
  late String dateOfBirth;
  late String addressID;
  late String healthID;

  @override
  void initState() {
    super.initState();
    index = widget.student.toString();
    fullname = '';
    noIC = '';
    dateOfBirth = '';
    addressID = '';
    healthID = '';
    fetchUser();
  }

  fetchUser() async {
    // do something
    var url = Uri.parse('${Env.URL_PREFIX}/detailStudent.php');
    var response = await http.post(url, body: {
      'id': index.toString(), //get the username text
    });

    var jsondata = json.decode(response.body);

    setState(() {
      fullname = jsondata["fullname"].toString();
      noIC = jsondata["noIC"].toString();
      dateOfBirth = jsondata["dateOfBirth"].toString();
      addressID = jsondata["addressID"].toString();
      healthID = jsondata["healthID"].toString();
    });
  }

  Future getData() async {
    //final response = await http.get("${Env.URL_PREFIX}/list.php");
    var url = Uri.parse('${Env.URL_PREFIX}/detailStudent.php');
    var response = await http.post(url, body: {
      'id': index.toString(), //get the username text
    });

    return json.decode(response.body);
  }

  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        //automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(0, 46, 41, 41),
        elevation: 0,
      ),
      //backgroundColor: Colors.transparent,
      body: LoaderOverlay(
        reverseDuration: const Duration(milliseconds: 250),
        duration: const Duration(milliseconds: 250),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Container(
              child: Column(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            // change background color to image
                            // set img = 'your_url_img'
                            child: ProfilePicture(
                              name: fullname,
                              radius: 50,
                              fontsize: 21,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: 100.0,
                                      maxWidth: 180.0,
                                    ),
                                    //SET max width
                                    child: AutoSizeText(
                                      fullname,
                                      overflow: TextOverflow.visible,
                                      minFontSize: 18,
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'hubungan',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                child: Container(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 224, 113, 49),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'KEMASKINI MAKLUMAT',
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.white),
                                    ),
                                  ),
                                ),
                                onTap: () => print('object'),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                        height: 450,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromARGB(255, 235, 235, 235),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'MAKLUMAT',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'NO. KAD PENGENALAN/PASSPORT',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        ' ids.toUpperCase().toString()',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'NO. TELEFON',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'phone,',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'EMEL',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'emel',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'BIL. ANAK',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        ' bilAnak',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'ALAMAT',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'alamat',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromARGB(255, 235, 235, 235),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'KESIHATAN',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'STATUS KESIHATAN',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'pekerjaan.toUpperCase()',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ))
                  ],
                )
              ],
            ),
          ])),
        ),
      ),
    ));
  }
}
