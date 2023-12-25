// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giay/page/sign_in.dart';
import 'package:giay/widget/firebase/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Users? users;
  FireAuth fireAuth= FireAuth();

  Future<void> getData()async{
    final idUser= FirebaseAuth.instance.currentUser?.uid;
    final snap= await FirebaseFirestore.instance.collection('user').doc(idUser).get()
      .then((value) => Users.fromJson(value.data()!));
    users=snap;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            buildHeader(),
            buildNameUser(),
            buildMailUser(),
            buildItemProfile(),
          ],
        ),
      )
    );
  }

  Widget buildItemProfile(){
    return Container(
      margin: const EdgeInsets.only(top: 50),
      width: double.maxFinite,
      height: MediaQuery.sizeOf(context).height-300,
      child: Card(
        child: InkWell(
          onTap: () => onLogOut(),
          child: const ListTile(
            leading: Icon(Icons.logout),
            title: Text('Đăng xuất',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600
              ),),
          ),
        ),
      ),
    );
  }

  Widget buildNameUser(){
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Text(
        users?.fullName??'',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700
        ),
      ),
    );
  }

  Widget buildMailUser(){
    return Text(
      users?.emailAddress??'',
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700
      ),
    );
  }

  Widget buildHeader(){
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.only(
        top: 14,
        bottom: 10,
        left: 15,
        right: 15,
      ),
      color: Colors.orangeAccent,
      child: const Text(
        'Hồ sơ người dùng',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white
        )
         
      )
    );
  }

  Future<void> onLogOut()async{
    fireAuth.signOut();
    final pref= await SharedPreferences.getInstance();
    pref.clear();
    await Navigator.pushReplacement(context, MaterialPageRoute(builder: 
      (context) => const SignInScreen(),));
    setState(() {});
  }
}