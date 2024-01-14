import 'package:applicx/firebase_options.dart';
import 'package:applicx/helpers/helper_firebasefirestore.dart';
import 'package:applicx/helpers/helper_sharedpreferences.dart';
import 'package:applicx/screens/screen_intros.dart';
import 'package:applicx/screens/screen_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late String username;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HelperSharedPreferences.instance = await SharedPreferences.getInstance();
  username = await HelperSharedPreferences.getUsername();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  HelperFirebaseFirestore.firebaseFirestore = FirebaseFirestore.instance;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Applicx',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: "Montserrat"),
      home: username == "" ? ScreenIntros() : ScreenMain(),
    );
  }
}
