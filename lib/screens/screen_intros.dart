import 'package:applicx/components/card_text_next.dart';
import 'package:applicx/components/custom_route.dart';
import 'package:applicx/helpers/helper_sharedpreferences.dart';
import 'package:applicx/screens/screen_intro1.dart';
import 'package:applicx/screens/screen_intro2.dart';
import 'package:applicx/screens/screen_intro3.dart';
import 'package:applicx/screens/screen_intro4.dart';
import 'package:applicx/screens/screen_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

/*
  This class represents the intro screens
*/

class ScreenIntros extends StatefulWidget {
  @override
  _ScreenIntros createState() => _ScreenIntros();
}

class _ScreenIntros extends State<ScreenIntros>
    with SingleTickerProviderStateMixin {
  String _imageIntroSlider = "assets/images/image_intro1_slider.png";
  bool _showSlider = true;
  int _currentPage = 0;
  late final _controllerFade = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1.0,
      value: 1.0,
      duration: const Duration(milliseconds: 500));
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                  visible: _showSlider,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20 + 10),
                    child: Image.asset(_imageIntroSlider),
                  )),
              Visibility(
                  visible: _showSlider,
                  child: GestureDetector(
                    onTap: () {
                      if (_currentPage == 0) {
                        setState(() {
                          _imageIntroSlider =
                              "assets/images/image_intro2_slider.png";
                        });
                      } else if (_currentPage == 1) {
                        setState(() {
                          _imageIntroSlider =
                              "assets/images/image_intro3_slider.png";
                        });
                      } else if (_currentPage == 2) {
                        setState(() {
                          _showSlider = false;
                        });
                      }
                      setState(() {
                        _currentPage++;
                      });
                      _controllerFade.reset();
                      _controllerFade.forward();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: SvgPicture.asset(
                          "assets/svgs/vector_circleforward.svg",
                          semanticsLabel: 'Acme Logo'),
                    ),
                  )),
            ],
          ),
          Visibility(
              visible: !_showSlider,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child:
                    CardTextNext("Enter your username", controller, () async {
                  if (controller.text.isNotEmpty) {
                    // if user has entered a username
                    await HelperSharedPreferences.setUsername(controller.text);
                    Navigator.of(context)
                        .push(MyCustomRoute((BuildContext context) {
                      return ScreenMain();
                    }, RouteSettings(), ScreenMain()));
                  } else {}
                }, context),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Visibility(
                visible: _currentPage == 0,
                child: FadeTransition(
                  opacity: _controllerFade,
                  child: ScreenIntro1(context),
                )),
            Visibility(
                visible: _currentPage == 1,
                child: FadeTransition(
                  opacity: _controllerFade,
                  child: ScreenIntro2(onBackClick, context),
                )),
            Visibility(
                visible: _currentPage == 2,
                child: FadeTransition(
                  opacity: _controllerFade,
                  child: ScreenIntro3(onBackClick, context),
                )),
            Visibility(
                visible: _currentPage == 3,
                child: FadeTransition(
                  opacity: _controllerFade,
                  child: ScreenIntro4(context, onBackClick),
                )),
          ],
        ),
      ),
    );
  }

  void onBackClick() {
    if (_currentPage == 2) {
      setState(() {
        _imageIntroSlider = "assets/images/image_intro2_slider.png";
      });
    } else if (_currentPage == 1) {
      setState(() {
        _imageIntroSlider = "assets/images/image_intro1_slider.png";
      });
    } else if (_currentPage == 3) {
      setState(() {
        _showSlider = true;
      });
    }
    setState(() {
      _currentPage--;
    });
    _controllerFade.reset();
    _controllerFade.forward();
  }

  Color getColorByPageIndex() {
    return _currentPage == 0
        ? const Color(0xffF9CDCC)
        : _currentPage == 1
            ? const Color(0xffAAD59E)
            : _currentPage == 2
                ? const Color(0xffFDD848)
                : const Color(0xff9ECCFA);
  }
}
