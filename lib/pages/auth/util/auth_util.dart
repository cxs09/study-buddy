import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<UserCredential?> signIn(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    );
    return credential;
  } on FirebaseAuthException catch (e) {
    print(e);
    return null;
  }
}

Future<Map<String, dynamic>?> _loadUser(String id) async {
  final db = FirebaseFirestore.instance;
  return (await db.collection("users").doc(id).get()).data();
}