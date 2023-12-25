// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:giay/page/sign_up.dart';

import '../widget/widget.dart';
import 'main_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  FireAuth fireAuth= FireAuth();
  TextEditingController mailController= TextEditingController();
  TextEditingController passController= TextEditingController();
  String? messageEmail;
  String? messagePass;
  bool enableButton=false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () => showExitPopup(context),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  buildHeader(),
                  buildTitleLogin(),
                  buildFieldEmail(),
                  buildFieldPassWord(),
                  buildButton(),
                  buildNoteSwitchSignUp(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLogoApp(){
    return SvgPicture.asset(
      'assets/Logo_Ananas_Header.svg',
      color: Colors.orangeAccent,
    );
  }

  Widget buildNameApp(){
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ananas',
          style: TextStyle(
            fontSize: 25, fontWeight: FontWeight.w500,
            color: Colors.orangeAccent
          )
        ),
      ],
    );
  }

  Widget buildTitleLogin(){
    return const Padding(
      padding: EdgeInsets.only(top: 40),
      child: Text(
        "Login to Your Account",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700
        ) 
      ),
    );
  }

  Widget buildFieldEmail(){
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: AppFormField(
        textEditingController: mailController,
        labelText: 'Email',
        hintText: 'Nhập Email',
        iconPrefix: const Icon(
          Icons.mail_outline,
          color: Colors.black38,
        ),
        onChanged: (value){
          validEmail(value.trim());
          onEnable();
        },
        validator: messageEmail,
      ),
    );
  }

  Widget buildFieldPassWord(){
    return AppFormField(
      textEditingController: passController,
      labelText: 'Password',
      hintText: 'Nhập mật khẩu',
      obscureText: true,
      iconPrefix: const Icon(
        Icons.lock_outline_rounded,
        color: Colors.black38,
      ),
      onChanged: (value){
        validPass(value.trim());
        onEnable();
      },
        validator: messagePass,
    );
  }

  Widget buildButton(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: AppButton(
        onTap:()=> onLogin(),
        content: 'Sign In',
        enableButton: enableButton,
      ),
    );
  }

  Widget buildNoteSwitchSignUp(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don\'t have an account?',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.w500
          ) 
        ),
        const SizedBox(width: 5,),
        InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: 
            (context) => const SignUpScreen(),)),
          child: const Text(
            'Sign up',
            style: TextStyle(
              fontSize: 15,
              color: Colors.orangeAccent,
              fontWeight: FontWeight.w600
            ) 
          ),
        )
      ],
    );
  }

  Widget buildHeader(){
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildLogoApp(),
          const SizedBox(width: 10,),
          buildNameApp(),
        ],
      ),
    );
  }

  void onLogin(){
    LoadingDialog.showLoadingDialog(context, 'loading...');
    fireAuth.signIn(mailController.text.trim(), passController.text.trim(),
      () {
        LoadingDialog.hideLoadingDialog(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: 
          (context) => const MainScreen(),));
      },(msg) {
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, 'Error', msg);
    });
    setState(() {});
  }

  void validEmail(String? value){
    if (value == null || value.isEmpty) {
      messageEmail= 'Vui lòng nhập email';
    } else {
      final regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
      );
      if (!regex.hasMatch(value)) {
        messageEmail= 'Email không hợp lệ';
      } else {
        messageEmail= null;
      }
    }
    setState(() {});
  }

  void validPass(String? value){
    if (value == null || value.isEmpty) {
      messagePass= 'Vui lòng nhập mật khẩu';
    }else if (value.length < 8 || value.length > 16) {
      messagePass= 'Mật khẩu phải lớn hơn 8 kí tự và nhỏ hơn 16 kí tự';
    }else{
      messagePass= null;
    }
    setState(() {});
  }

  void onEnable(){
    if(messageEmail==null && messagePass==null &&
      mailController.text.trim().isNotEmpty && passController.text.trim().isNotEmpty){
      enableButton=true;
    }else{
      enableButton=false;
    }
    setState(() {});
  }

  @override
  void dispose() {
    mailController.dispose();
    passController.dispose();
    super.dispose();
  }
}