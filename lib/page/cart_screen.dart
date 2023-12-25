import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giay/model/model.dart';
import 'package:giay/page/buy_shoe_screen.dart';
import 'package:giay/page/payment_screen.dart';
import 'package:giay/widget/firebase/firebase_shoe.dart';
import 'package:giay/widget/widget.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  List<ShoeCartModel> listShoeCart=[];
  List<ShoeCartModel> listShoePayment=[];
  List<TextEditingController> listControllerSize=[];
  List<TextEditingController> listControllerQuantity=[];
  int? totalMoney;
  Timer? timer;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData()async{
    final idUser= FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance.collection('Gio')
      .where('idUser', isEqualTo: idUser).snapshots()
      .map((snapshot) => snapshot.docs.map((shoe) 
        => ShoeCartModel.fromJson(shoe.data())).toList()
    ).listen((shoeCart) { 
      listShoeCart=shoeCart;
      listControllerSize= List.generate(listShoeCart.length, (index) => TextEditingController());
      listControllerQuantity= List.generate(listShoeCart.length, (index) => TextEditingController());
      for (var i = 0; i < listShoeCart.length; i++) {
        listControllerQuantity[i].text= listShoeCart[i].quantity.toString();
        listControllerSize[i].text= listShoeCart[i].size.toString();
      }
      timer = Timer(const Duration(milliseconds: 10),() => setState(() {}));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildHeader(),
              buildListShoeCart(),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: buildButton(),
      )
    );
  }
  
  Widget buildImageShoe(int index) { 
    final image = listShoeCart[index].image;
    return Image.network(
      image,
      fit: BoxFit.cover,
      width: 115,
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
    );
  }

  Widget buildNameShoe(int index){
    final nameShoe= listShoeCart[index].name;
    return Text(
      nameShoe,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600
      ),
    );
  }

  Widget buildPriceShoe(int index, {bool isTotal=false}){
    final priceShoe= isTotal? setTotalMoney(index) :listShoeCart[index].price;
    return Row(
      children: [
        Visibility(
          visible: !isTotal,
          child: const Text(
            'Giá: ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey
            ),
          ),
        ),
        Text(
          priceShoe.toString(),
          style: TextStyle(
            fontSize: isTotal?10: 15,
            fontWeight: FontWeight.w600,
            color: isTotal? Colors.red: Colors.grey
          ),
        ),
      ],
    );
  }

  Widget buildSizeAndQuantityShoe(int index){
    return SizeAndQuantityWidget(
      quantityController: listControllerQuantity[index], 
      sizeController: listControllerSize[index],
      width: 220,
      isOntap: true,
      onEnable: (isEnable) => upDateSizeAndQuantity(index),
    );
  }

  Widget buildInformationShoe(int index){
    return Container(
      padding: const EdgeInsets.only(left: 2),
      width: MediaQuery.sizeOf(context).width-197,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildNameShoe(index),
          buildPriceShoe(index),
          buildSizeAndQuantityShoe(index),
        ],
      ),
    );
  }

  Widget buildButtonDeleteShoe(int index){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () => deleteShoe(index),
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(5),
          width: 70,
          child: const Icon(Icons.delete, color: Colors.white,),
        ),
      ),
    );
  }

  Widget buildButtonPayment(int index){
    return AppButton(
      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: 
        (context) => PaymentScreen(shoeCartModel: setListShoePayment(index), isCart: true,),)),
      width: 70,
      content: 'Mua',
      enableButton: true,
    );
  }

  Widget buildTotalPriceAndButton(int index){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        buildPriceShoe(index, isTotal: true),
        buildButtonDeleteShoe(index),
        buildButtonPayment(index),
      ],
    );
  }

  Widget buildListShoeCart(){
    return SizedBox(
      height: MediaQuery.sizeOf(context).height-140,
      width: double.maxFinite,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: listShoeCart.length,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(top: 10),
          child: InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: 
              (context) => BuyShoeScreen(shoeModel: listShoeCart[index]),)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildImageShoe(index),
                buildInformationShoe(index),
                buildTotalPriceAndButton(index),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtonFloating(String title, {Function()? onTap}){
    return SizedBox(
      width: 120,
      child: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: ()=> onTap!(),
        child: Text(title, style: const TextStyle(color: Colors.white),),
      ),
    );
  }

  Widget buildButton(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildButtonFloating('Xóa hết', onTap: () => deleteShoeAll(),),
          buildButtonFloating('Thanh toán hết', 
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: 
              (context) => PaymentScreen(
                shoeCartModel: listShoeCart, isCart: true,
              ),
            )),
          ),
        ],
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
        'Giỏ hàng',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white
        )
      )
    );
  }

  String setTotalMoney(int index){
    final price= listShoeCart[index].price.split(' ')[0];
    final priceShoe= int.parse(price.replaceAll('.', ''))*listShoeCart[index].quantity;
    return '${NumberFormat('###,###,###.##', 'en_us')
          .format(priceShoe)
          .replaceAll(RegExp('[,]'), '.')} VND';
  }

  void upDateSizeAndQuantity(int index){
    listShoeCart[index].quantity=int.parse(listControllerQuantity[index].text);
    listShoeCart[index].size=double.parse(listControllerSize[index].text);
    FireStoreShoe.updateShoeCart(listShoeCart[index]);
    getData();
  }

  void deleteShoe(int index){
    FireStoreShoe.deleteShoeCart(listShoeCart[index]);
  }

  void deleteShoeAll(){
    for (var element in listShoeCart) {
      FireStoreShoe.deleteShoeCart(element);
    }
  }

  List<ShoeCartModel> setListShoePayment(int index){
    listShoePayment.clear();
    listShoePayment.add(listShoeCart[index]);
    return listShoePayment;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}