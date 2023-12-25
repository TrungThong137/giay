// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:giay/page/main_screen.dart';
import 'package:giay/page/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  Timer _startDelay() => _timer = Timer(const Duration(seconds: 2), _init);

  Future<void> goToSignIn(BuildContext context) =>
      Navigator.push(context, MaterialPageRoute(builder: 
      (context) => const SignInScreen(),));

  Future<void> goToHome(BuildContext context) =>
     Navigator.push(context, MaterialPageRoute(builder: 
      (context) => const MainScreen(),));

  Future<void> _init() async {
    print(FirebaseAuth.instance.currentUser?.uid);
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('accessToken');
    if (token == null || token.isEmpty) {
      await goToSignIn(context);
    } else {
      await goToHome(context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Image.asset(
          'assets/splash.jpeg',
          fit: BoxFit.cover,
          width: double.maxFinite,
          height: MediaQuery.sizeOf(context).height,
        ),
      ),
    );
  }
}