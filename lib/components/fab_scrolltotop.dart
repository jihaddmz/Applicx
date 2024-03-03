import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FABScrollTopTop extends StatefulWidget {
  FABScrollTopTop({required this.scrollController});

  @override
  _FABScrollToTop createState() => _FABScrollToTop();

  final ScrollController scrollController;
}

class _FABScrollToTop extends State<FABScrollTopTop> {
  bool _showScrollBtn = false;

  @override
  void initState() {
    super.initState();

    double previousScrollOffset = 0;
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels > previousScrollOffset &&
          !_showScrollBtn) {
        previousScrollOffset = widget.scrollController.position.pixels;
        setState(() {
          _showScrollBtn = true;
        });
      } else if (widget.scrollController.position.pixels.toInt() == 0 &&
          _showScrollBtn) {
        previousScrollOffset = 0;

        setState(() {
          _showScrollBtn = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: _showScrollBtn,
        child: GestureDetector(
          onTap: () {
            widget.scrollController.animateTo(0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear);
          },
          child: SvgPicture.asset(
            "assets/svgs/vector_arrow_upward.svg",
            width: 70,
            height: 70,
          ),
        ));
  }
}
