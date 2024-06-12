import 'dart:async';
import 'dart:convert';

import 'package:cilikalfateh/ibubapa/pelajar.dart';
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
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';

import 'nav.dart';

class DaftarMaklumatScreen extends StatefulWidget {
  //const HomeScreen({super.key});
  var myObject;
  DaftarMaklumatScreen({required this.myObject});

  @override
  State<DaftarMaklumatScreen> createState() => _DaftarMaklumatScreen();
}

class _DaftarMaklumatScreen extends State<DaftarMaklumatScreen> {
  @override
  List<int> index = [];
  late SharedPreferences logindata;
  TextEditingController pay = TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchUser();
  }

  void fetchUser() {
    // do something

    setState(() {
      index = widget.myObject;
    });
    print(index.toString());
  }

  Future getData() async {
    var url = Uri.parse('${Env.URL_PREFIX}/maklumatPendaftaran.php');

    var response = await http.post(url, body: {
      'id': index.toString(), //get the username text
    });
    return json.decode(response.body);

    //final response = await http.get("${Env.URL_PREFIX}/list.php");
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          bool willLeave = false;
          // show the confirm dialog
          await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text('Are you sure want to leave?'),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            willLeave = true;
                            int index = 0;
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                          myObject: index,
                                        )));
                          },
                          child: const Text('Yes')),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('No'))
                    ],
                  ));
          return willLeave;
        },
        child: Container(
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
          body: FooterView(
              flex: 4,
              footer: Footer(
                padding: EdgeInsets.all(5.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              height: 100,
                              width: 250,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(
                                  width: 3,
                                  color: Colors.orange,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Text('data'),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 120,
                                  height: 45,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    border: Border.all(
                                      width: 3,
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: Text(''),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 120,
                                  height: 45,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    border: Border.all(
                                      width: 3,
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: Text(index.toString()),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width: 120,
                                    height: 45,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      border: Border.all(
                                        width: 3,
                                        color: Colors.green,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Text(
                                      'BAYAR',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
              children: <Widget>[
                LoaderOverlay(
                  reverseDuration: const Duration(milliseconds: 250),
                  duration: const Duration(milliseconds: 250),
                  child: FutureBuilder(
                    future: getData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      return snapshot.hasData
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                List list = snapshot.data;
                                for (int p = 0;
                                    p < snapshot.data.length;
                                    p++) {}

                                return ListTile(
                                  title: Text(list[index]['registerDate'] +
                                      '\n' +
                                      list[index]['statusPayment'] +
                                      '\n' +
                                      'JUMLAH BAYARAN: RM ' +
                                      list[index]['totalPayment'] +
                                      '\n' +
                                      'SUDAH MEMBAYAR: RM' +
                                      list[index]['totalPaid']),
                                );
                              },
                            )
                          : const CircularProgressIndicator();
                    },
                  ),
                ),
              ]),
        )));
  }
}
