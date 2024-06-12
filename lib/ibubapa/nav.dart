import 'dart:async';

import 'package:cilikalfateh/ibubapa/akademik.dart';
import 'package:cilikalfateh/ibubapa/pelajar.dart';
import 'package:cilikalfateh/ibubapa/profil.dart';
import 'package:cilikalfateh/ibubapa/yuran.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

import 'homepage.dart';

class HomeScreen extends StatefulWidget {
  //const HomeScreen({super.key});
  var myObject = 0;
  HomeScreen({required this.myObject});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initial();
  }

  void initial() async {
    setState(() {
      _selectedIndex = widget.myObject;
    });
  }

  final _items = [
    PelajarScreen(),
    YuranScreen(),
    HomePageScreen(),
    AkademikScreen(),
    ProfilScreen()
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: IndexedStack(
              index: _selectedIndex,
              children: _items) //_items.elementAt(_index),
          ),
      bottomNavigationBar: _showBottomNav(),
    );
  }

  Widget _showBottomNav() {
    return FloatingNavbar(
      backgroundColor: Color.fromARGB(255, 224, 113, 49),
      elevation: 30,
      //type: ,
      fontSize: 10,
      items: [
        FloatingNavbarItem(
          icon: Icons.people,
          title: 'Pelajar',
        ),
        FloatingNavbarItem(
          icon: Icons.payments,
          title: 'Yuran',
        ),
        FloatingNavbarItem(
          icon: Icons.home,
          title: 'Utama',
        ),
        FloatingNavbarItem(
          icon: Icons.book,
          title: 'Akademik',
        ),
        FloatingNavbarItem(
          icon: Icons.person,
          title: 'Profil',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Color.fromARGB(255, 202, 85, 43),
      unselectedItemColor: Color.fromARGB(255, 255, 255, 255),
      margin: EdgeInsets.symmetric(horizontal: 10),
      onTap: _onTap,
    );
  }

  void _onTap(int index) {
    _selectedIndex = index;
    setState(() {});
  }
}
