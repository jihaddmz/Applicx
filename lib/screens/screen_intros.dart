import 'package:applicx/components/card_text_next.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/screens/screen_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/*
  This class represents the intro screens
*/

class ScreenIntros extends StatefulWidget {
  @override
  _ScreenIntros createState() => _ScreenIntros();
}

class _ScreenIntros extends State<ScreenIntros> {
  final PageController pageController = PageController();
  String _imageIntroSlider = "assets/images/image_intro1_slider.png";
  bool _showSlider = true;

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
                    pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.linear);
                    if (pageController.page == 0) {
                      setState(() {
                        _imageIntroSlider =
                            "assets/images/image_intro2_slider.png";
                      });
                    } else if (pageController.page == 1) {
                      setState(() {
                        _imageIntroSlider =
                            "assets/images/image_intro3_slider.png";
                      });
                    } else if (pageController.page == 2) {
                      setState(() {
                        _showSlider = false;
                      });
                    }
                  },
                  child: SvgPicture.asset(
                      "assets/svgs/vector_circleforward.svg",
                      semanticsLabel: 'Acme Logo'),
                ))
          ],
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            Container(
              color: const Color(0xffF9CDCC),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 100, 0, 0),
                        child: Image.asset("assets/images/image_intro1.png"),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: SizedBox(
                            width: 335,
                            child: TextBoldBlack(
                                "Eliminate the time wasted on credit transfer.")),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: SizedBox(
                            width: 335,
                            child: TextGrey(
                                "Recharge the desired amount of credits with just one click.")),
                      )
                    ],
                  )
                ],
              ),
            ), // end of first screen
            Container(
              color: const Color(0xffAAD59E),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 200, 0, 0),
                        child: Image.asset("assets/images/image_intro2.png"),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                        child: SizedBox(
                            width: 335,
                            child: TextBoldBlack(
                                "Send alfa and touch gifts immediatly")),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                        child: SizedBox(
                            width: 335,
                            child: TextGrey(
                                "Send the gift to the person without sending any SMS")),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 100, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        onBackClick();
                      },
                      child: Image.asset("assets/images/image_back.png"),
                    ),
                  ),
                ],
              ),
            ), // end of second screen
            Container(
              color: const Color(0xffFDD848),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(90, 100, 0, 0),
                        child: Image.asset("assets/images/image_intro3.png"),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                        child: SizedBox(
                            width: 335,
                            child: TextBoldBlack(
                                "No need to remember the user payment status")),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                        child: SizedBox(
                            width: 335,
                            child: TextGrey(
                                "Check if the user has paid the required amount")),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 100, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        onBackClick();
                      },
                      child: Image.asset("assets/images/image_back.png"),
                    ),
                  ),
                ],
              ),
            ), // end of third screen
            Container(
              color: const Color(0xff9ECCFA),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(90, 100, 0, 0),
                        child: Image.asset("assets/images/image_intro4.png"),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: SizedBox(
                            width: 335, child: TextBoldBlack("Sign In")),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                        child: SizedBox(
                            width: 335,
                            child: TextNormalBlack(
                                "Login using your unique username")),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                        child: SizedBox(
                            width: 335,
                            child: TextGrey(
                                "We will share with you the specific username for your store")),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: CardTextNext("Enter your username", () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ScreenHome();
                          }));
                        }),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 100, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        onBackClick();
                      },
                      child: Image.asset("assets/images/image_back.png"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  void onBackClick() {
    if (pageController.page == 2) {
      setState(() {
        _imageIntroSlider = "assets/images/image_intro2_slider.png";
      });
      pageController.previousPage(
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
    } else if (pageController.page == 1) {
      setState(() {
        _imageIntroSlider = "assets/images/image_intro1_slider.png";
      });
      pageController.previousPage(
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
    } else if (pageController.page == 3) {
      pageController.previousPage(
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
      setState(() {
        _showSlider = true;
      });
    }
  }
}
