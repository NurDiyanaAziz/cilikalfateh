import 'dart:async';
import 'dart:convert';

import 'package:cilikalfateh/ibubapa/editProfileGuardian.dart';
import 'package:cilikalfateh/pilihan.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../env.sample.dart';

class ProfilScreen extends StatefulWidget {
  //const HomeScreen({super.key});
  var myObject = 0;
  ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreen();
}

class _ProfilScreen extends State<ProfilScreen> {
  late String tempProfileImage;
  late SharedPreferences logindata;

  late String hubungan;
  late String errormsg;
  late bool error, showprogress;
  late String uid;
  late String fullname;
  late String ic;
  late String work;

  @override
  void initState() {
    tempProfileImage = '';
    work = '';
    hubungan = '';
    uid = '';
    fullname = '';
    ic = '';

    initial();
    // TODO: implement initState
    super.initState();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    //tempProfileImage = 'assets/images/geeksforgeeks.jpg';
    ic = logindata.getString('ic').toString();

    hubungan = logindata.getString('relation').toString();
    work = logindata.getString('workID').toString();
    fullname = logindata.getString('fullname').toString();
  }

  Future getData() async {
    //final response = await http.get("${Env.URL_PREFIX}/list.php");
    var url = Uri.parse('${Env.URL_PREFIX}/parentprofile.php');
    var response = await http.post(url, body: {
      'id': ic, //get the username text
    });
    final items = json.decode(response.body).cast<Map<String, dynamic>>();

    return json.decode(response.body);
  }

  Future getDataWork() async {
    //final response = await http.get("${Env.URL_PREFIX}/list.php");
    var url = Uri.parse('${Env.URL_PREFIX}/parentwork.php');
    var response = await http.post(url, body: {
      'id': work, //get the username text
    });
    final items = json.decode(response.body).cast<Map<String, dynamic>>();

    return json.decode(response.body);
  }

  Future getAddress(String id) async {
    var url = Uri.parse('${Env.URL_PREFIX}/getAddress.php');
    var response = await http.post(url, body: {
      'id': id, //get the username text
    });
    final items = json.decode(response.body).cast<Map<String, dynamic>>();

    return json.decode(response.body);
  }

  void handleClick(String value) {
    switch (value) {
      case 'Log keluar':
        logindata.setBool('login', true);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => PilihanScreen()));

        break;
      case 'Tukar kata laluan':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(0, 46, 41, 41),
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Tukar kata laluan', 'Log keluar'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
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
                    SizedBox(
                      height: 150,
                      child: FutureBuilder(
                        future: getData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          return snapshot.hasData
                              ? ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    var list = snapshot.data[index];
                                    String i = list['id'];
                                    return Container(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                                  // change background color to image
                                                  // set img = 'your_url_img'
                                                  child: ProfilePicture(
                                                    name: list['name'],
                                                    radius: 50,
                                                    fontsize: 21,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: ConstrainedBox(
                                                          constraints:
                                                              const BoxConstraints(
                                                            minWidth: 100.0,
                                                            maxWidth: 180.0,
                                                          ),
                                                          //SET max width
                                                          child: AutoSizeText(
                                                            list['name'],
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                            minFontSize: 18,
                                                          )),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        list['relation'],
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    InkWell(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10,
                                                                bottom: 10),
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    224,
                                                                    113,
                                                                    49),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            'KEMASKINI MAKLUMAT',
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () =>
                                                          Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditProfileGuardianScreen(
                                                                    myObject:
                                                                        i)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                              : CircularProgressIndicator();
                        },
                      ),
                    ),
                    SizedBox(
                        child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 330,
                            child: FutureBuilder(
                              future: getData(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  print(snapshot.error);
                                }
                                return snapshot.hasData
                                    ? ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          var list = snapshot.data[index];
                                          String idAddress = list['addressID'];
                                          var list2 = getAddress(idAddress);

                                          return Column(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: const Color.fromARGB(
                                                      255, 235, 235, 235),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            'MAKLUMAT',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    const Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        'NO. KAD PENGENALAN/PASSPORT',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        list['noIC'],
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    const Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        'NO. TELEFON',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        list['noTel'],
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    const Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        'EMEL',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        list['email'],
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    const Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        'BIL. ANAK',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        list['childAmount'] ??
                                                            '-',
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    SizedBox(
                                                      height: 50,
                                                      child: FutureBuilder(
                                                        future: getAddress(
                                                            list['addressID']),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot.hasError)
                                                            print(
                                                                snapshot.error);
                                                          return snapshot
                                                                  .hasData
                                                              ? ListView
                                                                  .builder(
                                                                      physics:
                                                                          NeverScrollableScrollPhysics(),
                                                                      itemCount: snapshot
                                                                          .data
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        var list2 =
                                                                            snapshot.data[index];
                                                                        return Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                235,
                                                                                235,
                                                                                235),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Align(
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
                                                                                  list2['first'] + ' ' + list2['second'] + ' ' + list2['city'] + ' ' + list2['postcode'] + ' ' + list2['state'],
                                                                                  style: const TextStyle(
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.w400,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      })
                                                              : CircularProgressIndicator();
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          );
                                        })
                                    : CircularProgressIndicator();
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 300,
                            child: FutureBuilder(
                              future: getDataWork(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) print(snapshot.error);
                                return snapshot.hasData
                                    ? ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          var list = snapshot.data[index];
                                          return Container(
                                            padding: const EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: const Color.fromARGB(
                                                  255, 235, 235, 235),
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        'PEKERJAAN',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
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
                                                    'PEKERJAAN',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    list['name'] ?? 'null',
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                const Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    'NAMA MAJIKAN',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    list['company'] ?? 'null',
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                const Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    'NO TELEFON MAJIKAN',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    list['noTel'] ?? 'null',
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        })
                                    : CircularProgressIndicator();
                              },
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
