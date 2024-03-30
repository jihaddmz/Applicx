import 'package:applicx/colors.dart';
import 'package:applicx/components/card_paid_status.dart';
import 'package:applicx/components/card_toggler.dart';
import 'package:applicx/components/card_unpaid_status.dart';
import 'package:applicx/components/fab_scrolltotop.dart';
import 'package:applicx/components/item_history_report.dart';
import 'package:applicx/components/item_history_report_cardvoucher.dart';
import 'package:applicx/components/text.dart';
import 'package:applicx/components/my_textfield.dart';
import 'package:applicx/helpers/helper_dialog.dart';
import 'package:applicx/helpers/helper_firebasefirestore.dart';
import 'package:applicx/helpers/helper_logging.dart';
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
  List<ModelHistoryReportGift> initialHistoryGiftReportList = [];
  List<ModelHistoryReportCardVoucher> initialHistoryCardVoucherReportList = [];
  List<dynamic> _list = [];
  bool _showFilter = false;
  String _filterPath = "assets/svgs/vector_filter.svg";
  bool _isFilterStatusPaid = true;
  bool _isFilterCarrierAlfa = true;
  String _currentPhoneNumber = "";
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    fetchUserName();

    Future.delayed(const Duration(milliseconds: 200), () {
      fetchGiftsHistory();
    });
  }

  Future<void> fetchGiftsHistory({Function()? onFinishFetching}) async {
    HelperDialog.showLoadingDialog(context, "Fetching Gifts");

    initialHistoryGiftReportList.clear();

    await HelperFirebaseFirestore.fetchHistory(true).then((coll) {
      if (coll != null) {
        for (var doc in coll.docs) {
          initialHistoryGiftReportList.add(ModelHistoryReportGift(
              id: doc.id,
              name: doc.get("username"),
              phoneNumber: doc.get("phoneNumber"),
              service: doc.get("service"),
              date: doc.get("date").toString().split(".")[0],
              isTouch: doc.get("alfa") ? 0 : 1,
              isPaid: doc.get("paid") ? 1 : 0));
        }
      }
    });

    initialHistoryGiftReportList.sort(
      (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)),
    );

    setState(() {
      _list = initialHistoryGiftReportList;
    });

    widget.changeNumberOfReports(_list.length);

    Navigator.pop(context);

    if (onFinishFetching != null) {
      onFinishFetching();
    }
  }

  Future<void> fetchCardsVoucherHistory({Function()? onFinishFetching}) async {
    HelperDialog.showLoadingDialog(context, "Fetching Cards Voucher");

    initialHistoryCardVoucherReportList.clear();

    await HelperFirebaseFirestore.fetchHistory(false).then((coll) {
      if (coll != null) {
        for (var doc in coll.docs) {
          initialHistoryCardVoucherReportList.add(ModelHistoryReportCardVoucher(
              id: doc.id,
              name: doc.get("username"),
              phoneNumber: doc.get("phoneNumber"),
              activationCode: doc.get("actCode"),
              expDate: doc.get("expDate"),
              info: doc.get("cartInfo"),
              date: doc.get("date").toString().split(".")[0],
              isPaid: doc.get("paid") ? 1 : 0,
              isTouch: doc.get("alfa") ? 0 : 1));
        }
      }
    });

    initialHistoryCardVoucherReportList.sort(
      (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)),
    );

    setState(() {
      _list = initialHistoryCardVoucherReportList;
    });

    widget.changeNumberOfReports(_list.length);

    Navigator.pop(context);

    if (onFinishFetching != null) {
      onFinishFetching();
    }
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
    return Scaffold(
      floatingActionButton: FABScrollTopTop(scrollController: scrollController),
      body: SingleChildScrollView(
        controller: scrollController,
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
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
                              onToggle: (index) async {
                                _controllerSearch.clear();
                                if (index == 0) {
                                  await fetchGiftsHistory();
                                } else {
                                  await fetchCardsVoucherHistory();
                                }
                                setState(() {
                                  _tabIndex = index;
                                });
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextLessBoldBlack("Name/Number"),
                            TextLessBoldBlack(
                                _tabIndex == 0 ? "Service" : "Card")
                          ],
                        ),
                      ),
                      const Divider(
                        color: colorDarkBlue,
                        thickness: 3,
                        indent: 20,
                        endIndent: 20,
                      )
                    ],
                  )),
              Visibility(
                  visible: _list.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
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
                          TextNormalBlack("No Results Found"),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
                            child: Image.asset(
                              "assets/images/image_chatbot_noresults.png",
                              width: 150,
                              height: 200,
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> addReportWidgets() {
    List<Widget> result = [];
    for (int i = 0; i < _list.length; i++) {
      result.add(Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ItemHistoryReportGift(
            modelReport: _list[i] as ModelHistoryReportGift,
            context: context,
            currentPhoneNumber: _currentPhoneNumber,
            onYesChangeStatusClick: (modelHistoryReportGift, newStatus) async {
              double position = scrollController.offset;
              await HelperFirebaseFirestore.updateHistoryItemStatus(
                  _list[i].isPaid == 0 ? 1 : 0, _list[i].id, true);
              fetchGiftsHistory(
                onFinishFetching: () {
                  scrollController.animateTo(position,
                      duration: const Duration(milliseconds: 5),
                      curve: Curves.linear);
                  if (_controllerSearch.text.isNotEmpty) {
                    searchReports(_controllerSearch.text);
                  }
                },
              );
            }),
      ));
    }

    return result;
  }

  List<Widget> addCardVoucherReportWidgets() {
    List<Widget> result = [];
    for (int i = 0; i < _list.length; i++) {
      result.add(Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ItemHistoryReportCardVoucher(
            _list[i] as ModelHistoryReportCardVoucher,
            context,
            _currentPhoneNumber,
            (modelHistoryReportCardVoucher, newStatus) async {
          double position = scrollController.offset;
          await HelperFirebaseFirestore.updateHistoryItemStatus(
              _list[i].isPaid == 0 ? 1 : 0, _list[i].id, false);
          fetchCardsVoucherHistory(
            onFinishFetching: () {
              scrollController.animateTo(position,
                  duration: const Duration(milliseconds: 5),
                  curve: Curves.linear);
              if (_controllerSearch.text.isNotEmpty) {
                searchReports(_controllerSearch.text);
              }
            },
          );
        }),
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

        if (double.tryParse(text) == null) {
          // entered text to search
          HelperLogging.logD("Entered is 1");
          if (element.name != null) {
            if (element.name!.toLowerCase().contains(text.toLowerCase())) {
              setState(() {
                _list.add(element);
              });
            }
          }
        } else {
          // entered phone number to search
          HelperLogging.logD("Entered is 2");
          if (!_list.contains(element)) {
            if (element.phoneNumber
                .toLowerCase()
                .contains(text.toLowerCase())) {
              setState(() {
                _list.add(element);
              });
            }
          }
        }
      }
    }
    HelperLogging.logD("size of list is ${_list.length}");
    widget.changeNumberOfReports(_list.length);
  }
}
