import 'dart:async';
import 'dart:convert';

import 'package:cilikalfateh/ibubapa/pelajarMaklumat.dart';
import 'package:cilikalfateh/model/pelajarModel.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../env.sample.dart';

class SenaraiYuranScreen extends StatefulWidget {
  //const HomeScreen({super.key});
  var myObject = 0;
  SenaraiYuranScreen({super.key});

  @override
  State<SenaraiYuranScreen> createState() => _SenaraiYuranScreen();
}

class _SenaraiYuranScreen extends State<SenaraiYuranScreen> {
  late SharedPreferences logindata;
  late String ic;
  late String tempProfileImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ic = '';
    tempProfileImage = '';

    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();

    setState(() {
      ic = logindata.getString('ic').toString();
    });
  }

  Future getData() async {
    //final response = await http.get("${Env.URL_PREFIX}/list.php");
    var url = Uri.parse('${Env.URL_PREFIX}/senaraiYuran.php');
    var response = await http.post(url, body: {
      'id': ic, //get the username text
    });

    return json.decode(response.body);
  }

  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: null,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          // actionsIconTheme: IconThemeData(color: Colors.white),
          //automaticallyImplyLeading: false, //disable back button

          backgroundColor: Color.fromARGB(0, 46, 41, 41),
          elevation: 0,
        ),
        // backgroundColor: Colors.transparent,
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
                        'Senarai Yuran',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w300),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 700,
                                  child: FutureBuilder(
                                    future: getData(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError)
                                        print(snapshot.error);
                                      return snapshot.hasData
                                          ? ListView.builder(
                                              itemCount: snapshot.data.length,
                                              itemBuilder: (context, index) {
                                                List list = snapshot.data;
                                                return Card(
                                                    color: Colors.white,
                                                    elevation: 2.0,
                                                    child: ListTile(
                                                      contentPadding:
                                                          EdgeInsets.all(15),
                                                      title: Text(list[index]
                                                              ['month'] +
                                                          " " +
                                                          list[index]['year']),
                                                      subtitle: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        textDirection:
                                                            TextDirection.ltr,
                                                        children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 15,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text('Jumlah Telah Dibayar' +
                                                                          " "),
                                                                      Text(list[
                                                                              index]
                                                                          [
                                                                          'totalPaid']),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                          'Jumlah Bayaran'),
                                                                      Text(list[
                                                                              index]
                                                                          [
                                                                          'totalPaid']),
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ),
                                                        ],
                                                      ),
                                                      onTap: () {},
                                                    ));
                                              })
                                          : CircularProgressIndicator();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
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
