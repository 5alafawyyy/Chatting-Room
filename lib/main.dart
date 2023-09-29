import 'package:flutter/material.dart';
import 'package:chattingroom/app/app.dart';
import 'package:chattingroom/firebase/sign_in_up.dart';
import 'package:chattingroom/firebase_options.dart';
import 'package:chattingroom/models/user_model.dart';
import 'package:chattingroom/pages/main/main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  if (user != null) {
    FirebaseMethods.user = user;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.phoneNumber)
        .get();

    Map<String, dynamic> mp = snapshot.data() as Map<String, dynamic>;
    userModel = UserModel.fromMap(mp);
  }

  runApp(
    user == null ? MyApp() : MainPage(userModel: userModel),
  );
}
