// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:giay/model/model.dart';
import 'package:giay/page/main_screen.dart';
import 'package:giay/widget/button/button.dart';
import 'package:giay/widget/firebase/firebase_shoe.dart';
import 'package:intl/intl.dart'; 

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key, 
    required this.shoeCartModel,
    this.isCart=false,
  });

  final List<ShoeCartModel> shoeCartModel;
  final bool isCart;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  List<ShoeCartModel> listShoe=[];
  int totalMoney=0;
  bool isShowListShoe=true;

  @override
  void initState() {
    listShoe=widget.shoeCartModel;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Thanh toán',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black
            )
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              buildOrderShoe(),
              buildDivider(),
              buildListOrderShoe(),
              buildDivider(),
              buildFormOfPayments(),
              buildTotalMoneyAllShoe(),
              buildButtonPayment(),
            ],
          ),
        ),
      )
    );
  }

  Widget buildButtonPayment(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: AppButton(
        color: Colors.orangeAccent,
        enableButton: true,
        content: 'Hoàn tất đặt hàng',
        onTap: ()=> onPayment(),
      ),
    );
  }

  Widget buildNameShoe(int index){
    final nameShoe= listShoe[index].name;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tên Giày: ',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500
          ),
        ),
        Text(
          nameShoe,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600
          ),
        ),
      ],
    );
  }

  Widget buildSizeShoe(int index){
    final sizeShoe= listShoe[index].size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Size giày: ',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500
          ),
        ),
        Text(
          sizeShoe.toString(),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600
          ),
        ),
      ],
    );
  }

  Widget buildQuantityShoe(int index){
    final quantityShoe= listShoe[index].quantity;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Số lượng: ',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500
          ),
        ),
        Text(
          quantityShoe.toString(),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600
          ),
        ),
      ],
    );
  }

  Widget buildPriceShoe(int index){
    final priceShoe= listShoe[index].price;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Giá: ',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500
          ),
        ),
        Text(
          priceShoe,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.red
          ),
        ),
      ],
    );
  }

  Widget buildTotalMoneyShoe(int index){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tổng tiền: ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500
            ),
          ),
          Text(
            setTotalMoneyOrder(index),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.red
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTotalMoneyAllShoe(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tạm tính: ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500
            ),
          ),
          Text(
            setTotalMoneyAll(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.red
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFormOfPayments(){
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Hình thưc: ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500
            ),
          ),
          Text(
            'Thanh toán sau khi nhận hàng',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListOrderShoe(){
    return Visibility(
      visible: isShowListShoe,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: listShoe.length,
        itemBuilder: (context, index) => Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                buildNameShoe(index),
                buildPriceShoe(index),
                buildSizeShoe(index),
                buildQuantityShoe(index),
                buildTotalMoneyShoe(index),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDivider(){
    return Divider(
      color: Colors.grey.withOpacity(0.2),
      thickness: 2,
    );
  }

  Widget buildOrderShoe(){
    return InkWell(
      onTap: () => setShowListShoe(),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Đơn hàng',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600
              ),
            ),
            Icon(Icons.arrow_drop_down,)
          ],
        ),
      ),
    );
  }

  Future<void> onPayment()async{
    if(widget.isCart){
      for (var element in listShoe) {
        FireStoreShoe.deleteShoeCart(element);
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đặt hàng thành công'),)
    ); 
    await Navigator.pushReplacement(context, MaterialPageRoute(builder: 
      (context) => const MainScreen(),));
  }

  void setShowListShoe(){
    isShowListShoe=!isShowListShoe;
    setState(() {});
  }

  String setTotalMoneyAll(){
    totalMoney=0;
    for (var element in listShoe) {
      final price= element.price.split(' ')[0];
      final priceShoe= int.parse(price.replaceAll('.', ''))*element.quantity;
      totalMoney+=priceShoe;
    }
    return '${NumberFormat('###,###,###.##', 'en_us')
          .format(totalMoney)
          .replaceAll(RegExp('[,]'), '.')} VND';
  }

  String setTotalMoneyOrder(int index){
    final price= listShoe[index].price.split(' ')[0];
    final priceShoe= int.parse(price.replaceAll('.', ''))*listShoe[index].quantity;
    return '${NumberFormat('###,###,###.##', 'en_us')
          .format(priceShoe)
          .replaceAll(RegExp('[,]'), '.')} VND';
  }
}