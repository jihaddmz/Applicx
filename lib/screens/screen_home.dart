import 'package:applicx/components/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScreenHome extends StatefulWidget {
  @override
  _ScreenHome createState() => _ScreenHome();
}

class _ScreenHome extends State<ScreenHome> {
  int _selectedIndex = 0;
  String _iconHome = "assets/svgs/vector_home_black.svg";
  String _iconReports = "assets/svgs/vector_reports.svg";
  String _iconSettings = "assets/svgs/vector_settings.svg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 15,
        unselectedFontSize: 10,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _iconHome,
              semanticsLabel: "Home",
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _iconReports,
              semanticsLabel: "Reports",
            ),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _iconSettings,
              semanticsLabel: "Settings",
            ),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff243141),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            _iconHome = "assets/svgs/vector_home_black.svg";
            _iconReports = "assets/svgs/vector_reports.svg";
            _iconSettings = "assets/svgs/vector_settings.svg";
          } else if (index == 1) {
            _iconHome = "assets/svgs/vector_home.svg";
            _iconReports = "assets/svgs/vector_reports_black.svg";
            _iconSettings = "assets/svgs/vector_settings.svg";
          } else {
            _iconHome = "assets/svgs/vector_home.svg";
            _iconReports = "assets/svgs/vector_reports.svg";
            _iconSettings = "assets/svgs/vector_settings_black.svg";
          }
        },
      ),
      body: Center(
        child: TextBoldBlack("Introducing APPLICX"),
      ),
    );
  }
}
