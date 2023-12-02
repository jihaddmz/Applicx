import 'package:applicx/screens/screen_intro1.dart';
import 'package:applicx/screens/screen_intro2.dart';
import 'package:applicx/screens/screen_intro3.dart';
import 'package:applicx/screens/screen_intro4.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Visibility(
                visible: _showSlider,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50),
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
                  child: SvgPicture.asset(
                      "assets/svgs/vector_circleforward.svg",
                      semanticsLabel: 'Acme Logo'),
                ))
          ],
        ),
        body: Stack(
          children: [
            Visibility(
                visible: _currentPage == 0,
                child: FadeTransition(
                  opacity: _controllerFade,
                  child: ScreenIntro1(),
                )),
            Visibility(
                visible: _currentPage == 1,
                child: FadeTransition(
                  opacity: _controllerFade,
                  child: ScreenIntro2(onBackClick),
                )),
            Visibility(
                visible: _currentPage == 2,
                child: FadeTransition(
                  opacity: _controllerFade,
                  child: ScreenIntro3(onBackClick),
                )),
            Visibility(
                visible: _currentPage == 3,
                child: FadeTransition(
                  opacity: _controllerFade,
                  child: ScreenIntro4(context, onBackClick),
                )),
          ],
        ));
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
}
