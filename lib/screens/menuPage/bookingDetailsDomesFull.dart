import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:domez/commonModule/Constant.dart';
import '../../commonModule/AppColor.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ticket_widget/ticket_widget.dart';
import '../../commonModule/Strings.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../controller/bookingDetailsController.dart';
import '../../controller/commonController.dart';
import '../../main_page.dart';
import '../../model/bookingDetailsModel.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/mySeperator.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/search/simplecircularIcon.dart';

class BookingDetailsDomesFull extends StatefulWidget {
  bool? linkAccess;
  BookingDetailsDomesFull({Key? key,required this.linkAccess}) : super(key: key);

  @override
  State<BookingDetailsDomesFull> createState() =>
      _BookingDetailsDomesFullState();
}

class _BookingDetailsDomesFullState extends State<BookingDetailsDomesFull> {
  CommonController cx = Get.put(CommonController());
  BookingDetailsController mycontroller = Get.put(BookingDetailsController());
  bool fav = false;
  bool emailCorrect = false;
  TextEditingController bottomEmailController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> bottomEmailKey = GlobalKey<FormState>();

  TextEditingController controller = TextEditingController(text: "");
  String thisText = "";
  bool hasError = false;
  bool isconfirm = true;
  bool isprocessing = false;
  bool isuccessful = false;
  bool isfailed = false;

  Map<String, dynamic>? paymentIntent;

  bool isCancelTimerAvailable = true;

  Timer? countdownTimer;
  Duration myDuration = Duration(hours: 1, minutes: 59, seconds: 60);

  DateTime todayTime = DateTime.now();

  DateTime currentTime = DateTime.now();
  DateTime bookingTime = DateTime.now();

  String timeRemaining = '';
  String startTime = '';
  Duration dur = Duration(days: 0);
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
  DateTime bookingCreatedTime = DateTime.now();

  bool isDefaultTime = true;
  late BookingDetailsModel item;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    item = mycontroller.myList[0];
    bookingCreatedTime = item.bookingCreatedAt;

    setState(() {
      print("Timing Details");
      print(item.startDate);
      print(item.time.substring(0, 2));


      startTime = item.time.substring(0, 2);
      print(startTime);
      print(item.time.substring(6, 8));
      if (item.time.substring(6, 8) == "PM") {
        print("startTime1");
        print(startTime);

        if (item.time.substring(0, 2) != "12") {
          startTime = (int.parse(startTime) + 12).toString();
        }
      } else {
        print(startTime);

        if (item.time.substring(0, 2) == "12") {
          startTime = "00";
        }
      }
      print("startTime2");
      print(startTime);
      print(item.startDate);

      timeRemaining = item.startDate + ' ' + startTime + ":${item.time.substring(3,5)}:00";

      print(timeRemaining);
      bookingTime = DateTime.parse(timeRemaining);
      print(bookingTime);

      print(bookingTime.subtract(Duration(hours: 4)));
      print(bookingCreatedTime.toLocal());

      print("Default Time?");
      print(bookingTime.subtract(Duration(hours: 4)).millisecondsSinceEpoch);
      print(bookingCreatedTime.toLocal().millisecondsSinceEpoch);

      if (currentTime.difference(bookingCreatedTime.toLocal()).inHours < 2) {
        isCancelTimerAvailable = true;
        if (bookingTime.subtract(Duration(hours: 4)).millisecondsSinceEpoch <=
            bookingCreatedTime.toLocal().millisecondsSinceEpoch) {
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
          print("currentTime=>" + currentTime.toString());
          print("bookingCreatedTimeUTC=>" + bookingCreatedTime.toString());
          print("bookingCreatedTimeLocal=>" +
              bookingCreatedTime.toLocal().toString());

          myDuration = currentTime.difference(bookingCreatedTime.toLocal());
          print("myDuration1");
          print(myDuration);

          myDuration = calDuration - myDuration;
          print("myDuration2");

          print(myDuration);
          print(calDuration);

          isDefaultTime = true;
          startTimer1();
          print(myDuration.inHours);
          print(myDuration.inMinutes);
          print(myDuration.inSeconds);
        }
      } else {
        print("Booking before 2 hours");
        dur = Duration(days: 0);
        myDuration = Duration(days: 0);
      }
      if (item.bookingStatus == "Cancelled") {
        isCancelTimerAvailable = false;
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
    if (DateTime.now().millisecondsSinceEpoch >=
        bookingTime.subtract(Duration(hours: 2)).millisecondsSinceEpoch) {
      isCancelTimerAvailable = false;
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColor.bg,
      body: Container(
        decoration: BoxDecoration(
          color: AppColor.bg,
        ),
        child: Obx(
          () => mycontroller.isDataProcessing.value
              ? Container(
                  height: cx.height,
                  // height: 200,
                  color: AppColor.bg,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColor.darkGreen,
                    ),
                  ),
                )
              : ListView(
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
                                    : cx.responsive(cx.height * 1.15, cx.height * 1.2, cx.height * 1.25),
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
                                    Positioned(
                                      left: cx.responsive(50,38, 28),
                                      top: cx.responsive(33,25, 20),
                                      child: InkWell(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 22,
                                          child: SimpleCircularIconButton(
                                            iconData: Icons.arrow_back_ios_new,
                                            iconColor: Colors.black,
                                            radius: cx.responsive(50,42, 37),
                                          ),
                                        ),
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
                                                              cx.height /
                                                                  44.47)),
                                                  child: ListTile(
                                                    dense: true,
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            20,
                                                            cx.height / 100,
                                                            cx.height / 44.47,
                                                            0),
                                                    title: Container(
                                                      width: cx.width * 0.55,
                                                      child: SenticText(
                                                        text: item.domeName,
                                                        fontSize:
                                                            cx.height > 800
                                                                ? 24
                                                                : 21,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xFF222222),
                                                        textOverflow:
                                                            TextOverflow
                                                                .ellipsis,
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
                                                              color: mycontroller
                                                                      .myList[0]
                                                                      .bookingStatus
                                                                      .isEmpty
                                                                  ? AppColor
                                                                      .darkGreen
                                                                  : Color(
                                                                      0xFfF04257))),
                                                      padding: mycontroller
                                                              .myList[0]
                                                              .bookingStatus
                                                              .isEmpty
                                                          ? EdgeInsets.fromLTRB(
                                                              10, 5, 10, 5)
                                                          : EdgeInsets.fromLTRB(
                                                              10, 5, 10, 5),
                                                      child: SenticText(
                                                        textAlign:
                                                            TextAlign.center,
                                                        text: mycontroller
                                                                .myList[0]
                                                                .bookingStatus
                                                                .isEmpty
                                                            ? mycontroller
                                                                .myList[0]
                                                                .paymentStatus
                                                                .toString()
                                                            : mycontroller
                                                                .myList[0]
                                                                .bookingStatus
                                                                .toString(),
                                                        fontSize:
                                                            cx.height > 800
                                                                ? 17
                                                                : 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: mycontroller
                                                                .myList[0]
                                                                .bookingStatus
                                                                .isEmpty
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
                                              ? Column(
                                                  children: [
                                                    Container(
                                                      height: mycontroller
                                                              .myList[0]
                                                              .bookingStatus
                                                              .isEmpty
                                                          ? cx.height / 9
                                                          : cx.height / 50,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      cx.height /
                                                                          37.06),
                                                              bottomRight: Radius
                                                                  .circular(cx
                                                                          .height /
                                                                      37.06))),
                                                      child: Column(
                                                        children: [
                                                          Gap(6),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(20.0,
                                                                    0, 20, 0),
                                                            child:
                                                                const Divider(
                                                              color: Color(
                                                                  0xFFE7F4EF),
                                                              thickness: 2,
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () async {
                                                              onCancelAlert(
                                                                  context:
                                                                      context,
                                                                  bookingId: item
                                                                      .id
                                                                      .toString(),
                                                                  onCancel: () {
                                                                    Get.back();
                                                                    cancelAccount(
                                                                            context:
                                                                                context,
                                                                            bookingId: item.id
                                                                                .toString())
                                                                        .then(
                                                                            (value) {
                                                                      setState(
                                                                          () {
                                                                        item.bookingStatus =
                                                                            "Cancelled";
                                                                        isCancelTimerAvailable =
                                                                            false;
                                                                      });
                                                                      // mycontroller.setBid();
                                                                    });
                                                                    stopTimer();
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
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: cx
                                                                      .responsive(
                                                                    25,
                                                                          21,
                                                                          18),
                                                                ),
                                                                Gap(7),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Gap(cx.height / 40),
                                                  ],
                                                )
                                              : Container(),
                                          !isCancelTimerAvailable
                                              ? Container(
                                                  height: cx.height / 45,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  cx.height /
                                                                      37.06),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  cx.height /
                                                                      37.06))),
                                                  // child: Gap(15),
                                                )
                                              : Container(),
                                          Gap(cx.height / 15),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        Positioned(
                          top: cx.height / 6.06,
                          right: 2,
                          left: 4,
                          child: isCancelTimerAvailable
                              ? timerBox(isDefaultTime,
                                  hours: hours,
                                  minutes: minutes,
                                  seconds: seconds,
                                  hours1: hours1,
                                  minutes1: minutes1,
                                  seconds1: seconds1,
                                  timerMessage:"You can cancel this booking within the given time",
                                  paymentLink:mycontroller.myList[0].paymentLink)
                              : Padding(
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
                                                    children: [
                                                      Container(
                                                        width: cx.width * 0.55,
                                                        child: SenticText(
                                                          text: item.domeName,
                                                          fontSize:
                                                              cx.height > 800
                                                                  ? 24
                                                                  : 21,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Color(0xFF222222),
                                                          textOverflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  trailing: Container(
                                                    // width: cx.width*0.2,
                                                    decoration: BoxDecoration(
                                                        // color:Color(0xFFF8C8C8),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        border: Border.all(
                                                            color: mycontroller
                                                                    .myList[0]
                                                                    .bookingStatus
                                                                    .isEmpty
                                                                ? AppColor
                                                                    .darkGreen
                                                                : Color(
                                                                    0xFfF04257))),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            13, 5, 13, 5),
                                                    child: Obx(
                                                      () => SenticText(
                                                        textAlign:
                                                            TextAlign.center,
                                                        text: mycontroller
                                                                .myList[0]
                                                                .bookingStatus
                                                                .isEmpty
                                                            ? mycontroller
                                                                .myList[0]
                                                                .paymentStatus
                                                                .toString()
                                                            : mycontroller
                                                                .myList[0]
                                                                .bookingStatus
                                                                .toString(),
                                                        fontSize:
                                                            cx.height > 800
                                                                ? 17
                                                                : 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: mycontroller
                                                                .myList[0]
                                                                .bookingStatus
                                                                .isEmpty
                                                            ? AppColor.darkGreen
                                                            : Color(0xFFFF5C5C),
                                                        // textOverflow: TextOverflow.ellipsis,
                                                      ),
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
                                              ? cx.height / 7
                                              : cx.height / 15,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                      cx.height / 37.06),
                                                  bottomRight: Radius.circular(
                                                      cx.height / 37.06))),
                                          child: Column(
                                            children: [
                                              Gap(6),
                                              isCancelTimerAvailable
                                                  ? Column(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(20.0, 0,
                                                                  20, 0),
                                                          child: const Divider(
                                                            color: Color(
                                                                0xFFE7F4EF),
                                                            thickness: 2,
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () async {
                                                            onCancelAlert(
                                                                context:
                                                                    context,
                                                                bookingId: item
                                                                    .id
                                                                    .toString(),
                                                                onCancel: () {
                                                                  Get.back();
                                                                  cancelAccount(
                                                                          context:
                                                                              context,
                                                                          bookingId: item
                                                                              .id
                                                                              .toString())
                                                                      .then(
                                                                          (value) {
                                                                    setState(
                                                                        () {
                                                                      item.bookingStatus =
                                                                          "Cancelled";
                                                                      isCancelTimerAvailable =
                                                                          false;
                                                                    });
                                                                    // mycontroller.setBid();
                                                                  });
                                                                  stopTimer();
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
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: cx
                                                                    .responsive(
                                                                        25,21, 18),
                                                              ),
                                                              Gap(7),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
                                  fontSize: cx.height > 800
                                      ? 18
                                      : 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.grey),
                              Container(
                                width: cx.width * 0.345,
                                child: NunitoText(
                                  text: item.field.toString(),
                                  fontSize: cx.height > 800 ? 20 : 17,
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
                                  fontSize: cx.height > 800
                                      ? 18
                                      : 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.grey),
                              NunitoText(
                                  text: item.players.toString(),
                                  fontSize: cx.height > 800 ? 20 : 17,
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
                                  fontSize: cx.height > 800
                                      ? 18
                                      : 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.grey),
                              NunitoText(
                                  text: item.date,
                                  fontSize: cx.height > 800 ? 20 : 17,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF414141)),
                              const SizedBox(
                                width: 40,
                              ),
                              NunitoText(
                                  text: "Time",
                                  fontSize: cx.height > 800
                                      ? 18
                                      : 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.grey),
                              NunitoText(
                                  text: item.time,
                                  fontSize: cx.height > 800 ? 20 : 17,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF414141)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: cx.height / 44.47,right: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NunitoText(
                            text: "Address",
                            fontSize: cx.height > 800
                                ? 18
                                : 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.grey),
                        NunitoText(
                            text: item.address,
                            fontSize: cx.height > 800 ? 20 : 17,
                            maxLines: cx.height > 800 ? 3 : 2,
                            textOverflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF414141)),
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
                                  fontSize: cx.responsive(28,22, 18),
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.grey),
                              Gap(6),
                              NunitoText(
                                  text: "Service Fee",
                                  fontSize: cx.responsive(28,22, 18),
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.grey),
                              Gap(6),
                              Row(
                                children: [
                                  NunitoText(
                                      text: "HST  ",
                                      fontSize: cx.responsive(28,22, 18),
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.grey),

                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: cx.responsive(5,3, 2),
                            top: cx.responsive(14,10, 7),
                          ),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                NunitoText(
                                    textAlign: TextAlign.end,
                                    text:
                                        "\$" + item.subTotal.toStringAsFixed(2),
                                    fontSize: cx.responsive(28,22, 18),
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF757575)),
                                Gap(4),
                                NunitoText(
                                    textAlign: TextAlign.end,
                                    text: "+ \$" +
                                        item.serviceFee.toStringAsFixed(2),
                                    fontSize: cx.responsive(28,22, 18),
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF757575)),
                                Gap(4),
                                NunitoText(
                                    textAlign: TextAlign.end,
                                    text: "+ \$" + item.hst.toStringAsFixed(2),
                                    fontSize: cx.responsive(28,22, 18),
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF757575)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(cx.height * 0.01),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                    child: const Divider(
                      color: Color(0xFFE7F4EF),
                      thickness: 2,
                    ),
                  ),
                  Gap(cx.height * 0.015),
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
                            text: " \$" + item.totalAmount.toStringAsFixed(2),
                            fontSize:
                            cx.responsive(
                                29,24, 21),
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF07261A)),
                      ],
                    ),
                  ),
                  Gap(cx.height * 0.02),
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
                                imageUrl: cx.read("image"),
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: cx.responsive(25,20, 17),
                                  backgroundImage: NetworkImage(
                                    cx.read("image"),
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
                                text: item.userInfo.email,
                                fontWeight: FontWeight.w500,
                                fontSize: cx.responsive(22,18, 16),
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

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }
}
