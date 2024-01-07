import 'package:applicx/components/button.dart';
import 'package:applicx/components/card_paid_status.dart';
import 'package:applicx/components/card_toggler.dart';
import 'package:applicx/components/card_unpaid_status.dart';
import 'package:applicx/components/item_history_report.dart';
import 'package:applicx/components/item_history_report_cardvoucher.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/components/my_textfield.dart';
import 'package:applicx/helpers/helper_sharedpreferences.dart';
import 'package:applicx/models/model_history_report_vouchercard.dart';
import 'package:applicx/models/model_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScreenReports extends StatefulWidget {
  ScreenReports({required this.changeNumberOfReports});

  @override
  _ScreenReports createState() => _ScreenReports();

  final Function(int) changeNumberOfReports;
}

class _ScreenReports extends State<ScreenReports> {
  int _tabIndex = 0;
  final TextEditingController _controllerSearch = TextEditingController();
  late List<ModelHistoryReportGift> initialHistoryGiftReportList;
  late List<ModelHistoryReportCardVoucher> initialHistoryCardVoucherReportList;
  late List<dynamic> _list;
  bool _showFilter = false;
  String _filterPath = "assets/svgs/vector_filter.svg";
  bool _isFilterStatusPaid = true;
  bool _isFilterCarrierAlfa = true;
  String _currentPhoneNumber = "";

  @override
  void initState() {
    super.initState();

    fetchUserName();

    initialHistoryGiftReportList = [
      ModelHistoryReportGift(
          name: "Jihad Mahfouz",
          phoneNumber: "81909560",
          service: "Credit Transfer",
          date: "12/05/2023 12:00:00",
          isTouch: 1,
          isPaid: 1),
      ModelHistoryReportGift(
          phoneNumber: "70909560",
          service: "1 month gift",
          date: "12/05/2023 12:00:00",
          isTouch: 0,
          isPaid: 0),
      ModelHistoryReportGift(
          name: "Nomair Raya",
          phoneNumber: "81909560",
          service: "Alfa Gift 5GB",
          date: "12/05/2023 12:00:00",
          isTouch: 0,
          isPaid: 1),
      ModelHistoryReportGift(
          name: "Nomair Raya",
          phoneNumber: "81909560",
          service: "Alfa Gift 5GB",
          date: "12/05/2023 12:00:00",
          isTouch: 0,
          isPaid: 1)
    ];
    initialHistoryCardVoucherReportList = [
      ModelHistoryReportCardVoucher(
          name: "Jihad Mahfouz",
          phoneNumber: "81909560",
          activationCode: "9458945095095009301904934",
          expDate: "12/12/2024 12:00:00",
          info: "Alfa 7.5\$ waffer",
          date: "12/12/2024 12:00:00",
          isPaid: 1,
          isTouch: 1),
      ModelHistoryReportCardVoucher(
          name: "Nomair Raya",
          phoneNumber: "70909560",
          activationCode: "9458945095095009301904934",
          expDate: "12/12/2024 12:00:00",
          info: "Alfa 7.5\$ waffer",
          date: "12/12/2024 12:00:00",
          isPaid: 0,
          isTouch: 0)
    ];
    setState(() {
      _list = initialHistoryGiftReportList;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      widget.changeNumberOfReports(_list.length);
    });
  }

  void fetchUserName() async {
    HelperSharedPreferences.getPhoneNumber().then((value) {
      setState(() {
        _currentPhoneNumber = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextBoldBlack("History"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                        visible: !_showFilter,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    elevation: 0,
                                    title: TextBoldBlack("Attention!",
                                        textAlign: TextAlign.center),
                                    content: TextGrey(
                                        "Are you sure you want to download new history?",
                                        textAlign: TextAlign.center),
                                    actionsAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    actions: [
                                      ButtonSmall("No", () {
                                        Navigator.pop(context);
                                      }, color: const Color(0xffFF6F77)),
                                      ButtonSmall("Yes", () {
                                        Navigator.pop(context);
                                      }, color: const Color(0xffAAD59E))
                                    ],
                                  );
                                });
                          },
                          child: SvgPicture.asset(
                            "assets/svgs/vector_fetch.svg",
                            semanticsLabel: "Filter",
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showFilter = !_showFilter;
                          });
                          if (_showFilter) {
                            setState(() {
                              _filterPath =
                                  "assets/svgs/vector_filter_close.svg";
                            });
                            filterReports();
                          } else {
                            setState(() {
                              _filterPath = "assets/svgs/vector_filter.svg";
                              _isFilterCarrierAlfa = true;
                              _isFilterStatusPaid = true;
                              _list = initialHistoryGiftReportList;
                            });
                            setState(() {
                              _list = _tabIndex == 0
                                  ? initialHistoryGiftReportList
                                  : initialHistoryCardVoucherReportList;
                            });
                            widget.changeNumberOfReports(_list.length);
                          }
                        },
                        child: SvgPicture.asset(
                          _filterPath,
                          semanticsLabel: "Filter",
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            TextNormalBlack("View your purchase history"),
            Visibility(
                visible: _showFilter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: double.infinity,
                      child: Filter(),
                    ),
                  ),
                )),
            Visibility(
                maintainState: true,
                visible: !_showFilter,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: CardToggler(
                            textLeft: "Gifts",
                            textRight: "Cards Voucher",
                            onToggle: (index) {
                              setState(() {
                                _tabIndex = index;
                              });
                              if (index == 0) {
                                setState(() {
                                  _list = initialHistoryGiftReportList;
                                });
                              } else {
                                setState(() {
                                  _list = initialHistoryCardVoucherReportList;
                                });
                              }
                              widget.changeNumberOfReports(_list.length);
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: MyTextField(
                          controller: _controllerSearch,
                          hintText: "Search by Name/Number",
                          onValueChanged: (value) {
                            searchReports(value);
                          }),
                    ),
                  ],
                )),
            Visibility(
                visible: _list.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: _tabIndex == 0
                        ? addReportWidgets()
                        : addCardVoucherReportWidgets(),
                  ),
                )),
            Visibility(
                visible: _list.isEmpty,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextGrey("No Results Found"),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Image.asset(
                              "assets/images/image_chatbot_noresults.png"),
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  List<Widget> addReportWidgets() {
    List<Widget> result = [];
    for (var element in _list) {
      result.add(Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ItemHistoryReportGift(element, context, _currentPhoneNumber),
      ));
    }

    return result;
  }

  List<Widget> addCardVoucherReportWidgets() {
    List<Widget> result = [];
    for (var element in _list) {
      result.add(Padding(
        padding: const EdgeInsets.only(top: 10),
        child:
            ItemHistoryReportCardVoucher(element, context, _currentPhoneNumber),
      ));
    }

    return result;
  }

  Widget Filter() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xffF2F2F2),
      child: Column(
        children: [
          CardToggler(
              textLeft: "Paid",
              textRight: "Unpaid",
              iconLeft: CardPaidStatus(),
              iconRight: CardUnPaidStatus(),
              onToggle: (index) {
                if (index == 0) {
                  _isFilterStatusPaid = true;
                } else {
                  _isFilterStatusPaid = false;
                }
                filterReports();
              }),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CardToggler(
                textLeft: "Alfa",
                textRight: "Touch",
                iconLeft: Image.asset(
                  "assets/images/logo_alfa.png",
                  width: 20,
                  height: 20,
                ),
                iconRight: Image.asset(
                  "assets/images/logo_touch.png",
                  width: 20,
                  height: 20,
                ),
                onToggle: (index) {
                  if (index == 0) {
                    _isFilterCarrierAlfa = true;
                  } else {
                    _isFilterCarrierAlfa = false;
                  }
                  filterReports();
                }),
          )
        ],
      ),
    );
  }

  //                          Functions

  void filterReports() {
    List<dynamic> listToFilterFrom = _tabIndex == 0
        ? initialHistoryGiftReportList
        : initialHistoryCardVoucherReportList;
    setState(() {
      _list = [];
    });

    for (var element in listToFilterFrom) {
      if (_isFilterCarrierAlfa && _isFilterStatusPaid) {
        if (element.isPaid == 1 && element.isTouch == 0) {
          setState(() {
            _list.add(element);
          });
        }
      } else if (_isFilterCarrierAlfa && !_isFilterStatusPaid) {
        if (element.isPaid == 0 && element.isTouch == 0) {
          setState(() {
            _list.add(element);
          });
        }
      } else if (!_isFilterCarrierAlfa && _isFilterStatusPaid) {
        if (element.isTouch == 1 && element.isPaid == 1) {
          setState(() {
            _list.add(element);
          });
        }
      } else if (!_isFilterCarrierAlfa && !_isFilterStatusPaid) {
        if (element.isTouch == 1 && element.isPaid == 0) {
          setState(() {
            _list.add(element);
          });
        }
      }
      widget.changeNumberOfReports(_list.length);
    }
  }

  void searchReports(String text) {
    List<dynamic> listToFilterFrom = _tabIndex == 0
        ? initialHistoryGiftReportList
        : initialHistoryCardVoucherReportList;
    if (text.isEmpty) {
      setState(() {
        _list = listToFilterFrom;
      });
    } else {
      setState(() {
        _list = [];
      });
      for (var element in listToFilterFrom) {
        if (_list.contains(element)) return;

        if (element.name != null) {
          if (element.name!.toLowerCase().contains(text.toLowerCase())) {
            setState(() {
              _list.add(element);
            });
          }
        }

        if (element.phoneNumber.toLowerCase().contains(text.toLowerCase())) {
          setState(() {
            _list.add(element);
          });
        }
      }
    }
    widget.changeNumberOfReports(_list.length);
  }
}
