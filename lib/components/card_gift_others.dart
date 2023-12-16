import 'package:applicx/components/drop_down.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/models/model_gift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardGiftOthers extends StatefulWidget {
  CardGiftOthers(
      {required this.modelGift,
      required this.color,
      this.list,
      required this.onConfirmClick});

  final ModelGift modelGift;
  final List<String>? list;
  final Color color;
  final Function(ModelGift) onConfirmClick;

  @override
  _CardGiftOthers createState() => _CardGiftOthers();
}

class _CardGiftOthers extends State<CardGiftOthers> {
  bool showDropDown = true;

  @override
  void initState() {
    super.initState();

    showDropDown = widget.modelGift.msg.contains("Specify");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              widget.onConfirmClick(widget.modelGift);
            },
            child: Visibility(
                visible: widget.modelGift.chosen != null,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Positioned(
                      bottom: 20,
                      child: Card(
                        color: const Color(0xff243141),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(30, 30, 30, 2),
                          child: Text(
                            "Confirm",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                )),
          ),
          SizedBox(
            height: 150,
            child: Card(
              color: widget.color,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 150,
                    width: 20,
                    child: Card(
                      color: Color(0xff243141),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Stack(
                      children: [
                        Positioned(
                          right: 0,
                          bottom: 20,
                          child: showDropDown
                              ? MyDropDown(
                                  list: widget.list!,
                                  label: widget.modelGift.msg.contains("GB")
                                      ? "GB"
                                      : "Service",
                                  onSelect: (item) => {
                                        setState(() {
                                          widget.modelGift.chosen = item;
                                          widget.modelGift.cost =
                                              double.parse(item!);
                                        })
                                      })
                              : GestureDetector(
                                  onTap: () {
                                    widget.onConfirmClick(widget.modelGift);
                                  },
                                  child: SvgPicture.asset(
                                    "assets/svgs/vector_circleforward.svg",
                                    semanticsLabel: 'Next',
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextNormalBlack(widget.modelGift.title),
                            TextGrey(widget.modelGift.msg),
                            Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: TextGrey(
                                    "Availability: ${widget.modelGift.availability}")),
                            TextGrey("Cost: ${widget.modelGift.cost}\$"),
                          ],
                        )
                      ],
                    ),
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
