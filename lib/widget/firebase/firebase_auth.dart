
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/model.dart';
import '../widget.dart';


class FireAuth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void signUp(String email, String password, String name, 
  Function onSuccess, Function(String) onError) async{
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password
      ).then((user){
        _createUser(user.user!.uid, name, email, password, onSuccess, onError);
      });
    }on FirebaseAuthException catch (e) {
      onError('SignIn fail, please try again');
      if(e.code=='weak-password'){
          onError('The password provided is too weak');
      }else if(e.code=='email-already-in-use'){
        onError('The account already exists for that email.');
      }
    }catch(e){
      onError(e.toString());
    }
  }

  _createUser(String userId, String name,String email,String password, Function onSuccess,
    Function(String) onError){
      FireStoreUser.createUser(Users(
        idUser: userId,
        emailAddress: email,
        fullName: name,
        pass: password,
      )).then((value) => onSuccess()).catchError((err)=> onError(err.toString()));
  }

  void signIn(String email, String password, Function onSuccess, Function(String) onError)async{
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password
      ).then((user)async{
        user.user?.getIdToken().then((idToken) async {
          final pref= await SharedPreferences.getInstance();
          pref.setString('accessToken',idToken!);
        });
        onSuccess();
      });
    } on FirebaseAuthException catch (e) {
      onError('SignIn fail, please try again');
      if (e.code == 'user-not-found') {
        onError('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        onError('Wrong password provided for that user.');
      }
    }catch(e){
      onError(e.toString());
    }
  }

  void signOut()async{
    return await _firebaseAuth.signOut();
  }
}