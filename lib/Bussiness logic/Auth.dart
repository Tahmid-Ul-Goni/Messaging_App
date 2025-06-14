import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled12/Home.dart';
import 'package:untitled12/Route.dart';

class Auth {
  final box = GetStorage();
}

Future registration(
  String name,
  String emailAddress,
  String password,
  context,
) async {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: emailAddress,
          password: password,
        );
    var authCredential = userCredential.user;
    if (authCredential!.uid.isNotEmpty) {
      Fluttertoast.showToast(msg: "Registration Successful");
      userCredential.user!.updateDisplayName(name);

      await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({"name": name, "email": emailAddress});
      Get.toNamed(home);
    } else {
      print("sing up failed");
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == "weak-password") {
      Fluttertoast.showToast(msg: "THe password provided is too weak");
    } else if (e.code == " email-already-in-used") {
      Fluttertoast.showToast(msg: "The account already exists for that email.");
    }
  } catch (e) {
    Fluttertoast.showToast(msg: 'Error is:$e');
  }
}

Future login(String emailAddress, String password, context) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password);
    var authCredential = userCredential.user;
    print(authCredential);
    if (authCredential!.uid.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Login Successful');
      Get.toNamed(home);
    } else {
     Fluttertoast.showToast(msg: 'SingIn Failed');
     Get.toNamed(home);
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == "weak-password") {
      Fluttertoast.showToast(msg: 'The password provided weak.');
    }
    else if (e.code == "email-already-in-use") {
      Fluttertoast.showToast(msg: 'The account already exists for this email');
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Error is:$e");
  }
}

Future singOut() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signOut() async {
  await _auth.signOut();
  }
  }

