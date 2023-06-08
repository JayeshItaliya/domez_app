import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import '../../commonModule/AppColor.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ticket_widget/ticket_widget.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/Strings.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/mySeperator.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../controller/commonController.dart';
import '../../main_page.dart';
import '../../commonModule/widget/common/textSentic.dart';

class FinalLeagueReceipt extends StatefulWidget {
  String email;
  String image;
  String bookingId;
  String paymentLink;

  FinalLeagueReceipt(
      {Key? key,
      required this.email,
      required this.image,
      required this.bookingId,
      required this.paymentLink})
      : super(key: key);

  @override
  State<FinalLeagueReceipt> createState() => _FinalLeagueReceiptState();
}

class _FinalLeagueReceiptState extends State<FinalLeagueReceipt> {
  CommonController cx = Get.put(CommonController());
  bool fav = false;
  bool emailCorrect = false;
  bool isCancelAvailable = true;

  final GlobalKey<FormState> bottomEmailKey = GlobalKey<FormState>();

  TextEditingController controller = TextEditingController(text: "");
  bool isCancelTimerAvailable = true;
  String paymentStatus = 'Paid';
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

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
  bool isDataProcesssing = false;

  String hours1 = '';
  String minutes1 = '';
  String seconds1 = '';

  bool isDefaultTime = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      print("Timing Details");
      // print(cx.read(Keys.fullDate));
      // print(cx.read(Keys.startTime).toString().substring(0, 2));
      //
      // startTime = cx.read(Keys.startTime).toString().substring(0, 2);
      //
      // print(cx.read(Keys.startTime).toString().substring(6, 8));
      // if (cx.read(Keys.startTime).toString().substring(6, 8) == "PM") {
      //   print("startTime1");
      //   if (cx.read(Keys.startTime).toString().substring(0, 2) != "12") {
      //     startTime = (int.parse(startTime) + 12).toString();
      //   }
      // } else {
      //   if (cx.read(Keys.startTime).toString().substring(0, 2) == "12") {
      //     startTime = "00";
      //   }
      // }
      // print("startTime2");
      // print(startTime);

      // timeRemaining = "2023-04-03" + ' ' + "21" + ":00:00";

      // print(cx.read(LKeys.leagueDeadline));
      // timeRemaining = cx.read(LKeys.leagueDeadline) + " 22:00:00";
      //
      // print(timeRemaining);
      // bookingTime = DateTime.parse(timeRemaining);
      // print(bookingTime);

      bookingTime=cx.read(LKeys.leagueDeadline);

      print(todayTime.add(Duration(hours: 2)));

      print("Default Time?");
      print(bookingTime.subtract(Duration(hours:4)));
      print(DateTime.now());
      print(bookingTime.millisecondsSinceEpoch);
      print(DateTime.now().millisecondsSinceEpoch);
      if (bookingTime.subtract(Duration(hours: 4)).millisecondsSinceEpoch <= DateTime.now().millisecondsSinceEpoch) {
        dur = bookingTime.difference(currentTime);
        print(dur);
        if(dur.inHours>=2){
          print("Less than 4 hours");
          dur = dur-calDuration;
          print(dur);
        }
        else{
          print("Less than 2 hours left in playing time");
          dur=Duration(days: 0);
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
    // dur=Duration(seconds:10);
    print(hours);
    print(minutes);
    print(seconds);
    print(hours1);
    print(minutes1);
    print(seconds1);

    //-----Booking Time Passed-----
    if(isDefaultTime){
      if (int.parse(hours1) <= 0 &&
          int.parse(minutes1) <= 0 &&
          int.parse(seconds1) <= 0
      ) {
        print("Timer Over");
        isCancelTimerAvailable = false;
      }
    }
    else{
      if(int.parse(hours) <= 0 &&
          int.parse(minutes) <= 0 &&
          int.parse(seconds) <= 0){
        print("Timer Over");
        isCancelTimerAvailable = false;
      }
    }

    //-----Before 2 hours of Booking Time-----
    if (DateTime.now().millisecondsSinceEpoch >=
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
        body: Stack(
          children: [
            Container(
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
                              height: isCancelTimerAvailable?cx.height *0.5:cx.height * 1.3,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 8, right: 8, top: 8),
                                    width: MediaQuery.of(context).size.width,
                                    height: cx.height / 4.3,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(cx.height / 26.68)),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/step.png"),
                                          fit: BoxFit.cover),
                                    ),
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
                                                      text: cx
                                                          .read(LKeys.leagueName),
                                                      fontSize: cx.height > 800
                                                          ? 24
                                                          : 21,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                                            BorderRadius
                                                                .circular(50),
                                                        border: Border.all(
                                                            color: paymentStatus ==
                                                                    "Paid"
                                                                ? AppColor
                                                                    .darkGreen
                                                                : Color(
                                                                    0xFfF04257))),
                                                    padding: paymentStatus ==
                                                            "Paid"
                                                        ? EdgeInsets.fromLTRB(
                                                            10, 5, 10, 5)
                                                        : EdgeInsets.fromLTRB(
                                                            10, 5, 10, 5),
                                                    child: SenticText(
                                                      textAlign:
                                                          TextAlign.center,
                                                      text: paymentStatus,
                                                      fontSize: cx.height > 800
                                                          ? 17
                                                          : 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: paymentStatus ==
                                                              "Paid"
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
                                                    borderRadius: BorderRadius
                                                        .only(
                                                            bottomLeft: Radius
                                                                .circular(
                                                                    cx.height /
                                                                        37.06),
                                                            bottomRight: Radius
                                                                .circular(
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
                                                                            bookingId:
                                                                                widget.bookingId.toString(),
                                                                            onCancel: () {
                                                                              Get.back();
                                                                              cancelAccount(context: context, bookingId: widget.bookingId.toString()).then((value) {
                                                                                setState(() {
                                                                                  paymentStatus = "Cancelled";
                                                                                  isCancelTimerAvailable = false;
                                                                                });
                                                                                // mycontroller.setBid();
                                                                              });
                                                                            });
                                                                      },
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Gap(7),
                                                                          InterText(
                                                                            text:
                                                                                "Cancel Booking",
                                                                            color:
                                                                                Color(0xFFB01717),
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            fontSize:
                                                                                cx.responsive(25,21, 18),
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
                                              fontSize: cx.responsive(28,22, 18),
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
                                  left: cx.width*0.09,
                                  right: cx.width*0.09,
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
                                                  text:
                                                      cx.read(LKeys.leagueName),
                                                  fontSize: cx.height > 800 ? 24 : 21,

                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF222222),
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                              trailing: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    border: Border.all(
                                                        color: paymentStatus ==
                                                                "Paid"
                                                            ? AppColor.darkGreen
                                                            : Color(
                                                                0xFFF04257))),
                                                padding: paymentStatus=="Paid"?
                                                EdgeInsets.fromLTRB(10,5,10,5):
                                                EdgeInsets.fromLTRB(10,5,10,5),                                                child: SenticText(
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
                                      height: isCancelAvailable
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
                                                  padding:
                                                      EdgeInsets.fromLTRB(
                                                          20.0, 0, 20, 0),
                                                  child: const Divider(
                                                    color:
                                                        Color(0xFFE7F4EF),
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
                                                              .then(
                                                                  (value) {
                                                            setState(() {
                                                              paymentStatus =
                                                                  "Cancelled";
                                                              isCancelAvailable =
                                                                  false;
                                                            });
                                                            // mycontroller.setBid();
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
                                                        fontSize:
                                                            cx.responsive(25,21, 18),
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
                                          cx.curIndex.value = 2;
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
                                          fontSize: cx.responsive(28,22, 18),
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
          ],
        ),
      ),
    );
  }

  Widget fullReceipt() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              color:Colors.white,
              padding: const EdgeInsets.only(left: 20.0),
              child:Column(
                mainAxisAlignment:
                MainAxisAlignment.start,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Gap(cx.height / 66.7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/location.png",
                        scale: cx.responsive(2.5,1.5, 2),
                      ),
                      Container(
                        width:cx.width*0.6,
                        child: NunitoText(
                          textAlign: TextAlign.start,
                          text: cx.read(LKeys.city)+', '+cx.read(LKeys.state),
                          fontWeight: FontWeight.w600,
                          fontSize: cx.height > 800 ? 18 : 14,
                          color: Color(0xFF6F6B6B),
                          textOverflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  Gap(4),

                  Container(
                    width:cx.width*0.7,
                    child: Padding(
                      padding: const EdgeInsets.only(left:1.5),
                      child: InterText(
                        textAlign: TextAlign.start,
                        text: cx.read(LKeys.domeName),
                        fontWeight: FontWeight.w500,
                        fontSize: cx.height > 800 ? 20 : 17,
                        color: Colors.black,

                      ),
                    ),
                  ),
                  Gap(cx.height*0.02),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Color(0xFFF5F7F9),
                              radius: cx.responsive(28,20, 14),
                              child: Icon(
                                Icons.add_circle_outline,
                                color: Color(0xFF629C86),
                                size: cx.responsive(26,20, 16),
                              ),
                            ),
                            Gap(10),
                            Container(
                              child: NunitoText(
                                textAlign: TextAlign.start,
                                text: int.parse(cx.read(LKeys.fieldName))==1?"${cx.read(LKeys.fieldName)} Field":"${cx.read(LKeys.fieldName)} Fields",
                                fontWeight: FontWeight.w500,
                                fontSize: cx.height > 800 ? 16 : 14,
                                color: Color(0xFFA8A8A8),
                                textOverflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                  Gap(7),



                ],
              )
          ),
          TicketWidget(
            color: AppColor.ticketWidget,
            width: MediaQuery.of(context).size.width,
            isCornerRounded: false,
            padding: const EdgeInsets.all(0),
            height: cx.height * 0.85,
            child: Column(
              // shrinkWrap: true,
              // physics: ClampingScrollPhysics(),
              children: [
                Container(
                  height: cx.height * 0.425,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(0xFFF5F7F9),
                                radius: cx.responsive(28,20, 14),
                                child: Icon(
                                  Icons.access_time,
                                  color: Color(0xFF629C86),
                                  size: cx.responsive(26,20, 16),
                                ),
                              ),
                              Gap(10),
                              Container(
                                width: cx.width*0.6,
                                child: NunitoText(
                                  textAlign: TextAlign.start,
                                  textOverflow: TextOverflow.ellipsis,
                                  text: cx.read(LKeys.time),

                                  fontWeight: FontWeight.w500,
                                  fontSize: cx.height > 800 ? 16 : 14,
                                  color: Color(0xFF9F9F9F),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(7),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Color(0xFFF5F7F9),
                                    radius: cx.responsive(28,20, 14),
                                    child: Icon(
                                      Icons.calendar_month,
                                      color: Color(0xFF629C86),
                                      size: cx.responsive(26,20, 16),
                                    ),
                                  ),
                                  Gap(10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: cx.width * 0.6,
                                        child: NunitoText(
                                          textAlign: TextAlign.start,
                                          text: cx.read(LKeys.date),
                                          fontWeight: FontWeight.w700,
                                          fontSize: cx.height > 800 ? 16 : 14,
                                          color: Color(0xFFA8A8A8),
                                          textOverflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Gap(3),

                                      Container(
                                        width: cx.width * 0.6,
                                        child: NunitoText(
                                          textAlign: TextAlign.start,
                                          text: cx.read(LKeys.days),
                                          fontWeight: FontWeight.w700,
                                          fontSize: cx.height > 800 ? 16 : 14,
                                          color: AppColor.darkGreen,
                                          textOverflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Gap(3),

                                      Container(
                                        width: cx.width * 0.6,
                                        child: NunitoText(
                                          textAlign: TextAlign.start,
                                          text:
                                              "Total Games : ${cx.read(LKeys.totalGames)}",
                                          fontWeight: FontWeight.w600,
                                          fontSize: cx.height > 800 ? 16 : 14,
                                          color: Color(0xFF757575),
                                          textOverflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Gap(cx.height / 70),
                          ],
                        ),
                        Gap(7),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Color(0xFFF5F7F9),
                                    radius: cx.responsive(28,20, 14),
                                    child: Icon(
                                      Icons.people_outline,
                                      color: Color(0xFF629C86),
                                      size: cx.responsive(26,20, 16),
                                    ),
                                  ),
                                  Gap(10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      NunitoText(
                                        textAlign: TextAlign.start,
                                        text: "Number Of Players",
                                        fontWeight: FontWeight.w500,
                                        fontSize: cx.height > 800 ? 16 : 14,
                                        color: Color(0xFFA8A8A8),
                                      ),
                                      NunitoText(
                                        textAlign: TextAlign.start,
                                        text: cx.read(LKeys.players).toString(),
                                        fontWeight: FontWeight.w700,
                                        fontSize: cx.height > 800 ? 16 : 15,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Gap(cx.height / 70),
                          ],
                        ),
                        Gap(6),

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Color(0xFFF5F7F9),
                              radius: cx.responsive(28,20, 14),
                              child: Image.asset("assets/images/location.png",
                                  scale: cx.responsive(2.5,1.5, 2),
                                  color: AppColor.darkGreen),
                            ),
                            Gap(10),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 2),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NunitoText(
                                      text: "Address",
                                      fontSize: cx.height > 800 ? 16 : 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.grey),
                                  Container(
                                    width: cx.width * 0.64,
                                    child: NunitoText(
                                        text: cx.read(LKeys.address),
                                        fontSize: cx.height > 800 ? 17 : 15,
                                        textOverflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w700,
                                        maxLines: 4,
                                        color: Color(0xFF414141)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                MySeparator(
                  color: Color.fromRGBO(231, 244, 239, 1),
                ),
                Container(
                  height: cx.height * 0.42,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: cx.height / 33.5, top: 8),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    NunitoText(
                                        text: "Sub Total",
                                        fontSize: cx.responsive(25,20, 17),
                                        fontWeight: FontWeight.w700,
                                        color: AppColor.grey),
                                    Gap(8),
                                    NunitoText(
                                        text: "Service Fee",
                                        fontSize: cx.responsive(25,20, 17),
                                        fontWeight: FontWeight.w700,
                                        color: AppColor.grey),
                                    Gap(8),
                                    Row(
                                      children: [
                                        NunitoText(
                                            text: "HST",
                                            fontSize: cx.responsive(25,20, 17),
                                            fontWeight: FontWeight.w700,
                                            color: AppColor.grey),

                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: cx.responsive(4,3, 2),
                                top: 8,
                              ),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    NunitoText(
                                        textAlign: TextAlign.end,
                                        text: "+ \$" +
                                            cx.read(LKeys.price).toStringAsFixed(2),
                                        fontSize: cx.responsive(25,20, 17),
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF757575)),
                                    Gap(8),
                                    NunitoText(
                                        textAlign: TextAlign.end,
                                        text: "+ \$" +
                                            cx
                                                .read(
                                                  LKeys.serviceFee,
                                                )
                                                .toStringAsFixed(2),
                                        fontSize: cx.responsive(25,20, 17),
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF757575)),
                                    Gap(8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      // crossAxisAlignment:
                                      // CrossAxisAlignment.end,
                                      children: [
                                        NunitoText(
                                            textAlign: TextAlign.end,
                                            text: "+ \$" +
                                                cx
                                                    .read(LKeys.totalHST)
                                                    .toStringAsFixed(2),
                                            fontSize: cx.responsive(25,20, 17),
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
                      Gap(cx.height*0.015),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                        child: const Divider(
                          color: Color(0xFFE7F4EF),
                          thickness: 2,
                        ),
                      ),
                      Gap(cx.height*0.015),
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
                                  fontSize:
                                  cx.responsive(
                                      27,22, 19),
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF757575)),
                            ),
                            SenticText(
                                textAlign: TextAlign.start,
                                text:
                                    " \$" + cx.read(LKeys.total).toStringAsFixed(2),
                                fontSize:
                                cx.responsive(
                                    29,24, 21),
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF07261A)),
                          ],
                        ),
                      ),
                      Gap(cx.height * 0.025),

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
                                  radius: cx.responsive(25,22.5, 20),
                                  backgroundColor: Colors.white,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.image,
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: cx.responsive(25,20, 17),
                                      backgroundImage: NetworkImage(
                                        widget.image,
                                      ),
                                    ),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: cx.responsive(25,20, 17),
                                      backgroundImage: AssetImage(
                                        Image1.anime,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: cx.responsive(25,20, 17),
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
                                    text: widget.email,
                                    fontWeight: FontWeight.w500,
                                    fontSize: cx.responsive(24,18, 16),
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
        ],
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
