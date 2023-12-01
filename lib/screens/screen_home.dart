import 'package:applicx/components/text.dart';
import 'package:flutter/material.dart';

class ScreenHome extends StatefulWidget {
  @override
  _ScreenHome createState() => _ScreenHome();
}

class _ScreenHome extends State<ScreenHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextBoldBlack("Introducing APPLICX"),
      ),
    );
  }
}
