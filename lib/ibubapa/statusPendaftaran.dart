import 'dart:async';
import 'dart:convert';

import 'package:cilikalfateh/ibubapa/statusDaftarMaklumat.dart';
import 'package:cilikalfateh/model/pelajarModel.dart';
import 'package:cilikalfateh/model/pendaftaranModel.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:http/http.dart' as http;

import '../env.sample.dart';
import 'pembayaranPendaftaran.dart';

class StatusPendaftaranScreen extends StatefulWidget {
  //const HomeScreen({super.key});
  var myObject = 0;
  StatusPendaftaranScreen({super.key});

  @override
  State<StatusPendaftaranScreen> createState() => _StatusPendaftaranScreen();
}

class _StatusPendaftaranScreen extends State<StatusPendaftaranScreen> {
  late SharedPreferences logindata;
  late String ic;
  late String tempProfileImage;
  late String namaPelajar;
  late String sesi;
  late String mykid;
  late String guardianID;
  int selectedRadio = 0;
  late bool _valu = false;
  Future<List<PendaftaranModel>>? pendaftaran;
  List<PendaftaranModel>? daftar;
  List<bool>? isChecked;
  late double paid, total, baki;

  var selectedIndexes = [];
  List<bool> values = [];
  List multipleSelected = [];
  List<int> selectedItem = [];
  List<bool> checkBoxesCheckedStates = [false];
  late String errormsg;
  late bool error, showprogress;
  late int len;
  var userStatus = <bool>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mykid = '';
    ic = '';
    tempProfileImage = '';
    selectedRadio = 0;
    len = 0;

    //pendaftaran = getPendaftaranList();

    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();

    setState(() {
      ic = logindata.getString('ic').toString();
      print(ic.toString());
    });
  }

  void editCheck() {
    setState(() {});
  }

  Future<List<PendaftaranModel>> getPendaftaranList() async {
    var url = Uri.parse('${Env.URL_PREFIX}/listpendaftaranpelajar.php');
    var response = await http.post(url, body: {
      'id': ic, //get the username text
    });
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<PendaftaranModel> pendaftaran = items.map<PendaftaranModel>((json) {
      return PendaftaranModel.fromJson(json);
    }).toList();

    return pendaftaran;
  }

  Future getData() async {
    //final response = await http.get("${Env.URL_PREFIX}/list.php");

    var url = Uri.parse('${Env.URL_PREFIX}/listpendaftaranpelajar.php');

    var response = await http.post(url, body: {
      'id': ic, //get the username text
    });
    //final items = json.decode(response.body).cast<Map<String, dynamic>>();
    // List<PendaftaranModel> pendaftaran = items.map<PendaftaranModel>((json) {
    //   return PendaftaranModel.fromJson(json);
    // }).toList();

    return json.decode(response.body);
  }

  Future getDataDonePaid() async {
    //final response = await http.get("${Env.URL_PREFIX}/list.php");

    var url =
        Uri.parse('${Env.URL_PREFIX}/listpendaftaranpelajarHabisBayar.php');

    var response = await http.post(url, body: {
      'id': ic, //get the username text
    });
    //final items = json.decode(response.body).cast<Map<String, dynamic>>();
    // List<PendaftaranModel> pendaftaran = items.map<PendaftaranModel>((json) {
    //   return PendaftaranModel.fromJson(json);
    // }).toList();

    return json.decode(response.body);
  }

  Future getDataReject() async {
    //final response = await http.get("${Env.URL_PREFIX}/list.php");

    var url = Uri.parse('${Env.URL_PREFIX}/pendaftaranDitolak.php');

    var response = await http.post(url, body: {
      'id': ic, //get the username text
    });
    //final items = json.decode(response.body).cast<Map<String, dynamic>>();
    // List<PendaftaranModel> pendaftaran = items.map<PendaftaranModel>((json) {
    //   return PendaftaranModel.fromJson(json);
    // }).toList();

    return json.decode(response.body);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Teruskan?'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Anda telah pilih ' +
                    selectedItem.length.toString() +
                    ' resit untuk pembayaran pendaftaran'),
                Text('Pastikan anda memilih pilihan yang betul'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Bayar'),
              onPressed: () {
                print('Confirmed');
                print(selectedItem);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DaftarMaklumatScreen(myObject: selectedItem),
                  ),
                );
              },
            ),
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

//baca pengumuman data dalam firebase
  Stream<List<PendaftaranModel>> readPendaftaran() => FirebaseFirestore.instance
      .collection('pendaftaran')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => PendaftaranModel.fromJson(doc.data()))
          .toList());

  Widget buildPendaftaran(PendaftaranModel e) => Card(
      margin: EdgeInsets.all(14),
      elevation: 15,
      child: ListTile(
        title: Text(e.namaPelajar),
        subtitle: Text(e.sessionIDAdmission.toString()),
        trailing: IconButton(
            icon: Icon(Icons.folder),
            onPressed: () {
              print('object');
            }),
      ));

  @override
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
                        'Status pendaftaran',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w300),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            decoration: BoxDecoration(
                                color: Color(0xFF54D159),
                                borderRadius: BorderRadius.circular(20)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Bayar',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                          onTap: () {
                            if (selectedItem.isEmpty) {
                              var snackBar = SnackBar(
                                  content: Text('Sila klik pilihan dibawah'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              print('object');
                              _showMyDialog();
                            }
                          },
                        )),
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                        child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Pendaftaran Belum Lengkap',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                    )),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            border: Border.all(
                              width: 3,
                              color: Colors.orange,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 180,
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
                                                for (int p = 0;
                                                    p < snapshot.data.length;
                                                    p++) {
                                                  userStatus.add(false);
                                                }

                                                paid = double.parse(
                                                    list[index]['totalPaid']);
                                                total = double.parse(list[index]
                                                    ['totalPayment']);
                                                baki = total - paid;
                                                if (baki > 0) {
                                                } else {}
                                                return ListTile(
                                                  title: Card(
                                                    child: Text(list[index][
                                                            'statusAcceptance'] +
                                                        '\n' +
                                                        list[index]
                                                            ['registerDate'] +
                                                        '\n' +
                                                        list[index]
                                                            ['statusPayment'] +
                                                        '\n' +
                                                        'JUMLAH BAYARAN: RM ' +
                                                        list[index]
                                                            ['totalPayment'] +
                                                        '\n' +
                                                        'SUDAH MEMBAYAR: RM' +
                                                        list[index]
                                                            ['totalPaid']),
                                                  ),
                                                  trailing: Checkbox(
                                                    onChanged: (bool? val) {
                                                      setState(
                                                        () {
                                                          if (userStatus[
                                                                  index] ==
                                                              false) {
                                                            userStatus[index] =
                                                                !userStatus[
                                                                    index];
                                                            selectedItem.add(
                                                                int.parse(list[
                                                                        index]
                                                                    ['id']));
                                                            print('add' +
                                                                list[index]
                                                                    ['id']);
                                                          } else if (userStatus[
                                                                  index] ==
                                                              true) {
                                                            userStatus[index] =
                                                                !userStatus[
                                                                    index];
                                                            selectedItem.remove(
                                                                list[index]
                                                                    ['id']);
                                                            print('remove' +
                                                                list[index]
                                                                    ['id']);
                                                          }
                                                        },
                                                      );
                                                    },
                                                    value: userStatus[index],
                                                  ),
                                                );
                                              },
                                            )
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
                        SizedBox(
                            child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Pendaftaran Lengkap',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                        )),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            border: Border.all(
                              width: 3,
                              color: Colors.green,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 180,
                                  child: FutureBuilder(
                                    future: getDataDonePaid(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError)
                                        print(snapshot.error);
                                      return snapshot.hasData
                                          ? ListView.builder(
                                              itemCount: snapshot.data.length,
                                              itemBuilder: (context, index) {
                                                List list = snapshot.data;
                                                for (int p = 0;
                                                    p < snapshot.data.length;
                                                    p++) {
                                                  userStatus.add(false);
                                                }

                                                paid = double.parse(
                                                    list[index]['totalPaid']);
                                                total = double.parse(list[index]
                                                    ['totalPayment']);
                                                baki = total - paid;
                                                if (baki > 0) {
                                                } else {}
                                                return ListTile(
                                                  title: Card(
                                                    child: Text(list[index]
                                                            ['registerDate'] +
                                                        '\n' +
                                                        list[index]
                                                            ['statusPayment'] +
                                                        '\n' +
                                                        'JUMLAH BAYARAN: RM ' +
                                                        list[index]
                                                            ['totalPayment'] +
                                                        '\n' +
                                                        'SUDAH MEMBAYAR: RM' +
                                                        list[index]
                                                            ['totalPaid']),
                                                  ),
                                                );
                                              },
                                            )
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
                        SizedBox(
                            child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Pendaftaran Ditolak',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                        )),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            border: Border.all(
                              width: 3,
                              color: Colors.red,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 180,
                                  child: FutureBuilder(
                                    future: getDataReject(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError)
                                        print(snapshot.error);
                                      return snapshot.hasData
                                          ? ListView.builder(
                                              itemCount: snapshot.data.length,
                                              itemBuilder: (context, index) {
                                                List list = snapshot.data;
                                                for (int p = 0;
                                                    p < snapshot.data.length;
                                                    p++) {
                                                  userStatus.add(false);
                                                }

                                                paid = double.parse(
                                                    list[index]['totalPaid']);
                                                total = double.parse(list[index]
                                                    ['totalPayment']);
                                                baki = total - paid;
                                                if (baki > 0) {
                                                } else {}
                                                return ListTile(
                                                  title: Card(
                                                    child: Text(list[index]
                                                            ['registerDate'] +
                                                        '\n' +
                                                        list[index]
                                                            ['statusPayment'] +
                                                        '\n' +
                                                        'JUMLAH BAYARAN: RM ' +
                                                        list[index]
                                                            ['totalPayment'] +
                                                        '\n' +
                                                        'SUDAH MEMBAYAR: RM' +
                                                        list[index]
                                                            ['totalPaid']),
                                                  ),
                                                );
                                              },
                                            )
                                          : CircularProgressIndicator();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
