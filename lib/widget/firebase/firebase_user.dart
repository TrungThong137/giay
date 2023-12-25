import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/model.dart';

class FireStoreUser {
  static Future<void> createUser(Users user) async {
    final doc = FirebaseFirestore.instance.collection('user').doc(user.idUser);
    await doc.set({
      'id': user.idUser,
      'name': user.fullName,
      'email': user.emailAddress,
      'password': user.pass
    });
  }

  static Future<void> removeUser(String id) async{
    final user= FirebaseFirestore.instance.collection('user');
    await user.doc(id).delete();
  }

  static Future<void> updateUser(Users user)async{
     await FirebaseFirestore.instance.collection('user')
        .doc(user.idUser)
        .update(
          user.toJson()
        );
  }
}