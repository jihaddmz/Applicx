import 'package:applicx/components/text.dart';
import 'package:applicx/helpers/helper_logging.dart';
import 'package:applicx/screens/screen_home.dart';
import 'package:applicx/screens/screen_reports.dart';
import 'package:applicx/screens/screen_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScreenMain extends StatefulWidget {
  @override
  _ScreenMain createState() => _ScreenMain();
}

class _ScreenMain extends State<ScreenMain> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  String _iconHome = "assets/svgs/vector_home_black.svg";
  String _iconReports = "assets/svgs/vector_reports.svg";
  String _iconSettings = "assets/svgs/vector_settings.svg";
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();
  late Animation<Offset> _offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 0), end: Offset.zero)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate));
  late final _controllerFade = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1.0,
      value: 1.0,
      duration: const Duration(milliseconds: 500));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Divider(
              color: Colors.black,
              thickness: 3,
              indent: 70,
              endIndent: 70,
            ),

            /**                                 Wallet Amount          */

            Visibility(
                visible: _selectedIndex == 0,
                child: SizedBox(
                  width: 150,
                  height: 50,
                  child: TextField(
                    controller: TextEditingController(text: "100.00 \$"),
                    enabled: false,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: Color(0xffF2F2F2), width: 5)),
                        labelText: "Wallet",
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: Colors.black)),
                  ),
                )),
            Visibility(
                visible: _selectedIndex == 1,
                child: SizedBox(
                  width: 150,
                  height: 50,
                  child: TextField(
                    controller: TextEditingController(text: "10 Reports"),
                    enabled: false,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      fillColor: Colors.white,
                      filled: true,
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 5)),
                    ),
                  ),
                )),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 15,
        unselectedFontSize: 10,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Column(
              children: [
                SvgPicture.asset(
                  _iconHome,
                  semanticsLabel: "Home",
                ),
                SlideTransition(
                  position: _offsetAnimation,
                  child: Visibility(
                      visible: _selectedIndex == 0,
                      child: SvgPicture.asset(
                        "assets/svgs/vector_circle_black.svg",
                        semanticsLabel: "Home",
                      )),
                )
              ],
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                SvgPicture.asset(
                  _iconReports,
                  semanticsLabel: "Reports",
                ),
                Visibility(
                    visible: _selectedIndex == 1,
                    child: SlideTransition(
                        key: UniqueKey(),
                        position: _offsetAnimation,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: SvgPicture.asset(
                            "assets/svgs/vector_circle_black.svg",
                            semanticsLabel: "Reports",
                          ),
                        )))
              ],
            ),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                SvgPicture.asset(
                  _iconSettings,
                  semanticsLabel: "Settings",
                ),
                Visibility(
                    visible: _selectedIndex == 2,
                    child: SlideTransition(
                      key: UniqueKey(),
                      position: _offsetAnimation,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: SvgPicture.asset(
                          "assets/svgs/vector_circle_black.svg",
                          semanticsLabel: "Settings",
                        ),
                      ),
                    ))
              ],
            ),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff243141),
        onTap: (index) {
          if (index == 0) {
            if (_selectedIndex == 1) {
              _offsetAnimation =
                  Tween<Offset>(begin: const Offset(7, 0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: _controller, curve: Curves.decelerate));
            } else if (_selectedIndex == 2) {
              _offsetAnimation =
                  Tween<Offset>(begin: const Offset(15, 0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: _controller, curve: Curves.decelerate));
            }
            _iconHome = "assets/svgs/vector_home_black.svg";
            _iconReports = "assets/svgs/vector_reports.svg";
            _iconSettings = "assets/svgs/vector_settings.svg";
          } else if (index == 1) {
            if (_selectedIndex == 0) {
              _offsetAnimation =
                  Tween<Offset>(begin: const Offset(-7, 0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: _controller, curve: Curves.decelerate));
            } else if (_selectedIndex == 2) {
              _offsetAnimation =
                  Tween<Offset>(begin: const Offset(7, 0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: _controller, curve: Curves.decelerate));
            }
            _iconHome = "assets/svgs/vector_home.svg";
            _iconReports = "assets/svgs/vector_reports_black.svg";
            _iconSettings = "assets/svgs/vector_settings.svg";
          } else {
            if (_selectedIndex == 0) {
              _offsetAnimation =
                  Tween<Offset>(begin: const Offset(-15, 0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: _controller, curve: Curves.decelerate));
            } else if (_selectedIndex == 1) {
              _offsetAnimation =
                  Tween<Offset>(begin: const Offset(-7, 0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: _controller, curve: Curves.decelerate));
            }
            _iconHome = "assets/svgs/vector_home.svg";
            _iconReports = "assets/svgs/vector_reports.svg";
            _iconSettings = "assets/svgs/vector_settings_black.svg";
          }

          if (_selectedIndex != index) {
            // rerunning the animations of the bottom nav bar circle and pages fade
            _controller.reset();
            _controller.forward();
            _controllerFade.reset();
            _controllerFade.forward();
          }
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: SafeArea(
          child: Stack(
        children: [
          Visibility(
              visible: _selectedIndex == 0,
              child: FadeTransition(
                  opacity: _controllerFade, child: ScreenHome())),
          Visibility(
              visible: _selectedIndex == 1,
              child: FadeTransition(
                  opacity: _controllerFade, child: ScreenReports())),
          Visibility(
              visible: _selectedIndex == 2,
              child: FadeTransition(
                  opacity: _controllerFade, child: ScreenSettings())),
        ],
      )),
    );
  }
}
