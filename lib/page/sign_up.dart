// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:giay/page/sign_in.dart';

import '../widget/widget.dart';
import 'main_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  FireAuth fireAuth= FireAuth();
  TextEditingController mailController= TextEditingController();
  TextEditingController nameController= TextEditingController();
  TextEditingController cnfController= TextEditingController();
  TextEditingController passController= TextEditingController();
  String? messageEmail;
  String? messagePass;
  String? messageConfirmPass;
  String? messageName;
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
                  buildTitleSignUp(),
                  buildFieldEmail(),
                  buildFieldName(),
                  buildFieldPassWord(),
                  buildCnfFieldPassWord(),
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

  Widget buildTitleSignUp(){
    return const Padding(
      padding: EdgeInsets.only(top: 40),
      child: Text(
        "Sign up Your Account",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700
        ) 
      ),
    );
  }

  Widget buildFieldEmail(){
    return AppFormField(
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
    );
  }

  Widget buildFieldName(){
    return AppFormField(
      labelText: 'Họ và Tên',
      hintText: 'Nhập Họ Tên',
      textEditingController: nameController,
      iconPrefix: const Icon(Icons.person_outline, color: Colors.black26,),
      validator: messageName,
      onChanged: (value) {
        validateName(value.trim());
        onEnable();
      },
    );
  }

  Widget buildFieldPassWord(){
    return AppFormField(
      textEditingController: passController,
      labelText: 'Mật khẩu',
      hintText: 'Nhập mật khẩu',
      obscureText: true,
      iconPrefix: const Icon(
        Icons.lock_outline_rounded,
        color: Colors.black38,
      ),
      onChanged: (value){
        validPass(value.trim());
        validatePasswordConfirm(value.trim(), cnfController.text.trim());
        onEnable();
      },
      validator: messagePass,
    );
  }

  Widget buildCnfFieldPassWord(){
    return AppFormField(
      textEditingController: cnfController,
      labelText: 'Xác nhận mật khẩu',
      hintText: 'Nhập mật khẩu',
      obscureText: true,
      iconPrefix: const Icon(
        Icons.lock_outline_rounded,
        color: Colors.black38,
      ),
      onChanged: (value){
        validatePasswordConfirm(passController.text.trim(), value.trim());
        onEnable();
      },
      validator: messageConfirmPass,
    );
  }


  Widget buildButton(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: AppButton(
        onTap:()=> onSignUp(),
        content: 'Sign Up',
        enableButton: enableButton,
      ),
    );
  }

  Widget buildNoteSwitchSignUp(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account? ',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.w500
          ) 
        ),
        const SizedBox(width: 5,),
        InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: 
            (context) => const SignInScreen(),)),
          child: const Text(
            'Sign In',
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

  void onSignUp(){
    LoadingDialog.showLoadingDialog(context, 'Loading...');
    fireAuth.signUp(
      mailController.text.toString().trim(), 
      passController.text.toString().trim(),
      nameController.text.toString().trim(),
      (){
        LoadingDialog.hideLoadingDialog(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: 
          (context) => const MainScreen(),));
      },
      (msg){
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(context, 'Sign-In', msg);
      }
    );
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

  void validateName(String? value){
    if (value == null || value.isEmpty) {
      messageName= 'Vui lòng nhập Họ và tên';
    } else if (value.length < 6) {
      messageName= 'Tên phải trên 6 kí tự';
    }else{
      final regex = RegExp(
        r'^[a-z A-ZỳọáầảấờễàạằệếýộậốũứĩõúữịỗìềểẩớặòùồợãụủíỹắẫựỉỏừỷởóéửỵẳẹèẽổẵẻỡơôưăêâđỲỌÁẦẢẤỜỄÀẠẰỆẾÝỘẬỐŨỨĨÕÚỮỊỖÌỀỂẨỚẶÒÙỒỢÃỤỦÍỸẮẪỰỈỎỪỶỞÓÉỬỴẲẸÈẼỔẴẺỠƠÔƯĂÊÂĐ]+$',
      );
      if (!regex.hasMatch(value)) {
        messageName= 'Không được nhập kí tự đặc biệt';
      }else{
        messageName= null;
      }
    }
    setState(() {});
  }

  void validatePasswordConfirm(String pass, String? confirmPass) {
    if (confirmPass == null || confirmPass.isEmpty) {
      messageConfirmPass= 'Vui lòng xác nhận mật khẩu';
    }else if (confirmPass != pass) {
      messageConfirmPass= 'Mật khẩu xác nhận không trùng khớp';
    }else{
      messageConfirmPass= null;
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
    if (messageEmail==null&& messageName==null &&
      messageConfirmPass==null && messagePass==null &&
        nameController.text!='' && mailController.text!=''
        && passController.text!='' && cnfController.text!='') {
      enableButton = true;
    } else {
      enableButton = false;
    }
    setState(() {});
  }

  @override
  void dispose() {
    mailController.dispose();
    passController.dispose();
    nameController.dispose();
    cnfController.dispose();
    super.dispose();
  }
}