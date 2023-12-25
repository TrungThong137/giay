// ignore_for_file: unused_field, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:giay/page/cart_screen.dart';
import 'package:giay/page/home.dart';
import 'package:giay/page/profile_screen.dart';

import '../widget/widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.page});

  final int? page;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int selectedIndex=0;

  @override
  void initState() {
    setState(() {
      selectedIndex=widget.page??0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: getBody(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          selectedIconTheme: const IconThemeData(
            color: Colors.orangeAccent,
            size: 30
          ),
          selectedItemColor: Colors.orangeAccent,
          unselectedIconTheme: IconThemeData(
            color: Colors.grey.withOpacity(0.8),
            size: 20
          ),
          onTap: (index)=> changePage(index),
          items: const[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label:"Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label:"Profile",
            ),
          ],
        ),
      ),
    );
  }

  Widget getBody()  {
    if(selectedIndex == 0) {
      return const HomeScreen();
    } else if(selectedIndex==1) {
      return const CartScreen();
    } else{
      return const ProfileScreen();
    }
  }

  void changePage(int index){
    setState(() {selectedIndex=index;});
  }
}