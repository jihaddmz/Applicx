import 'package:applicx/helpers/helper_sharedpreferences.dart';
import 'package:applicx/screens/screen_intros.dart';
import 'package:applicx/screens/screen_main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late String username;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HelperSharedPreferences.instance = await SharedPreferences.getInstance();
  username = await HelperSharedPreferences.getUsername();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: username == "" ? ScreenIntros() : ScreenMain(),
    );
  }
}
