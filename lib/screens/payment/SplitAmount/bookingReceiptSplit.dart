import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ticket_widget/ticket_widget.dart';

import '../../../../commonModule/AppColor.dart';
import '../../../../controller/commonController.dart';
import '../../../../main_page.dart';
import '../../../commonModule/Strings.dart';
import '../../../commonModule/utils.dart';
import '../../../commonModule/widget/common/mySeperator.dart';
import '../../../commonModule/widget/common/textInter.dart';
import '../../../commonModule/widget/common/textNunito.dart';
import '../../../commonModule/widget/common/textSentic.dart';

class SplitReceipt extends StatefulWidget {
  final String email;
  final String image;
  final String paymentLink;
  final String bookingId;
  final DateTime? bookingTime;
  final DateTime? currentTime;

  SplitReceipt({
    Key? key,
    required this.email,
    required this.image,
    required this.paymentLink,
    required this.bookingId,
    required this.bookingTime,
    required this.currentTime,
  }) : super(key: key);

  @override
  State<SplitReceipt> createState() => _SplitReceiptState();
}

class _SplitReceiptState extends State<SplitReceipt> {
  CommonController cx = Get.put(CommonController());
  bool isexpanded = false;
  TextEditingController controller = TextEditingController(text: "");
  String thisText = "";
  int pinLength = 4;
  bool hasError = false;
  bool isconfirm = false;
  bool isprocessing = false;
  bool isuccessful = false;
  bool isfailed = true;
  Timer? countdownTimer;
  Duration myDuration = Duration(hours: 1, minutes: 59, seconds: 60);

  DateTime todayTime = DateTime.now();

  DateTime currentTime = DateTime.now();
  DateTime bookingTime = DateTime.now();

  String timeRemaining = '';
  String startTime = '';
  Duration dur = Duration(days: 1);
  Duration calDuration = Duration(hours: 1, minutes: 59, seconds: 60);

  int remainingHours = 0;
  int remainingMinutes = 0;
  int remainingSeconds = 0;

  String hours = '';
  String minutes = '';
  String seconds = '';

  String hours1 = '';
  String minutes1 = '';
  String seconds1 = '';
  bool isCancelAvailable = true;
  bool isTimerAvailable = true;
  String paymentStatus = 'In Progress';
  bool isDefaultTime = true;
  List<int> errorDomeImage = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentTime = widget.currentTime ?? DateTime.now();
    todayTime = widget.currentTime ?? DateTime.now();
    print(currentTime);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print(cx.read(Keys.fullDate));
      print(cx.read(Keys.startTime).toString().substring(0, 2));
      startTime = cx.read(Keys.startTime).toString().substring(0, 2);
      print(cx.read(Keys.startTime).toString().substring(6, 8));

      if (cx.read(Keys.startTime).toString().substring(6, 8) == "PM") {
        print("startTime1");
        if(cx.read(Keys.startTime).toString().substring(0, 2) != "12") {
          startTime = (int.parse(startTime) + 12).toString();
        }
      } else {
        if (cx.read(Keys.startTime).toString().substring(0, 2) == "12") {
          startTime = "00";
        }
      }
      print("startTime2");
      print(startTime);

      timeRemaining = cx.read(Keys.fullDate) +
          ' ' +
          startTime +
          ":${cx.read(Keys.startTime).toString().substring(3, 5)}:00";

      print(timeRemaining);
      bookingTime = DateTime.parse(timeRemaining);
      // todayTime.add(Duration(days: 1));

      print(bookingTime);
      print(todayTime.add(Duration(hours: 2)));

      print("Default Time?");

      print(bookingTime.millisecondsSinceEpoch);
      print(todayTime.add(Duration(hours: 2)).millisecondsSinceEpoch);
      if (bookingTime.millisecondsSinceEpoch <=
          todayTime.add(Duration(hours: 2)).millisecondsSinceEpoch) {
        dur = bookingTime.difference(widget.currentTime ?? DateTime.now());
        print(dur);
        // dur = calDuration - dur;
        //
        // print(dur);
        print("Duration");

        print("Difference");
        print(dur.inHours);
        print(dur.inMinutes);
        print(dur.inSeconds);

        startTimer();
        isDefaultTime = false;
        isCancelAvailable = false;
        // isTimerAvailable=true;
      } else {
        print("Time is bigger");
        isDefaultTime = true;
        startTimer1();
        print(myDuration.inHours);
        print(myDuration.inMinutes);
        print(myDuration.inSeconds);
      }

      //--------24 hours default timer ,Otherwise remaining time---------//
      // print(bookingTime.millisecondsSinceEpoch);
      // print(todayTime.add(Duration(days: 1)).millisecondsSinceEpoch);
      // if (bookingTime.millisecondsSinceEpoch <=
      //     todayTime.add(Duration(days: 1)).millisecondsSinceEpoch) {
      //   dur = currentTime.difference(bookingTime);
      //   print(dur);
      //   dur = calDuration - dur;
      //
      //   print(dur);
      //   print("Duration");
      //
      //
      //   print("Difference");
      //   print(dur.inHours);
      //   print(dur.inMinutes);
      //   print(dur.inSeconds);
      //
      //   startTimer();
      //   isDefaultTime = false;
      // } else {
      //   print("Time is bigger");
      //   isDefaultTime = true;
      //
      //   startTimer1();
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');

    hours = strDigits(dur.inHours.remainder(24));
    minutes = strDigits(dur.inMinutes.remainder(60));
    seconds = strDigits(dur.inSeconds.remainder(60));

    hours1 = strDigits(myDuration.inHours.remainder(24));
    minutes1 = strDigits(myDuration.inMinutes.remainder(60));
    seconds1 = strDigits(myDuration.inSeconds.remainder(60));

    //---Testing----
    // dur=Duration(seconds:10);
    print(hours);
    print(minutes);
    print(seconds);
    print(hours1);
    print(minutes1);
    print(seconds1);

    //-----Booking Time Passed-----
    if (isDefaultTime) {
      if (int.parse(hours1) <= 0 &&
          int.parse(minutes1) <= 0 &&
          int.parse(seconds1) <= 0) {
        print("Timer Over");
        isTimerAvailable = false;
        isCancelAvailable = false;
        paymentStatus = "Cancelled";
      }
    } else {
      if (int.parse(hours) <= 0 &&
          int.parse(minutes) <= 0 &&
          int.parse(seconds) <= 0) {
        print("Timer Over");
        isTimerAvailable = false;
        isCancelAvailable = false;
        paymentStatus = "Cancelled";
      }
    }

    //-----Before 2 hours of Booking Time-----
    if ((widget.currentTime ?? DateTime.now()).millisecondsSinceEpoch >=
        bookingTime.subtract(Duration(hours: 2)).millisecondsSinceEpoch) {
      isCancelAvailable = false;
    }

    //-----Booking Time Passed-----
    if ((widget.currentTime ?? DateTime.now()).millisecondsSinceEpoch >=
        bookingTime.millisecondsSinceEpoch) {
      isTimerAvailable = false;
      isCancelAvailable = false;
      paymentStatus = "Cancelled";
    }

    return WillPopScope(
      onWillPop: () async {
        Get.offAll(MainPageScreen());
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColor.bg,
        body: Container(
          decoration: BoxDecoration(
            color: AppColor.bg,
          ),
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: isTimerAvailable
                              ? cx.height * 0.485
                              : cx.height * 1.05,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                decoration: errorDomeImage
                                        .contains(cx.read(Keys.domeId))
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: backShadowContainer(),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            Image1.domesAround,
                                          ),
                                          fit: BoxFit.cover,
                                        ))
                                    : BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(cx.height / 26.68)),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            (cx.read(
                                              Keys.image,
                                            )).isEmpty
                                                ? "https://thumbs.dreamstime.com/b/indoor-stadium-view-behind-wicket-cricket-160851985.jpg"
                                                : cx.read(
                                                    Keys.image,
                                                  ),
                                            scale: cx.height > 800 ? 1.8 : 2.4,
                                          ),
                                          fit: BoxFit.cover,
                                          onError: (Object e,
                                              StackTrace? stackTrace) {
                                            setState(() {
                                              errorDomeImage
                                                  .add(cx.read(Keys.domeId));
                                            });
                                          },
                                        )),
                                margin:
                                    EdgeInsets.only(left: 8, right: 8, top: 8),
                                width: MediaQuery.of(context).size.width,
                                height: cx.height / 4.3,
                              ),
                            ],
                          ),
                        ),
                      ),
                      isTimerAvailable
                          ? Padding(
                              padding: EdgeInsets.only(
                                  top: 0,
                                  left: cx.width * 0.09,
                                  right: cx.width * 0.09,
                                  bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppColor.bg,
                                    borderRadius: BorderRadius.circular(
                                        cx.height / 44.47)),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  cx.height / 37.06),
                                              topRight: Radius.circular(
                                                  cx.height / 37.06))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    241, 247, 236, 0.6),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        cx.height / 44.47)),
                                            child: ListTile(
                                              dense: true,
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      20,
                                                      cx.height / 100,
                                                      cx.height / 44.47,
                                                      0),
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    // width:cx.width*0.15,
                                                    decoration: BoxDecoration(
                                                        color: paymentStatus ==
                                                                "In Progress"
                                                            ? Color(0xFFFDF5D2)
                                                            : Colors
                                                                .transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: paymentStatus ==
                                                                    "In Progress"
                                                                ? Color(
                                                                    0xFFE1DAB4)
                                                                : Color(
                                                                    0xFFF04257))),

                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                        10,
                                                        0,
                                                        10,
                                                        4,
                                                      ),
                                                      child: InterText(
                                                        text: paymentStatus,
                                                        // color: Color(0XFFA19A6F),
                                                        color: paymentStatus ==
                                                                "In Progress"
                                                            ? Color(0XFFA19A6F)
                                                            : Color(0xFFFF5C5C),
                                                        fontSize: cx.responsive(
                                                            20, 15, 12),
                                                        textAlign:
                                                            TextAlign.center,
                                                        height: 1.7,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    // alignment: Alignment.center,
                                                  ),
                                                  Gap(8),
                                                  SenticText(
                                                    text:
                                                        cx.read(Keys.domeName),
                                                    fontSize: cx.height > 800
                                                        ? 21
                                                        : 19,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF222222),
                                                  ),
                                                  Gap(4),
                                                ],
                                              ),
                                              trailing: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isexpanded = !isexpanded;
                                                  });
                                                  print(isexpanded);
                                                },
                                                child: Icon(
                                                    isexpanded
                                                        ? Icons
                                                            .keyboard_arrow_down_rounded
                                                        : Icons
                                                            .keyboard_arrow_up_rounded,
                                                    size: 35,
                                                    color: AppColor.darkGreen),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    splitTicket(),
                                    isCancelAvailable
                                        ? Container(
                                            height: cx.height / 9,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                      cx.height / 37.06),
                                                  bottomRight: Radius.circular(
                                                      cx.height / 37.06),
                                                )),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      20.0, 0, 20, 0),
                                                  child: const Divider(
                                                    color: Color(0xFFE7F4EF),
                                                    thickness: 2,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    onCancelAlert(
                                                        context: context,
                                                        bookingId: widget
                                                            .bookingId
                                                            .toString(),
                                                        onCancel: () {
                                                          Get.back();
                                                          cancelAccount(
                                                                  context:
                                                                      context,
                                                                  bookingId: widget
                                                                      .bookingId
                                                                      .toString())
                                                              .then((value) {
                                                            if (value == 1) {
                                                              setState(() {
                                                                paymentStatus =
                                                                    "Cancelled";
                                                                isCancelAvailable =
                                                                    false;
                                                                isTimerAvailable =
                                                                    false;
                                                              });
                                                            }
                                                          });
                                                        });
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Gap(7),
                                                      InterText(
                                                        text: "Cancel Booking",
                                                        color:
                                                            Color(0xFFB01717),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: cx.responsive(
                                                            25, 21, 18),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ))
                                        : Container(),
                                    Gap(cx.height / 15),
                                    InkWell(
                                      onTap: () {
                                        Get.offAll(MainPageScreen());
                                        setState(() {
                                          cx.curIndex.value = 0;
                                        });
                                      },
                                      child: Container(
                                        height: cx.height / 15,
                                        width: cx.width / 2,
                                        decoration: BoxDecoration(
                                            color: AppColor.darkGreen,
                                            borderRadius:
                                                BorderRadius.circular(7)),
                                        alignment: Alignment.center,
                                        child: NunitoText(
                                          text: "Home",
                                          fontSize: cx.responsive(28, 22, 18),
                                          textAlign: TextAlign.center,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Gap(20)
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  isTimerAvailable
                      ? Positioned(
                          top: cx.height / 6.06,
                          right: 2,
                          left: 4,
                          child: timerBox(isDefaultTime,
                              seconds: seconds,
                              minutes: minutes,
                              hours: hours,
                              seconds1: seconds1,
                              minutes1: minutes1,
                              hours1: hours1,
                              paymentLink: widget.paymentLink,
                              timerMessage:
                                  "Share The Link To Split Amount Within The Given Time"),
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                              top: cx.height / 6,
                              left: cx.width * 0.09,
                              right: cx.width * 0.09,
                              bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColor.bg,
                                borderRadius:
                                    BorderRadius.circular(cx.height / 44.47)),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                              cx.height / 37.06),
                                          topRight: Radius.circular(
                                              cx.height / 37.06))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                241, 247, 236, 0.6),
                                            borderRadius: BorderRadius.circular(
                                                cx.height / 44.47)),
                                        child: ListTile(
                                          dense: true,
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20,
                                              cx.height / 100,
                                              cx.height / 44.47,
                                              0),
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                // width:cx.width*0.15,
                                                decoration: BoxDecoration(
                                                    color: paymentStatus ==
                                                            "In Progress"
                                                        ? Color(0xFFFDF5D2)
                                                        : Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: paymentStatus ==
                                                                "In Progress"
                                                            ? Color(0xFFE1DAB4)
                                                            : Color(
                                                                0xFFF04257))),

                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                    10,
                                                    0,
                                                    10,
                                                    4,
                                                  ),
                                                  child: InterText(
                                                    text: paymentStatus,
                                                    // color: Color(0XFFA19A6F),
                                                    color: paymentStatus ==
                                                            "In Progress"
                                                        ? Color(0XFFA19A6F)
                                                        : Color(0xFFFF5C5C),
                                                    fontSize: cx.responsive(
                                                        20, 15, 12),
                                                    textAlign: TextAlign.center,
                                                    height: 1.7,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                // alignment: Alignment.center,
                                              ),
                                              Gap(8),
                                              SenticText(
                                                text: cx.read(Keys.domeName),
                                                fontSize:
                                                    cx.height > 800 ? 21 : 19,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF222222),
                                              ),
                                              Gap(4),
                                            ],
                                          ),
                                          trailing: InkWell(
                                            onTap: () {
                                              setState(() {
                                                isexpanded = !isexpanded;
                                              });
                                              print(isexpanded);
                                            },
                                            child: Icon(
                                                isexpanded
                                                    ? Icons
                                                        .keyboard_arrow_down_rounded
                                                    : Icons
                                                        .keyboard_arrow_up_rounded,
                                                size: 35,
                                                color: AppColor.darkGreen),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                splitTicket(),
                                Gap(cx.height / 15),
                                InkWell(
                                  onTap: () {
                                    Get.offAll(MainPageScreen());
                                    setState(() {
                                      cx.curIndex.value = 0;
                                    });
                                  },
                                  child: Container(
                                    height: cx.height / 15,
                                    width: cx.width / 2,
                                    decoration: BoxDecoration(
                                        color: AppColor.darkGreen,
                                        borderRadius: BorderRadius.circular(7)),
                                    alignment: Alignment.center,
                                    child: NunitoText(
                                      text: "Home",
                                      fontSize: cx.responsive(28, 22, 18),
                                      textAlign: TextAlign.center,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Gap(20)
                              ],
                            ),
                          ),
                        )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget splitTicket() {
    return Column(
      children: [
        SingleChildScrollView(
          child: TicketWidget(
            color: AppColor.ticketWidget,
            width: MediaQuery.of(context).size.width,
            isCornerRounded: false,
            padding: const EdgeInsets.all(0),
            height: isexpanded ? cx.height * 0.08 : cx.height * 0.7,
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                isexpanded
                    ? Container()
                    : Container(
                        height: cx.height * 0.345,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20, top: cx.height / 44.47),
                              child: Row(
                                children: [
                                  Container(
                                    width: cx.width * 0.23,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        NunitoText(
                                            text: "Field",
                                            fontSize: cx.height > 800 ? 19 : 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.grey),
                                        Container(
                                          width: cx.width * 0.345,
                                          child: NunitoText(
                                            text: cx.read(Keys.fieldName),
                                            fontSize: cx.height > 800 ? 17 : 15,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF414141),
                                            textOverflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 40,
                                        ),
                                        NunitoText(
                                            text: "Players",
                                            fontSize: cx.height > 800 ? 19 : 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.grey),
                                        NunitoText(
                                            text: cx
                                                .read(Keys.players)
                                                .toString(),
                                            fontSize: cx.height > 800 ? 17 : 15,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF414141)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        NunitoText(
                                            text: "Date",
                                            fontSize: cx.height > 800 ? 20 : 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.grey),
                                        NunitoText(
                                            text: cx.read(Keys.selMonth) +
                                                ' ' +
                                                cx.read(Keys.selDate) +
                                                ', ' +
                                                cx.read(Keys.selYear),
                                            fontSize: cx.height > 800 ? 17 : 15,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF414141)),
                                        const SizedBox(
                                          width: 40,
                                        ),
                                        NunitoText(
                                            text: "Time",
                                            fontSize: cx.height > 800 ? 20 : 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.grey),
                                        NunitoText(
                                            text: cx
                                                    .read(Keys.startTime)
                                                    .toString()
                                                    .substring(0, 5) +
                                                cx
                                                    .read(Keys.startTime)
                                                    .toString()
                                                    .substring(6, 8) +
                                                " To " +
                                                cx
                                                    .read(Keys.endTime)
                                                    .toString()
                                                    .substring(11, 16) +
                                                cx
                                                    .read(Keys.endTime)
                                                    .toString()
                                                    .substring(17, 19),
                                            fontSize: cx.height > 800 ? 17 : 15,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF414141)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20, top: cx.height / 44.47),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NunitoText(
                                      text: "Address",
                                      fontSize: cx.height > 800 ? 20 : 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.grey),
                                  Container(
                                    width: cx.width * 0.7,
                                    child: NunitoText(
                                        text: cx.read(Keys.address),
                                        maxLines: 2,
                                        textOverflow: TextOverflow.ellipsis,
                                        fontSize: cx.height > 800 ? 17 : 15,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF414141)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                Padding(
                  padding: isexpanded
                      ? EdgeInsets.fromLTRB(
                          0.0, cx.height * 0.035, 0, cx.height * 0.035)
                      : EdgeInsets.zero,
                  child: MySeparator(
                    color: Color.fromRGBO(231, 244, 239, 1),
                  ),
                ),
                isexpanded
                    ? Container()
                    : Container(
                        height: cx.height * 0.33,
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 55,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 25.0, left: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: cx.responsive(25, 18, 13),
                                      top: cx.responsive(18, 14, 12),
                                    ),
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          NunitoText(
                                              text: "Paid Amount",
                                              fontSize:
                                                  cx.responsive(23, 18, 15),
                                              fontWeight: FontWeight.w600,
                                              color: AppColor.grey),
                                          Gap(8),
                                          NunitoText(
                                              text: "Remaining Amount",
                                              fontSize:
                                                  cx.responsive(23, 18, 15),
                                              fontWeight: FontWeight.w600,
                                              color: AppColor.grey),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: cx.responsive(4, 3, 2),
                                      top: cx.responsive(18, 15, 13),
                                    ),
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          NunitoText(
                                              textAlign: TextAlign.end,
                                              text: "\$" +
                                                  cx
                                                      .read(
                                                          Keys.splitPaidAmount)
                                                      .toStringAsFixed(2),
                                              fontSize:
                                                  cx.responsive(25, 20, 17),
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF757575)),
                                          Gap(5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            // crossAxisAlignment:
                                            // CrossAxisAlignment.end,
                                            children: [
                                              NunitoText(
                                                  textAlign: TextAlign.end,
                                                  text: "+ \$" +
                                                      cx
                                                          .read(Keys
                                                              .splitRemainingAmount)
                                                          .toStringAsFixed(2),
                                                  fontSize:
                                                      cx.responsive(25, 20, 17),
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xFF757575)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gap(12),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                              child: const Divider(
                                color: Color(0xFFE7F4EF),
                                thickness: 2,
                              ),
                            ),
                            Gap(7),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  cx.height / 55.58, 4, 20, 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // crossAxisAlignment:
                                // CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // width: cx.width * 0.505,
                                    child: NunitoText(
                                        text: "  Total",
                                        fontSize: cx.responsive(27, 22, 19),
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF757575)),
                                  ),
                                  SenticText(
                                      textAlign: TextAlign.start,
                                      text: " \$" +
                                          cx
                                              .read(Keys.total)
                                              .toStringAsFixed(2),
                                      fontSize: cx.responsive(29, 24, 21),
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF07261A)),
                                ],
                              ),
                            ),
                            Gap(cx.height * 0.01),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                              ),
                              child: Container(
                                  width: cx.width * 0.7,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      color: AppColor.bg),
                                  padding: EdgeInsets.fromLTRB(10, 6, 3, 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: cx.responsive(25, 22.5, 20),
                                        backgroundColor: Colors.white,
                                        child: CachedNetworkImage(
                                          imageUrl: widget.image,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: cx.responsive(25, 20, 17),
                                            backgroundImage: NetworkImage(
                                              widget.image,
                                            ),
                                          ),
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: cx.responsive(25, 20, 17),
                                            backgroundImage: AssetImage(
                                              Image1.anime,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: cx.responsive(25, 20, 17),
                                            backgroundImage: AssetImage(
                                              Image1.anime,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Gap(16),
                                      Container(
                                        width: cx.width * 0.5,
                                        child: NunitoText(
                                          text: widget.email,
                                          fontWeight: FontWeight.w500,
                                          fontSize: cx.responsive(22, 18, 16),
                                          color: Color(0xFF628477),
                                          textOverflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
        isexpanded
            ? Container(
                height: cx.height * 0.39,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: isexpanded && !isCancelAvailable
                        ? BorderRadius.only(
                            bottomLeft: Radius.circular(cx.height / 37.06),
                            bottomRight: Radius.circular(cx.height / 37.06))
                        : BorderRadius.zero),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: cx.responsive(25, 18, 13),
                              top: cx.responsive(18, 14, 12),
                            ),
                            child: Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NunitoText(
                                      text: "Paid Amount",
                                      fontSize: cx.responsive(23, 18, 15),
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.grey),
                                  Gap(8),
                                  NunitoText(
                                      text: "Remaining Amount",
                                      fontSize: cx.responsive(23, 18, 15),
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.grey),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: cx.responsive(4, 3, 2),
                              top: cx.responsive(18, 15, 13),
                            ),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  NunitoText(
                                      textAlign: TextAlign.end,
                                      text: "\$" +
                                          cx
                                              .read(Keys.splitPaidAmount)
                                              .toStringAsFixed(2),
                                      fontSize: cx.responsive(25, 20, 17),
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF757575)),
                                  Gap(5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    // crossAxisAlignment:
                                    // CrossAxisAlignment.end,
                                    children: [
                                      NunitoText(
                                          textAlign: TextAlign.end,
                                          text: "+ \$" +
                                              cx
                                                  .read(
                                                      Keys.splitRemainingAmount)
                                                  .toStringAsFixed(2),
                                          fontSize: cx.responsive(25, 20, 17),
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF757575)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(13),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                      child: const Divider(
                        color: Color(0xFFE7F4EF),
                        thickness: 2,
                      ),
                    ),
                    Gap(7),
                    Padding(
                      padding: EdgeInsets.fromLTRB(cx.height / 55.58, 4, 20, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment:
                        // CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: NunitoText(
                                text: "  Total",
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF757575)),
                          ),
                          SenticText(
                              textAlign: TextAlign.start,
                              text: " \$" +
                                  cx.read(Keys.total).toStringAsFixed(2),
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF07261A)),
                        ],
                      ),
                    ),
                    Gap(cx.height * 0.01),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: Container(
                          width: cx.width * 0.7,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: AppColor.bg,
                              border: Border.all(color: Color(0xFF9BD9C1))),
                          padding: EdgeInsets.fromLTRB(10, 6, 3, 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: cx.responsive(25, 22.5, 20),
                                backgroundColor: Colors.white,
                                child: CachedNetworkImage(
                                  imageUrl: widget.image,
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: cx.responsive(25, 20, 17),
                                    backgroundImage: NetworkImage(
                                      widget.image,
                                    ),
                                  ),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: cx.responsive(25, 20, 17),
                                    backgroundImage: AssetImage(
                                      Image1.anime,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: cx.responsive(25, 20, 17),
                                    backgroundImage: AssetImage(
                                      Image1.anime,
                                    ),
                                  ),
                                ),
                              ),
                              Gap(16),
                              Container(
                                width: cx.width * 0.5,
                                child: NunitoText(
                                  text: widget.email,
                                  fontWeight: FontWeight.w500,
                                  fontSize: cx.responsive(22, 18, 16),
                                  color: Color(0xFF628477),
                                  textOverflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              )
            : isCancelAvailable
                ? Container()
                : Container(
                    height: cx.height / 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(cx.height / 37.06),
                            bottomRight: Radius.circular(cx.height / 37.06))),
                    child: Column(
                      children: [
                        Container(color: Colors.white, height: 0),
                      ],
                    ),
                  ),
      ],
    );
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = dur.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        dur = Duration(seconds: seconds);
      }
    });
  }

  void startTimer1() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown1());
  }

  void setCountDown1() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }
}
