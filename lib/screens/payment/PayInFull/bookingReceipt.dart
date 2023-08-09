import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import '../../../../commonModule/AppColor.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ticket_widget/ticket_widget.dart';
import '../../../../controller/commonController.dart';
import '../../../../main_page.dart';
import '../../../commonModule/Strings.dart';
import 'package:gap/gap.dart';
import '../../../commonModule/utils.dart';
import '../../../commonModule/widget/common/mySeperator.dart';
import '../../../commonModule/widget/common/textInter.dart';
import '../../../commonModule/widget/common/textNunito.dart';

import '../../../commonModule/widget/common/textSentic.dart';

class BookingReceipt extends StatefulWidget {
  final String email;
  final String image;
  final String bookingId;
  final String paymentLink;
  final DateTime? bookingTime;
  final DateTime? currentTime;

  BookingReceipt({
    Key? key,
    required this.email,
    required this.image,
    required this.bookingId,
    required this.paymentLink,
    required this.bookingTime,
    required this.currentTime,
  }) : super(key: key);

  @override
  State<BookingReceipt> createState() => _BookingReceiptState();
}

class _BookingReceiptState extends State<BookingReceipt> {
  CommonController cx = Get.put(CommonController());

  bool isCancelTimerAvailable = true;
  String paymentStatus = 'Paid';
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  Timer? countdownTimer;
  Duration myDuration = Duration(hours: 1, minutes: 59, seconds: 60);

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

  bool isDefaultTime = true;

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  List<int> errorDomeImage = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDynamicLinks();
    currentTime = widget.currentTime ?? DateTime.now();

    setState(() {
      print("Timing Details");
      print(cx.read(Keys.fullDate));
      print(cx.read(Keys.startTime).toString().substring(0, 2));

      startTime = cx.read(Keys.startTime).toString().substring(0, 2);

      print(cx.read(Keys.startTime).toString().substring(6, 8));
      if (cx.read(Keys.startTime).toString().substring(6, 8) == "PM") {
        print("startTime1");
        if (cx.read(Keys.startTime).toString().substring(0, 2) != "12") {
          startTime = (int.parse(startTime) + 12).toString();
        }
      } else {
        if (cx.read(Keys.startTime).toString().substring(0, 2) == "12") {
          startTime = "00";
        }
      }
      print("startTime2");
      print(startTime);

      // timeRemaining = "2023-04-03" + ' ' + "21" + ":00:00";
      timeRemaining = cx.read(Keys.fullDate) +
          ' ' +
          startTime +
          ":${cx.read(Keys.startTime).toString().substring(3, 5)}:00";

      print(timeRemaining);
      bookingTime = DateTime.parse(timeRemaining);
      print(bookingTime);

      print("Default Time?");
      print(bookingTime.subtract(Duration(hours: 4)));
      print(bookingTime.millisecondsSinceEpoch);
      print(widget.currentTime ?? DateTime.now());

      if (bookingTime.subtract(Duration(hours: 4)).millisecondsSinceEpoch <=
          (widget.currentTime ?? DateTime.now()).millisecondsSinceEpoch) {
        dur = bookingTime.difference(currentTime);
        print(dur);
        if (dur.inHours >= 2) {
          print("Less than 4 hours");
          dur = dur - calDuration;
          print(dur);
        } else {
          print("Less than 2 hours left in playing time");
          dur = Duration(days: 0);
        }

        print("Duration");

        print(dur.inHours);
        print(dur.inMinutes);
        print(dur.inSeconds);

        startTimer();
        isDefaultTime = false;
      } else {
        print("Time is bigger");
        isDefaultTime = true;
        startTimer1();
        print(myDuration.inHours);
        print(myDuration.inMinutes);
        print(myDuration.inSeconds);
      }
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
        isCancelTimerAvailable = false;
      }
    } else {
      if (int.parse(hours) <= 0 &&
          int.parse(minutes) <= 0 &&
          int.parse(seconds) <= 0) {
        print("Timer Over");
        isCancelTimerAvailable = false;
      }
    }

    //-----Before 2 hours of Booking Time-----
    if ((widget.currentTime ?? DateTime.now()).millisecondsSinceEpoch >=
        bookingTime.subtract(Duration(hours: 2)).millisecondsSinceEpoch) {
      isCancelTimerAvailable = false;
    }

    return WillPopScope(
      onWillPop: () async {
        Get.offAll(WonderEvents());
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColor.bg,
        key: _scaffoldkey,
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
                          height: isCancelTimerAvailable
                              ? cx.height * 0.5
                              : cx.height * 1.3,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                decoration: errorDomeImage
                                    .contains(cx.read(Keys.domeId))
                                    ? BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(20),
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
                                        scale:
                                        cx.height > 800 ? 1.8 : 2.4,
                                      ),
                                      fit: BoxFit.cover,
                                      onError: (Object e,
                                          StackTrace? stackTrace) {
                                        setState(() {
                                          errorDomeImage
                                              .add(cx.read(Keys.domeId));
                                        });
                                      },
                                    )
                                ),
                                margin: EdgeInsets.only(
                                    left: 8, right: 8, top: 8),
                                width: MediaQuery.of(context).size.width,
                                height: cx.height / 4.3,
                              ),
                            ],
                          ),
                        ),
                      ),

                      isCancelTimerAvailable
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
                                                      cx.height / 55.58,
                                                      cx.height / 44.47,
                                                      0),
                                              title: Container(
                                                width: cx.width * 0.6,
                                                child: SenticText(
                                                  text: cx.read(Keys.domeName),
                                                  fontSize:
                                                      cx.height > 800 ? 24 : 21,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF222222),
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                              trailing: Container(
                                                // width: cx.width*0.15,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    border: Border.all(
                                                        color: paymentStatus ==
                                                                "Paid"
                                                            ? AppColor.darkGreen
                                                            : Color(
                                                                0xFfF04257))),
                                                padding: paymentStatus == "Paid"
                                                    ? EdgeInsets.fromLTRB(
                                                        10, 5, 10, 5)
                                                    : EdgeInsets.fromLTRB(
                                                        10, 5, 10, 5),
                                                child: SenticText(
                                                  textAlign: TextAlign.center,
                                                  text: paymentStatus,
                                                  fontSize:
                                                      cx.height > 800 ? 17 : 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: paymentStatus == "Paid"
                                                      ? AppColor.darkGreen
                                                      : Color(0xFFFF5C5C),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    fullReceipt(),
                                    isCancelTimerAvailable
                                        ? Container(
                                            height: isCancelTimerAvailable
                                                ? cx.height / 9
                                                : cx.height / 50,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft: Radius.circular(
                                                        cx.height / 37.06),
                                                    bottomRight:
                                                        Radius.circular(
                                                            cx.height /
                                                                37.06))),
                                            child: isCancelTimerAvailable
                                                ? Column(
                                                    children: [
                                                      isCancelTimerAvailable
                                                          ? Column(
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          20.0,
                                                                          0,
                                                                          20,
                                                                          0),
                                                                  child:
                                                                      const Divider(
                                                                    color: Color(
                                                                        0xFFE7F4EF),
                                                                    thickness:
                                                                        2,
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    onCancelAlert(
                                                                        context:
                                                                            context,
                                                                        bookingId: widget
                                                                            .bookingId
                                                                            .toString(),
                                                                        onCancel:
                                                                            () {
                                                                          Get.back();
                                                                          cancelAccount(context: context, bookingId: widget.bookingId.toString())
                                                                              .then((value) {
                                                                            if (value ==
                                                                                1) {
                                                                              setState(() {
                                                                                paymentStatus = "Cancelled";
                                                                                isCancelTimerAvailable = false;
                                                                              });
                                                                            }
                                                                          });
                                                                        });
                                                                  },
                                                                  child: Column(
                                                                    children: [
                                                                      Gap(7),
                                                                      InterText(
                                                                        text:
                                                                            "Cancel Booking",
                                                                        color: Color(
                                                                            0xFFB01717),
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                        fontSize: cx.responsive(
                                                                            25,
                                                                            21,
                                                                            18),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Container(),
                                                    ],
                                                  )
                                                : Container(),
                                          )
                                        : Container(),
                                    Gap(cx.height / 15),
                                    InkWell(
                                      onTap: () {
                                        Get.offAll(WonderEvents());
                                        setState(() {
                                          cx.curIndex.value = 0;
                                        });
                                      },
                                      child: Container(
                                        height: cx.height / 18,
                                        width: cx.width / 1.7,
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
                  isCancelTimerAvailable
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
                                  "You can cancel this booking within the given time"),
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
                                              cx.height / 55.58,
                                              cx.height / 44.47,
                                              0),
                                          title: Container(
                                            width: cx.width * 0.6,
                                            child: SenticText(
                                              text: cx.read(Keys.domeName),
                                              fontSize:
                                                  cx.height > 800 ? 24 : 21,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF222222),
                                              textOverflow:
                                                  TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                          trailing: Container(
                                            // width: cx.width*0.15,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                border: Border.all(
                                                    color: paymentStatus ==
                                                            "Paid"
                                                        ? AppColor.darkGreen
                                                        : Color(0xFFF04257))),
                                            padding: paymentStatus == "Paid"
                                                ? EdgeInsets.fromLTRB(
                                                    10, 5, 10, 5)
                                                : EdgeInsets.fromLTRB(
                                                    10, 5, 10, 5),
                                            child: SenticText(
                                              textAlign: TextAlign.center,
                                              text: paymentStatus,
                                              fontSize:
                                                  cx.height > 800 ? 17 : 14,
                                              fontWeight: FontWeight.w600,
                                              color: paymentStatus == "Paid"
                                                  ? AppColor.darkGreen
                                                  : Color(0xFFFF5C5C),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                fullReceipt(),
                                Container(
                                  height: isCancelTimerAvailable
                                      ? cx.height / 9
                                      : cx.height / 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(
                                              cx.height / 37.06),
                                          bottomRight: Radius.circular(
                                              cx.height / 37.06))),
                                  child: isCancelTimerAvailable
                                      ? Column(
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
                                                    bookingId: widget.bookingId
                                                        .toString(),
                                                    onCancel: () {
                                                      Get.back();
                                                      cancelAccount(
                                                              context: context,
                                                              bookingId: widget
                                                                  .bookingId
                                                                  .toString())
                                                          .then((value) {
                                                        if (value == 1) {
                                                          setState(() {
                                                            paymentStatus =
                                                                "Cancelled";
                                                            isCancelTimerAvailable =
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
                                                    color: Color(0xFFB01717),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: cx.responsive(
                                                        25, 21, 18),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ),
                                Gap(cx.height / 15),
                                InkWell(
                                  onTap: () {
                                    Get.offAll(WonderEvents());
                                    setState(() {
                                      cx.curIndex.value = 0;
                                    });
                                  },
                                  child: Container(
                                    height: cx.height / 18,
                                    width: cx.width / 1.7,
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
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fullReceipt() {
    return SingleChildScrollView(
      child: TicketWidget(
        color: AppColor.ticketWidget,
        width: MediaQuery.of(context).size.width,
        isCornerRounded: false,
        padding: const EdgeInsets.all(0),
        height: cx.height * 0.8,
        child: Column(
          // shrinkWrap: true,
          // physics: ClampingScrollPhysics(),
          children: [
            Container(
              height: cx.height * 0.40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: cx.height / 44.47),
                    child: Row(
                      children: [
                        Container(
                          width: cx.width * 0.23,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NunitoText(
                                  text: "Field",
                                  fontSize: cx.height > 800 ? 18 : 16,
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
                                  fontSize: cx.height > 800 ? 18 : 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.grey),
                              NunitoText(
                                  text: cx.read(Keys.players).toString(),
                                  fontSize: cx.height > 800 ? 17 : 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF414141)),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NunitoText(
                                  text: "Date",
                                  fontSize: cx.height > 800 ? 18 : 16,
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
                                  fontSize: cx.height > 800 ? 18 : 16,
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
                    padding: EdgeInsets.only(left: 20, top: cx.height / 44.47),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NunitoText(
                            text: "Address",
                            fontSize: cx.height > 800 ? 18 : 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.grey),
                        Container(
                          width: cx.width * 0.7,
                          child: NunitoText(
                              text: cx.read(Keys.address),
                              fontSize: cx.height > 800 ? 17 : 15,
                              maxLines: cx.height > 800 ? 3 : 2,
                              textOverflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF414141)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            MySeparator(
              color: Color.fromRGBO(231, 244, 239, 1),
            ),
            Container(
              height: cx.height * 0.38,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: cx.height / 33.5, top: cx.height / 66.7),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NunitoText(
                                  text: "Sub Total",
                                  fontSize: cx.responsive(25, 20, 17),
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.grey),
                              Gap(6),
                              NunitoText(
                                  text: "Service Fee",
                                  fontSize: cx.responsive(25, 20, 17),
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.grey),
                              Gap(6),
                              Row(
                                children: [
                                  NunitoText(
                                      text: "HST  ",
                                      fontSize: cx.responsive(25, 20, 17),
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.grey),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: cx.responsive(4, 3, 2),
                            top: cx.responsive(14, 10, 7),
                          ),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                NunitoText(
                                    textAlign: TextAlign.end,
                                    text: "\$" +
                                        cx.read(Keys.price).toStringAsFixed(2),
                                    fontSize: cx.responsive(28, 22, 18),
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF757575)),
                                Gap(4),
                                NunitoText(
                                    textAlign: TextAlign.end,
                                    text: "+ \$" +
                                        cx
                                            .read(Keys.serviceFee)
                                            .toStringAsFixed(2),
                                    fontSize: cx.responsive(28, 22, 18),
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF757575)),
                                Gap(4),
                                NunitoText(
                                    textAlign: TextAlign.end,
                                    text: "+ \$" +
                                        cx
                                            .read(Keys.totalHST)
                                            .toStringAsFixed(2),
                                    fontSize: cx.responsive(28, 22, 18),
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF757575)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(6),
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
                              fontSize: cx.responsive(27, 22, 19),
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF757575)),
                        ),
                        SenticText(
                            textAlign: TextAlign.start,
                            text:
                                " \$" + cx.read(Keys.total).toStringAsFixed(2),
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
                            Gap(5),
                            Container(
                              width: cx.width * 0.5,
                              child: NunitoText(
                                text: widget.email.toString(),
                                fontWeight: FontWeight.w500,
                                fontSize: cx.responsive(22, 18, 16),
                                color: AppColor.darkGreen,
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
