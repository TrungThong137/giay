// ignore_for_file: iterable_contains_unrelated_type, unused_local_variable

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giay/model/model.dart';
import 'package:giay/page/payment_screen.dart';
import 'package:giay/widget/firebase/firebase_shoe.dart';
import 'package:giay/widget/widget.dart';

class BuyShoeScreen extends StatefulWidget {
  const BuyShoeScreen({super.key, required this.shoeModel});

  final ShoeCartModel shoeModel;

  @override
  State<BuyShoeScreen> createState() => _BuyShoeScreenState();
}

class _BuyShoeScreenState extends State<BuyShoeScreen> {

  late final ShoeCartModel? shoe;
  TextEditingController sizeController= TextEditingController();
  TextEditingController quantityController= TextEditingController();
  List<ShoeCartModel> listShoeCart=[];
  List<ShoeCartModel> listShoePayment=[];
  bool isEnableButton=false;
  Timer? timer;

  Future<void> getData()async{
    final idUser= FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance.collection('Gio')
      .where('idUser', isEqualTo: idUser).snapshots()
      .map((snapshot) => snapshot.docs.map((shoe) 
        => ShoeCartModel.fromJson(shoe.data())).toList()
    ).listen((shoeCart) { 
      listShoeCart=shoeCart;
      timer = Timer(const Duration(milliseconds: 10),() => setState(() {}));
    });
  }

  @override
  void initState() {
    shoe=widget.shoeModel;
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Mua giày',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black
            )
          ),
        ),
        body: Column(
          children: [
            buildImageShoe(),
            buildNameShoe(),
            buildPriceShoe(),
            buildSizeAndQuantityShoe(),
            buildButtonAddCard(),
            buildButtonPayment(),
          ],
        ),
      )
    );
  }

  Widget buildButtonAddCard(){
    return Padding(
      padding: const EdgeInsets.only(top: 30, right: 10, left: 10, bottom: 10),
      child: AppButton(
        content: 'Thêm vào giỏ hàng',
        onTap: ()=> onAddCart(),
        enableButton: isEnableButton,
        color: Colors.black,
      ),
    );
  }

  Widget buildButtonPayment(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: AppButton(
        content: 'Thanh toán',
        onTap: ()=> onPayment(),
        enableButton: isEnableButton,
      ),
    );
  }

  Widget buildSizeAndQuantityShoe(){
    return SizeAndQuantityWidget(
      quantityController: quantityController, 
      sizeController: sizeController,
      isOntap: true,
      onEnable: (isEnable) => setState(() {
        isEnableButton=isEnable;
      }),
    );
  }

  Widget buildNameShoe(){
    return Text(
      shoe?.name??'',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w600
      ),
    );
  }

  Widget buildPriceShoe(){
    return Text(
      shoe?.price??'',
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.red
      ),
    );
  }

  Widget buildImageShoe() {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      child: Image.network(
        shoe?.image ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmVfPm6hKZTky6SpTNvEZqaqa8frwh_4Y2Mj4ERoDp0ammsl4LYgjM3VJHBjITmADt8lg&usqp=CAU',
        fit: BoxFit.fitWidth,
        height: 320,
        width: double.maxFinite,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              color: Colors.orangeAccent,
            ),
          );
        },
      ),
    );
  }

  Future<void> onAddCart()async{
    LoadingDialog.showLoadingDialog(context, 'Loading...');
    createInformationShoe(
      (){
        LoadingDialog.hideLoadingDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã Thêm vào giỏ hàng thành công!'),)
        );
        getData();
      },
      (msg) {
        LoadingDialog.hideLoadingDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg),)
      );}
    );
    setState(() {});
  }

  List<ShoeCartModel> setListShoePayment(){
    final userId= FirebaseAuth.instance.currentUser?.uid;
    final size= double.parse(sizeController.text.trim());
    final quantity= int.parse(quantityController.text.trim());
    listShoePayment.clear();
    listShoePayment.add(
       ShoeCartModel(
      id: '',
      idUser: userId,
      image: shoe?.image??'',
      name: shoe?.name??'',
      price: shoe?.price??'',
      quantity: quantity,
      shoeCode: shoe?.shoeCode??'',
      size: size
    ));
    return listShoePayment;
  }

  Future<void> onPayment()async{
    Navigator.push(context, MaterialPageRoute(builder: 
      (context) => PaymentScreen(shoeCartModel: setListShoePayment()),));
    getData();
  }

  Future<void> createInformationShoe(Function onSuccess,Function(String) onError) async{
      final userId= FirebaseAuth.instance.currentUser?.uid;
      final size= double.parse(sizeController.text.trim());
      final quantity= int.parse(quantityController.text.trim());
      bool isTrue=false;
      for (var element in listShoeCart) {
        if(element.name.contains(shoe!.name) && element.size==size){
          isTrue=true;
          setState(() {});
          return;
        }
      }

      if(isTrue==true){
        final shoeModel= listShoeCart.where((element) 
          => element.name.contains(shoe!.name) && element.size== size).first;
        shoeModel.quantity=shoeModel.quantity+quantity;
        FireStoreShoe.updateShoeCart(shoeModel)
          .then((value) => onSuccess()).catchError((onError)=> onError);
      }else{
        FireStoreShoe.createShoeInformationInCart(ShoeCartModel(
          id: '',
          idUser: userId,
          image: shoe?.image??'',
          name: shoe?.name??'',
          price: shoe?.price??'',
          quantity: quantity,
          shoeCode: shoe?.shoeCode??'',
          size: size
        )).then((value) => onSuccess()).catchError((err)=> onError(err.toString()));
      }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}