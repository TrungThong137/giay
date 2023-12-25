import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:giay/model/model.dart';
import 'package:giay/page/buy_shoe_screen.dart';
import 'package:giay/page/main_screen.dart';
import 'package:giay/widget/widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<ShoeModel> listShoe = [];
  List<ShoeModel> listCurrent = [];
  List<ShoeCartModel> listShoeCart = [];
  String? messSearch;
  TextEditingController searchController= TextEditingController();
  Timer? timer;

   @override
  void initState() {
    getData();
    getDataShoeCart();
    super.initState();
  }

  Future<void> getData()async{
    FirebaseFirestore.instance.collection('Giay').snapshots()
    .map((snapshot) => snapshot.docs.map((shoe) 
      => ShoeModel.fromJson(shoe.data())).toList()
    ).listen((event) { 
      listShoe=event;
      listCurrent=listShoe;
      timer = Timer(const Duration(milliseconds: 10),() => setState(() {}));
    });
  }

  Future<void> getDataShoeCart()async{
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildHeader(),
              buildAppBar(),
              buildListShoe(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImageShoe(int index) {
    final image = listCurrent[index].image;
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      child: Image.network(
        image,
        fit: BoxFit.cover,
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

  Widget buildNameShoe(int index){
    final nameShoe= listCurrent[index].name;
    return Text(
      nameShoe,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600
      ),
    );
  }

  Widget buildPriceShoe(int index){
    final nameShoe= listCurrent[index].price;
    return Text(
      nameShoe,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.red
      ),
    );
  }

  Widget buildCardShoe(int index){
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (context) => BuyShoeScreen(shoeModel: setModelShoeCartModel(index)),)),
      child: Column(
        children: [
          buildImageShoe(index),
          buildNameShoe(index),
          buildPriceShoe(index),
        ],
      ),
    );
  }

  Widget buildListShoe(){
    return Container(
      height: MediaQuery.sizeOf(context).height-250,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 240,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ), 
        itemCount: listCurrent.length,
        itemBuilder: (context, index) => buildCardShoe(index),
      ),
    );
  }

  Widget buildLogoApp(){
    return InkWell(
      onTap: () => setState(() {
        listCurrent=listShoe;
      }),
      child: SvgPicture.asset(
        'assets/Logo_Ananas_Header.svg',
        height: 60,
        color: Colors.orangeAccent,
      ),
    );
  }

  Widget buildFieldSearch(){
    return AppFormField(
      width: 250,
      onChanged: (value) => searchShoe(value),
      textEditingController: searchController,
      suffixIcon: const Icon(Icons.search),
      validator: messSearch,
    );
  }

  Widget buildCard(){
    return InkWell(
      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => const MainScreen(page: 1),)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Image.asset(
            'assets/cart.png',
          ),
          Text(
            '(${listShoeCart.length})'
          )
        ],
      ),
    );
  }

  Widget buildAppBar(){
    return Container(
      height: 90,
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLogoApp(),
          buildFieldSearch(),
          buildCard(),
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
        'Home',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white
        )
         
      )
    );
  }

  ShoeCartModel setModelShoeCartModel(int index){
    return ShoeCartModel(
      id: '', shoeCode: listShoe[index].shoeCode, image: listShoe[index].image, 
      name: listShoe[index].name, price: listShoe[index].price, 
      size: 0, quantity: 0, idUser: ''
    );
  }

  void searchShoe(String? name){
    if(name==null || name==''){
      listCurrent=listShoe;
    }else{
      listCurrent= listShoe.where((element) 
        => element.name.toLowerCase().contains(name.toLowerCase())).toList();
      if(listCurrent.isNotEmpty){
        messSearch=null;
      }else{
        messSearch='Không tìm thấy $name';
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}