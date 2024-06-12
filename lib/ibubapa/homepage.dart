import 'dart:async';
import 'dart:convert';

import 'package:cilikalfateh/model/pengumumanModel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import '../env.sample.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  HomePage createState() => HomePage();
}

class HomePage extends State<HomePageScreen> {
  //Your code here
  late SharedPreferences logindata;
  late String ic;
  late String username;
  late String bilAnak;

  @override
  void initState() {
    username = '';
    bilAnak = '';
    initial();
    // TODO: implement initState
    super.initState();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();

    setState(() {
      ic = logindata.getString('ic').toString();
      bilAnak = logindata.getString('childAmount').toString();
    });
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

  Future getDataActivities() async {
    //final response = await http.get("${Env.URL_PREFIX}/list.php");
    var url = Uri.parse('${Env.URL_PREFIX}/getActivities.php');
    var response = await http.post(url, body: {
      //get the username text
    });
    final items = json.decode(response.body).cast<Map<String, dynamic>>();

    return json.decode(response.body);
  }

//baca pengumuman data dalam firebase
  Stream<List<PengumumanModel>> readPengumuman() => FirebaseFirestore.instance
      .collection('pengumuman')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => PengumumanModel.fromJson(doc.data()))
          .toList());

  Widget buildMeals(PengumumanModel e) => Card(
      margin: EdgeInsets.all(14),
      elevation: 15,
      child: ListTile(
        title: Text(e.nama),
        subtitle: Text("YURAN: RM" + e.yuran.toString()),
        trailing: IconButton(
            icon: Icon(Icons.view_agenda),
            onPressed: () {
              openDialogs(e);
            }),
      ));

  Future openDialogs(PengumumanModel e) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: Container(
            height: 400,
            width: 450,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'MAKLUMAT AKTIVITI',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    DataTable(
                        headingRowHeight: 0,
                        dataRowHeight: 160,
                        columnSpacing: 5,
                        columns: [
                          DataColumn(
                              label: Text(
                            ''.toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                          DataColumn(
                              label: Text(
                            ''.toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(Text('ANJURAN')),
                            DataCell(ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: 200), //SET max width
                                child: Text(e.anjuran,
                                    overflow: TextOverflow.visible))),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('NAMA')),
                            DataCell(ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: 150), //SET max width
                                child: Text(e.nama,
                                    overflow: TextOverflow.visible))),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('PENERANGAN')),
                            DataCell(ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 160.0,
                                  maxWidth: 160.0,
                                  minHeight: 70.0,
                                  maxHeight: 100.0,
                                ),
                                //SET max width
                                child: AutoSizeText(
                                  e.penerangan,
                                  overflow: TextOverflow.visible,
                                ))),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('YURAN')),
                            DataCell(ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: 150), //SET max width
                                child: Text('RM' + e.yuran,
                                    overflow: TextOverflow.visible))),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('TARIKH MULA')),
                            DataCell(ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: 150), //SET max width
                                child: Text(e.tarikhMula,
                                    overflow: TextOverflow.visible))),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('TARIKH TAMAT')),
                            DataCell(ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: 150), //SET max width
                                child: Text(e.tarikhTamat,
                                    overflow: TextOverflow.visible))),
                          ])
                        ])
                  ],
                ),
              ),
            ),
          ),
        );
      });

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
                    SizedBox(
                      height: 25,
                      child: FutureBuilder(
                        future: getData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          return snapshot.hasData
                              ? ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    var list = snapshot.data[index];

                                    bilAnak = list['childAmount'];

                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Hi ' + list['name'] + ',',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    );
                                  })
                              : CircularProgressIndicator();
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Selamat Datang',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w300),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Pilihan',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Color(0xFFA1ADE9),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            height: 250,
                            width: 170,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Pelajar',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                          'assets/images/circle.png'),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child:
                                          Image.asset('assets/images/topi.png'),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    'Bil. pelajar: $bilAnak',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            print("Tapped on container");
                          },
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Color(0xFFFB8B8B),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            height: 250,
                            width: 170,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Yuran',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                          'assets/images/circle.png'),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Image.asset(
                                          'assets/images/bilbayar.png'),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Bulanan: RM',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Tahunan: RM',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            print("Tapped on container");
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Pengumuman',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 200,
                      child: DefaultTabController(
                          length: 2,
                          child: Scaffold(
                            appBar: PreferredSize(
                              preferredSize: _tabBar.preferredSize,
                              child: Material(
                                color: Color.fromARGB(
                                    255, 224, 113, 49), //<-- SEE HERE
                                child: _tabBar,
                              ),
                            ),
                            body: TabBarView(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10),
                                  height: double.infinity,
                                  child: Flexible(
                                    flex: 1,
                                    child: FutureBuilder(
                                      future: getDataActivities(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError)
                                          print(snapshot.error);
                                        return snapshot.hasData
                                            ? ListView.builder(
                                                itemCount: snapshot.data.length,
                                                itemBuilder: (context, index) {
                                                  var list =
                                                      snapshot.data[index];

                                                  //String
                                                  return Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              235,
                                                              235,
                                                              235),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          list['title'],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        Text(
                                                          list['duration'],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w400,
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
                                ),
                                Container(
                                  child: SingleChildScrollView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        // buildPref(),
                                        const SizedBox(
                                          height: 40,
                                          child: Text(
                                            "Tiada",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),

                                        // buildPrefBtn(),
                                        //buildPreferCheckBox(),

                                        //buildUserPreference(),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

TabBar get _tabBar => TabBar(
      splashBorderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      indicatorColor: Colors.white,
      indicatorWeight: 3,
      unselectedLabelColor: Color.fromARGB(255, 184, 183, 183),
      tabs: [
        Text(
          "Aktiviti/Program",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          "Cuti Sekolah",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
OutlineInputBorder myinputborder() {
  //return type is OutlineInputBorder
  return const OutlineInputBorder(
      //Outline border type for TextFeild
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        color: Color.fromARGB(255, 130, 130, 130),
        width: 3,
      ));
}

OutlineInputBorder myfocusborder() {
  return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        color: Colors.greenAccent,
        width: 3,
      ));
}
