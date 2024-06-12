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

class YuranMaklumatScreen extends StatefulWidget {
  //const HomeScreen({super.key});
  var myObject;
  YuranMaklumatScreen({required this.myObject});

  @override
  State<YuranMaklumatScreen> createState() => _YuranMaklumatScreen();
}

class _YuranMaklumatScreen extends State<YuranMaklumatScreen> {
  @override
  String index = '';
  late SharedPreferences logindata;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void fetchUser() {
    // do something

    setState(() {
      index = widget.myObject.toString();
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
                Text(index.toString()),
                FutureBuilder(
                  builder: (ctx, snapshot) {
                    // Checking if future is resolved or not
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If we got an error
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            '${snapshot.error} occurred',
                            style: TextStyle(fontSize: 18),
                          ),
                        );

                        // if we got our data
                      } else if (snapshot.hasData) {
                        // Extracting data from snapshot object
                        List list = snapshot.data;
                        int i = snapshot.data.length;
                        return Center(
                          child: Text(snapshot.data),
                        );
                      }
                    }

                    // Displaying LoadingSpinner to indicate waiting state
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },

                  // Future that needs to be resolved
                  // inorder to display something on the Canvas
                  future: getData(),
                ),
              ],
            ),
          ])),
        ),
      ),
    ));
  }
}
