import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/model.dart';

class FireStoreShoe {
  static Future<void> createShoeInformationInCart(ShoeCartModel shoe) async {
    final doc = FirebaseFirestore.instance.collection('Gio');
    final newData= await doc.add({
      "shoeCode": shoe.shoeCode,
      "name": shoe.name,
      "image": shoe.image,
      "price": shoe.price,
      "size": shoe.size,
      "quantity": shoe.quantity,
      "idUser": shoe.idUser,
    });
    shoe.id= newData.id;
    await updateShoeCart(shoe);
  }

  static Future<void> updateShoeCart(ShoeCartModel shoe)async{
     await FirebaseFirestore.instance.collection('Gio')
        .doc(shoe.id)
        .update(
          shoe.toJson()
        );
  }

  static Future<void> deleteShoeCart(ShoeCartModel shoe)async{
     await FirebaseFirestore.instance.collection('Gio')
        .doc(shoe.id)
        .delete();
  }
  
}