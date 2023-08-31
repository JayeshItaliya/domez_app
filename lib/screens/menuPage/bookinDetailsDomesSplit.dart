import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../commonModule/AppColor.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ticket_widget/ticket_widget.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/Strings.dart';
import '../../controller/bookingDetailsController.dart';
import '../../controller/commonController.dart';
import '../../main_page.dart';
import '../../model/bookingDetailsModel.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/mySeperator.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/search/simplecircularIcon.dart';
import '../../commonModule/widget/common/textSentic.dart';
import 'package:http/http.dart' as http;
import '../../commonModule/utils.dart';

class BookingDetailsDomesSplit extends StatefulWidget {
  final bool isActive;
  final bool linkAccess;

  BookingDetailsDomesSplit(
      {Key? key, required this.isActive, this.linkAccess = false})
      : super(key: key);
  @override
  State<BookingDetailsDomesSplit> createState() =>
      _BookingDetailsDomesSplitState();
}

class _BookingDetailsDomesSplitState extends State<BookingDetailsDomesSplit> {
  CommonController cx = Get.put(CommonController());
  bool isexpanded = false;
  TextEditingController controller = TextEditingController(text: "");
  BookingDetailsController mycontroller = Get.put(BookingDetailsController());
  TextEditingController bottomNameController = TextEditingController();
  TextEditingController bottomMoneyController = TextEditingController();
  final GlobalKey<FormState> linkAccessKey = GlobalKey<FormState>();
  DateTime torontoCurTime = DateTime.now();

  String thisText = "";
  int pinLength = 4;
  bool hasError = false;
  bool isconfirm = false;
  bool amountCorrect = false;
  bool isPaymentAPICalling = false;
  List<int> errorDomeImage = [];

  bool isprocessing = false;
  bool isuccessful = false;
  bool isfailed = true;
  Timer? countdownTimer;
  Duration myDuration = Duration(days: 0);
  DateTime bookingCreatedTime = DateTime.now();
  DateTime bookingTimeAPI = DateTime.now();
  DateTime bookingEndTimeAPI = DateTime.now();
  String timeRemaining = '';
  String getEndTime = '';
  Duration dur = Duration(days: 0);
  Map<String, dynamic>? paymentIntent;

  // Duration calDuration = Duration(hours: 23, minutes: 59, seconds: 60);
  Duration calDuration = Duration(hours: 1, minutes: 59, seconds: 60);

  int remainingHours = 0;
  int remainingMinutes = 0;
  int remainingSeconds = 0;
  bool isDataProcesssing = false;

  String hours = '';
  String minutes = '';
  String seconds = '';

  String hours1 = '';
  String minutes1 = '';
  String seconds1 = '';

  bool isDefaultTime = true;
  bool isCancelButtonAvailable = true;
  bool isTimerAvailable = true;
  String startTime = '';
  String endTime = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String site = "";
  String? _linkMessage;
  bool _isCreatingLink = false;
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  double minimumAmount=0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("link access fetching ...");
    print(linkAccess);

    BookingDetailsModel item = mycontroller.myList[0];


    _createDynamicLink(true, "/domeBooking", item.id.toString());
    torontoCurTime = item.currentTime;
    if (item.dueAmount > 0 &&
        ((item.players - item.otherContributors.length) > 0)) {
      amountCorrect = true;
      bottomMoneyController.text =
          (item.dueAmount / (item.players - item.otherContributors.length))
              .toStringAsFixed(2);
      minimumAmount=double.parse((item.dueAmount / (item.players - item.otherContributors.length))
          .toStringAsFixed(2));

      print("Ahmed");
      print(minimumAmount);
      print(item.dueAmount);
      print(item.players);
      print(item.otherContributors.length);
    } else {
      amountCorrect = true;
      bottomMoneyController.text = item.dueAmount.toStringAsFixed(2);
    }


    bookingCreatedTime = item.bookingCreatedAt;

    // var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(bookingCreatedTime.toString(), true);
    // var dateLocal = dateTime;
    // print("dateLocal"+dateLocal.toString());

    startTime = item.time.substring(0, 2);
    if (item.time.substring(6, 8) == "PM") {
      print("startTime1");
      if (item.time.substring(0, 2) != "12") {
        startTime = (int.parse(startTime) + 12).toString();
      }
    } else {
      if (item.time.substring(0, 2) == "12") {
        startTime = "00";
      }
    }
    print(startTime);

    endTime = item.time.substring(12, 14);
    if (item.time.substring(18, 20) == "PM") {
      print("endTime1");
      if (item.time.substring(12, 14) != "12") {
        endTime = (int.parse(endTime) + 12).toString();
      }
    } else {
      if (item.time.substring(12, 14) == "12") {
        endTime = "00";
      }
    }

    print(endTime);
    getEndTime =
        item.startDate + ' ' + endTime + ":${item.time.substring(15, 17)}:00";
    bookingEndTimeAPI = DateTime.parse(getEndTime);
    print("bookingEndTimeAPI");
    print(bookingEndTimeAPI);

    print(item.startDate.toString());
    print("item.startDate.toString()");
    timeRemaining =
        item.startDate + ' ' + startTime + ":${item.time.substring(3, 5)}:00";
    print(timeRemaining);

    bookingTimeAPI = DateTime.parse(timeRemaining);

    String bookingCreateFullDate =
        DateFormat("yyyy-MM-dd").format(bookingCreatedTime);
    String bookingCreateFullTime = DateFormat.Hms().format(bookingCreatedTime);

    String bookingCurDate = DateFormat("yyyy-MM-dd").format(torontoCurTime);
    String bookingCurTime = DateFormat.Hms().format(torontoCurTime);
    String bookingDate = DateFormat("yyyy-MM-dd").format(bookingTimeAPI);
    String bookingTime = DateFormat.Hms().format(bookingTimeAPI);

    print("bookingTimeAPI");
    print(bookingTimeAPI);

    print(bookingCreateFullDate);
    print(bookingCreateFullTime);
    print(bookingCurDate);
    print(bookingCurTime);
    print(bookingDate);
    print(bookingTime);

    print(bookingCreatedTime.add(Duration(hours: 2)));
    print(bookingCreatedTime);
    print(bookingTimeAPI);
    print("Timing condition");
    if (bookingCreatedTime.add(Duration(hours: 2)).millisecondsSinceEpoch >=
        bookingTimeAPI.millisecondsSinceEpoch) {
      print(bookingTimeAPI);
      print(torontoCurTime);
      dur = bookingTimeAPI.difference(torontoCurTime);

      print("Duration");
      print(dur);

      print("Difference");
      print(dur.inHours);
      print(dur.inMinutes);
      print(dur.inSeconds);

      startTimer();
      isDefaultTime = false;
    } else {
      print("Time is bigger");
      isDefaultTime = true;
      print("torontoCurTime=>" + torontoCurTime.toString());
      print("bookingCreatedTimeUTC=>" + bookingCreatedTime.toString());
      print("bookingCreatedTimeLocal=>" + bookingCreatedTime.toString());

      myDuration = torontoCurTime.difference(bookingCreatedTime);
      print("myDuration1");

      print(myDuration);

      myDuration = calDuration - myDuration;
      print("myDuration2");

      print(myDuration);
      print(calDuration);

      startTimer1();
    }

    // if (bookingCreatedTime
    //
    //         .add(Duration(days: 1))
    //         .millisecondsSinceEpoch >=
    //     bookingTimeAPI.millisecondsSinceEpoch) {
    //   print(bookingTimeAPI);
    //   print(currentTime);
    //   dur = bookingTimeAPI.difference(currentTime);
    //
    //   print("Duration");
    //   print(dur);
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
    //   print("currentTime=>" + currentTime.toString());
    //   print("bookingCreatedTimeUTC=>" + bookingCreatedTime.toString());
    //   print("bookingCreatedTimeLocal=>" +
    //       bookingCreatedTime.toString());
    //
    //   myDuration = currentTime.difference(bookingCreatedTime);
    //   print("myDuration1");
    //
    //   print(myDuration);
    //
    //   myDuration = calDuration - myDuration;
    //   print("myDuration2");
    //
    //   print(myDuration);
    //   print(calDuration);
    //
    //   startTimer1();
    // }
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

    // print(hours);
    // print(minutes);
    // print(seconds);
    // print("myDuration");
    // print(hours1);
    // print(minutes1);
    // print(seconds1);

    if (isDefaultTime) {
      if (int.parse(hours1) <= 0 &&
          int.parse(minutes1) <= 0 &&
          int.parse(seconds1) <= 0) {
        print("Timer Over");
        if (mycontroller.myList[0].paymentStatus == "In Progress") {
          mycontroller.myList[0].bookingStatus = "Cancelled";
          isCancelButtonAvailable = false;
        }
      }
    } else {
      if (int.parse(hours) <= 0 &&
          int.parse(minutes) <= 0 &&
          int.parse(seconds) <= 0) {
        print("Timer Over");
        if (mycontroller.myList[0].paymentStatus == "In Progress") {
          mycontroller.myList[0].bookingStatus = "Cancelled";
          isCancelButtonAvailable = false;
        }
      }
    }

    //---2 Hours Before Booking Time
    if (torontoCurTime
            .add(Duration(hours: 1, minutes: 23))
            .millisecondsSinceEpoch >=
        bookingTimeAPI.subtract(Duration(hours: 2)).millisecondsSinceEpoch) {
      if (mycontroller.myList[0].paymentStatus == "In Progress") {
        isCancelButtonAvailable = false;
      }
    }
    //---Booking Time Crossed
    if (torontoCurTime.millisecondsSinceEpoch >=
        bookingTimeAPI.millisecondsSinceEpoch) {
      if (mycontroller.myList[0].paymentStatus == "In Progress") {
        isCancelButtonAvailable = false;
        mycontroller.myList[0].bookingStatus = "Cancelled";
      }
    }
    //-----Cancelled or Paid-----
    if (mycontroller.myList[0].bookingStatus == "Cancelled" ||
        (mycontroller.myList[0].bookingStatus.isEmpty &&
            mycontroller.myList[0].paymentStatus == "Paid")) {
      if (mycontroller.myList[0].paymentStatus == "In Progress") {
        isCancelButtonAvailable = false;
      }
      // myDuration = Duration(days:0);
      // dur = Duration(days:0);

      stopTimer();
    }

    return WillPopScope(
      onWillPop: () async {
        Get.offAll(MainPageScreen());
        return false;
      },
      child: Form(
        key: linkAccessKey,
        child: Scaffold(
            key: _scaffoldKey,
            extendBodyBehindAppBar: true,
            backgroundColor: AppColor.bg,
            body: GestureDetector(
              onTap: (){
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Container(
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
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          children: [
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    Center(
                                      child: SizedBox(
                                        width: cx.width * 0.9,
                                        height: mycontroller.myList[0]
                                                    .bookingStatus.isEmpty &&
                                                mycontroller
                                                        .myList[0].paymentStatus
                                                        .toString() ==
                                                    "In Progress"
                                            ? cx.height * 0.485
                                            : isexpanded
                                                ? cx.responsive(
                                                      cx.height * 0.75,
                                                      cx.height * 0.8,
                                                      cx.height * 0.85,
                                                    ) +
                                                    (mycontroller
                                                            .myList[0]
                                                            .otherContributors
                                                            .length *
                                                        (cx.height / 9.5))
                                                : cx.responsive(
                                                      cx.height * 0.85,
                                                      cx.height * 0.93,
                                                      cx.height * 1.05,
                                                    ) +
                                                    45 +
                                                    (mycontroller
                                                            .myList[0]
                                                            .otherContributors
                                                            .length *
                                                        (cx.height / 9.5)),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              decoration: errorDomeImage.contains(
                                                      cx.read(Keys.domeId))
                                                  ? BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      gradient:
                                                          backShadowContainer(),
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                          Image1.domesAround,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ))
                                                  : BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .all(Radius.circular(
                                                              cx.height / 26.68)),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          mycontroller.myList[0]
                                                                  .image.isEmpty
                                                              ? "https://thumbs.dreamstime.com/b/indoor-stadium-view-behind-wicket-cricket-160851985.jpg"
                                                              : mycontroller
                                                                  .myList[0]
                                                                  .image,
                                                          scale: cx.height > 800
                                                              ? 1.8
                                                              : 2.4,
                                                        ),
                                                        fit: BoxFit.cover,
                                                        onError: (Object e,
                                                            StackTrace?
                                                                stackTrace) {
                                                          setState(() {
                                                            errorDomeImage.add(
                                                                cx.read(
                                                                    Keys.domeId));
                                                          });
                                                        },
                                                      )),
                                              margin: EdgeInsets.only(
                                                  left: 8, right: 8, top: 8),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: cx.height / 4.3,
                                            ),
                                            Positioned(
                                              left: cx.responsive(60, 38, 28),
                                              top: cx.responsive(35, 25, 20),
                                              child: InkWell(
                                                onTap: () {
                                                  if (widget.linkAccess) {
                                                    Get.offAll(MainPageScreen());
                                                    cx.curIndex.value = 0;
                                                  } else {
                                                    Get.back();
                                                  }
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 22,
                                                  child: SimpleCircularIconButton(
                                                    iconData:
                                                        Icons.arrow_back_ios_new,
                                                    iconColor: Colors.black,
                                                    radius:
                                                        cx.responsive(50, 42, 37),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    mycontroller.myList[0].bookingStatus
                                                .isEmpty &&
                                            mycontroller.myList[0].paymentStatus
                                                    .toString() ==
                                                "In Progress"
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                top: 0,
                                                left: cx.width * 0.09,
                                                right: cx.width * 0.09,
                                                bottom: 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: AppColor.bg,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          cx.height / 44.47)),
                                              child: Column(
                                                children: [
                                                  // widget.linkAccess==true?
                                                  // linkAccess():
                                                  // Container(),
                                                  widget.linkAccess
                                                      ? Container(
                                                          height: cx.height * 0.4)
                                                      : Container(),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius
                                                            .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        cx.height /
                                                                            37.06),
                                                                topRight: Radius
                                                                    .circular(cx
                                                                            .height /
                                                                        37.06))),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Color.fromRGBO(
                                                                      241,
                                                                      247,
                                                                      236,
                                                                      0.6),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(cx
                                                                              .height /
                                                                          44.47)),
                                                          child: ListTile(
                                                            dense: true,
                                                            contentPadding:
                                                                EdgeInsets.fromLTRB(
                                                                    20,
                                                                    cx.height /
                                                                        100,
                                                                    cx.height /
                                                                        44.47,
                                                                    0),
                                                            title: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  // width:cx.width*0.15,
                                                                  decoration: BoxDecoration(
                                                                      color: mycontroller.myList[0].bookingStatus.isNotEmpty || mycontroller.myList[0].paymentStatus.toString() == "Paid" ? Colors.transparent : Color(0xFFFDF5D2),
                                                                      borderRadius: BorderRadius.circular(30),
                                                                      border: Border.all(
                                                                          width: 1,
                                                                          color: mycontroller.myList[0].bookingStatus.isEmpty
                                                                              ? mycontroller.myList[0].paymentStatus.toString() == "In Progress"
                                                                                  ? Color(0xFFE1DAB4)
                                                                                  : AppColor.lightGreen
                                                                              : Color(0xFFF04257))),

                                                                  child: Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      10,
                                                                      4,
                                                                    ),
                                                                    child:
                                                                        InterText(
                                                                      text: mycontroller
                                                                              .myList[
                                                                                  0]
                                                                              .bookingStatus
                                                                              .isEmpty
                                                                          ? mycontroller
                                                                              .myList[
                                                                                  0]
                                                                              .paymentStatus
                                                                              .toString()
                                                                          : mycontroller
                                                                              .myList[0]
                                                                              .bookingStatus
                                                                              .toString(),
                                                                      color: mycontroller
                                                                              .myList[
                                                                                  0]
                                                                              .bookingStatus
                                                                              .isEmpty
                                                                          ? mycontroller.myList[0].paymentStatus.toString() ==
                                                                                  "In Progress"
                                                                              ? Color(
                                                                                  0XFFA19A6F)
                                                                              : AppColor
                                                                                  .darkGreen
                                                                          : Color(
                                                                              0xFFFF5C5C),
                                                                      fontSize: cx
                                                                          .responsive(
                                                                              20,
                                                                              15,
                                                                              12),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      height: 1.7,
                                                                    ),
                                                                  ),
                                                                  // alignment: Alignment.center,
                                                                ),
                                                                Gap(8),
                                                                SenticText(
                                                                  text: mycontroller
                                                                      .myList[0]
                                                                      .domeName,
                                                                  fontSize:
                                                                      cx.height >
                                                                              800
                                                                          ? 21
                                                                          : 19,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Color(
                                                                      0xFF222222),
                                                                ),
                                                                Gap(4),
                                                              ],
                                                            ),
                                                            trailing: InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  isexpanded =
                                                                      !isexpanded;
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
                                                                  color: AppColor
                                                                      .darkGreen),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  splitTicket(),
                                                  isCancelButtonAvailable
                                                      ? !widget.linkAccess
                                                          ? Column(
                                                              children: [
                                                                Container(
                                                                  height: mycontroller
                                                                              .myList[
                                                                                  0]
                                                                              .bookingStatus
                                                                              .isEmpty &&
                                                                          mycontroller.myList[0].paymentStatus.toString() ==
                                                                              "In Progress"
                                                                      ? cx.height /
                                                                          9
                                                                      : cx.height /
                                                                          50,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius: BorderRadius.only(
                                                                          bottomLeft:
                                                                              Radius.circular(cx.height /
                                                                                  37.06),
                                                                          bottomRight:
                                                                              Radius.circular(cx.height /
                                                                                  37.06))),
                                                                  child: Column(
                                                                    children: [
                                                                      Gap(6),
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
                                                                            () {
                                                                          onCancelAlert(
                                                                              context:
                                                                                  context,
                                                                              bookingId:
                                                                                  mycontroller.myList[0].id.toString(),
                                                                              onCancel: () {
                                                                                Get.back();
                                                                                cancelAccount(context: context, bookingId: mycontroller.myList[0].id.toString()).then((value) {
                                                                                  if (value == 1) {
                                                                                    setState(() {
                                                                                      mycontroller.myList[0].bookingStatus = "Cancelled";
                                                                                      isCancelButtonAvailable = false;
                                                                                    });
                                                                                  }
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
                                                                              fontSize: cx.responsive(
                                                                                  26,
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
                                                                Gap(cx.height /
                                                                    40),
                                                              ],
                                                            )
                                                          : Container(
                                                              height:
                                                                  cx.height / 45,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius: BorderRadius.only(
                                                                      bottomLeft: Radius.circular(
                                                                          cx.height /
                                                                              37.06),
                                                                      bottomRight:
                                                                          Radius.circular(cx.height /
                                                                              37.06))),
                                                              // child: Gap(15),
                                                            )
                                                      : Container(),
                                                  !isCancelButtonAvailable
                                                      ? Container(
                                                          height: cx.height / 45,
                                                          decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(cx
                                                                              .height /
                                                                          37.06),
                                                                  bottomRight: Radius
                                                                      .circular(cx
                                                                              .height /
                                                                          37.06))),
                                                          // child: Gap(15),
                                                        )
                                                      : Container(),
                                                  Gap(cx.height / 15),

                                                  widget.linkAccess
                                                      ? Container(
                                                          height:
                                                              cx.height * 0.15)
                                                      : Container(),
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
                                  child: mycontroller
                                              .myList[0].bookingStatus.isEmpty &&
                                          mycontroller
                                                  .myList[0].paymentStatus
                                                  .toString() ==
                                              "In Progress"
                                      ? !widget.linkAccess
                                          ? timerBox(
                                              isDefaultTime,
                                              hours: hours,
                                              minutes: minutes,
                                              seconds: seconds,
                                              hours1: hours1,
                                              minutes1: minutes1,
                                              seconds1: seconds1,
                                              timerMessage:
                                                  "Share The Link To Split Amount Within The Given Time",
                                              paymentLink: _linkMessage)
                                          : linkAccess()
                                      : Padding(
                                          padding: EdgeInsets.only(
                                              top: 0,
                                              left: cx.width * 0.09,
                                              right: cx.width * 0.09,
                                              bottom: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: AppColor.bg,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        cx.height / 44.47)),
                                            child: Column(
                                              children: [
                                                // linkAccess(),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(
                                                              cx.height / 37.06),
                                                          topRight:
                                                              Radius.circular(
                                                                  cx.height /
                                                                      37.06),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  cx.height /
                                                                      37.06),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  cx.height /
                                                                      37.06))),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Color.fromRGBO(
                                                                241,
                                                                247,
                                                                236,
                                                                0.6),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        cx.height /
                                                                            44.47)),
                                                        child: ListTile(
                                                          dense: true,
                                                          contentPadding:
                                                              EdgeInsets.fromLTRB(
                                                                  20,
                                                                  cx.height / 100,
                                                                  cx.height /
                                                                      44.47,
                                                                  0),
                                                          title: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                // width:cx.width*0.15,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: mycontroller.myList[0].bookingStatus.isNotEmpty ||
                                                                                mycontroller.myList[0].paymentStatus.toString() ==
                                                                                    "Paid"
                                                                            ? Colors
                                                                                .transparent
                                                                            : Color(
                                                                                0xFFFDF5D2),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                30),
                                                                        border: Border.all(
                                                                            width: 1,
                                                                            color: mycontroller.myList[0].bookingStatus.isEmpty
                                                                                ? mycontroller.myList[0].paymentStatus.toString() == "In Progress"
                                                                                    ? Color(0xFFE1DAB4)
                                                                                    : AppColor.lightGreen
                                                                                : Color(0xFFF04257))),

                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                    10,
                                                                    0,
                                                                    10,
                                                                    4,
                                                                  ),
                                                                  child:
                                                                      InterText(
                                                                    text: mycontroller
                                                                            .myList[
                                                                                0]
                                                                            .bookingStatus
                                                                            .isEmpty
                                                                        ? mycontroller
                                                                            .myList[
                                                                                0]
                                                                            .paymentStatus
                                                                            .toString()
                                                                        : mycontroller
                                                                            .myList[
                                                                                0]
                                                                            .bookingStatus
                                                                            .toString(),
                                                                    color: mycontroller
                                                                            .myList[
                                                                                0]
                                                                            .bookingStatus
                                                                            .isEmpty
                                                                        ? mycontroller.myList[0].paymentStatus.toString() ==
                                                                                "In Progress"
                                                                            ? Color(
                                                                                0XFFA19A6F)
                                                                            : AppColor
                                                                                .darkGreen
                                                                        : Color(
                                                                            0xFFFF5C5C),
                                                                    fontSize: cx
                                                                        .responsive(
                                                                            20,
                                                                            15,
                                                                            12),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    height: 1.7,
                                                                  ),
                                                                ),
                                                                // alignment: Alignment.center,
                                                              ),
                                                              Gap(8),
                                                              SenticText(
                                                                text: mycontroller
                                                                    .myList[0]
                                                                    .domeName,
                                                                fontSize:
                                                                    cx.height >
                                                                            800
                                                                        ? 21
                                                                        : 19,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color(
                                                                    0xFF222222),
                                                              ),
                                                              Gap(4),
                                                            ],
                                                          ),
                                                          trailing: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                isexpanded =
                                                                    !isexpanded;
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
                                                                color: AppColor
                                                                    .darkGreen),
                                                          ),
                                                        ),
                                                      ),
                                                      splitTicket(),
                                                      Container(
                                                        height: cx.height / 40,
                                                        decoration: BoxDecoration(
                                                            color: Colors.red,
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
                                                            SizedBox(
                                                              height: 2,
                                                            )
                                                          ],
                                                        ),
                                                      ),
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
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: widget.linkAccess &&
                    mycontroller.myList[0].paymentStatus.toString() ==
                        "In Progress"&&
                mycontroller.myList[0].bookingStatus != "Cancelled"
                ? Container(
                    width: cx.width,
                    child: Container(
                      height: cx.height / 8.5,
                      color: AppColor.darkGreen,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            cx.height / 44.47,
                            cx.height / 44.47,
                            cx.height / 44.47,
                            cx.height / 44.47),
                        child: AbsorbPointer(
                          absorbing: isPaymentAPICalling,
                          child: Container(
                            height: cx.height / 15,
                            width: cx.width / 2.4,
                            child: InkWell(
                              onTap: () {
                                print("No Verification Required");
                                if(linkAccessKey.currentState!.validate()) {
                                  print((mycontroller.myList[0].dueAmount -
                                      (double.parse(
                                          bottomMoneyController.text))));
                                  print((mycontroller.myList[0].dueAmount));
                                  print(
                                      double.parse(bottomMoneyController.text));

                                  if ((mycontroller.myList[0].dueAmount -
                                      (double.parse(
                                          bottomMoneyController.text))) <
                                      0.51 &&
                                      ((mycontroller.myList[0].dueAmount -
                                          (double.parse(
                                              bottomMoneyController.text))) >
                                          0.01)) {
                                    showLongToast(
                                        "Sorry...! You can't keep less than 0.5\$ pending");
                                  } else {
                                    print("Bottom Text" +
                                        bottomMoneyController.text);
                                    print("Minimum Text" +
                                        minimumAmount.toString());

                                    if (
                                        bottomMoneyController.text.isNotEmpty &&
                                        bottomNameController.text.isNotEmpty &&
                                        amountCorrect &&
                                        double.parse(
                                            bottomMoneyController.text) >=
                                            minimumAmount) {
                                      print("if");
                                      print(isDataProcesssing);
                                      setState(() {
                                        cx.isSplitAmount.value = true;
                                      });
                                      if (!isDataProcesssing) {
                                        print("start payment");
                                        makePayment();
                                      }
                                    } else {
                                      print("else");
                                      if (double.parse(
                                          bottomMoneyController.text) <
                                          0) {
                                        showLongToast(
                                            "Please enter positive amount");
                                      } else if (bottomMoneyController
                                          .text.isEmpty) {
                                        showLongToast(
                                            "Please enter the amount");
                                      } else if (bottomNameController
                                          .text.isEmpty) {
                                        showLongToast("Please enter your name");
                                      } else if (!amountCorrect) {
                                        showLongToast(
                                            "Please check the amount");
                                      } else if (double.parse(
                                          bottomMoneyController.text) <
                                          minimumAmount) {
                                        showLongToast(
                                            "Please enter valid amount \n(Minimum Amount is ${minimumAmount})");
                                      }
                                    }
                                  }
                                }
                              },
                              child: Container(
                                width: cx.width / 4,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      cx.height / 13.34,
                                    ),
                                    border: Border.all(
                                        width: 1.3, color: Colors.white)),
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: isPaymentAPICalling
                                      ? Container(
                                          height: 25,
                                          width: 25,
                                          child: CircularProgressIndicator(
                                            color: Color(0xFF265A46),
                                            // strokeWidth: 10,
                                          ),
                                        )
                                      : NunitoText(
                                          text: "Pay",
                                          fontWeight: FontWeight.w800,
                                          fontSize: cx.responsive(26, 20, 16),
                                          color: Colors.black,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container()),
      ),
    );
  }

  Future<void> makePayment() async {
    if (widget.linkAccess) {
    } else {}
    setState(() {
      isDataProcesssing = true;
    });
    debugPrint("Start Payment");

    print(cx.read(Keys.splitPaidAmount).toString());
    print(cx.read(Keys.total).toString());

    print(cx.isSplitAmount.value);

    paymentIntent = await createPaymentIntent(
        double.parse(bottomMoneyController.text).toStringAsFixed(2), 'CAD');

    // createPaymentIntent(
    //     cx.isSplitAmount.value?
    //     double.parse(cx.read(Keys.splitPaidAmount)).toStringAsFixed(2):
    //     double.parse(cx.read(Keys.total)).toStringAsFixed(2), 'CAD');

    debugPrint("After payment intent");
    print(paymentIntent);
    // Get.to(PaymentSheetScreenWithCustomFlow());

    if (paymentIntent != null) {
      try {
        await Stripe.merchantIdentifier;

        //Payment Sheet
        await Stripe.instance
            .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              // customFlow: true,

              paymentIntentClientSecret: paymentIntent!['client_secret'],
              appearance: PaymentSheetAppearance(
                colors: PaymentSheetAppearanceColors(
                  background: AppColor.bg,
                  primary: AppColor.darkGreen,
                  componentBorder: Colors.grey,
                ),
                shapes: PaymentSheetShape(
                  borderWidth: 1,
                  shadow: PaymentSheetShadowParams(color: Colors.grey),
                ),
                primaryButton: PaymentSheetPrimaryButtonAppearance(
                  shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
                  colors: PaymentSheetPrimaryButtonTheme(
                    light: PaymentSheetPrimaryButtonThemeColors(
                      background: AppColor.darkGreen,
                      text: Colors.white,
                      border: Colors.white,
                    ),
                  ),
                ),
              ),
              billingDetails: billingDetails,
              customerId: paymentIntent!['customer'],
              allowsDelayedPaymentMethods: true,
              applePay: PaymentSheetApplePay(
                merchantCountryCode: 'CA',
                // paymentSummaryItems: [
                //   ApplePayCartSummaryItem.immediate(label: '', amount: '100')
                // ],
              ),
              googlePay: const PaymentSheetGooglePay(
                testEnv: false,
                currencyCode: "CAD",
                merchantCountryCode: "CA",
              ),
              style: ThemeMode.light,
              merchantDisplayName: 'Ahmed Ibrahim'),
        )
            .then((value) {
          displayPaymentSheet();
        });

        ///now finally display payment sheeet
      } catch (e, s) {
        print('exception:$e$s');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        rethrow;
      }
    }
  }

  final billingDetails = BillingDetails(
    name: 'Flutter Stripe',
    email: 'email@stripe.com',
    phone: '+1',
    address: Address(
      city: 'Houston',
      country: 'CA',
      line1: '1459  Circle Drive',
      line2: '',
      state: 'Texas',
      postalCode: '',
    ),
  );

  Widget splitTicket() {
    return Container(
      color: AppColor.bg,
      child: Column(
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
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                                              fontSize:
                                                  cx.height > 800 ? 19 : 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColor.grey),
                                          Container(
                                            width: cx.width * 0.345,
                                            child: NunitoText(
                                              text: mycontroller.myList[0].field
                                                  .toString(),
                                              fontSize:
                                                  cx.height > 800 ? 20 : 17,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF414141),
                                              textOverflow:
                                                  TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          NunitoText(
                                              text: "Players",
                                              fontSize:
                                                  cx.height > 800 ? 19 : 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColor.grey),
                                          NunitoText(
                                              text: mycontroller
                                                  .myList[0].players
                                                  .toString(),
                                              fontSize:
                                                  cx.height > 800 ? 20 : 17,
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
                                              fontSize:
                                                  cx.height > 800 ? 20 : 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColor.grey),
                                          NunitoText(
                                              text: mycontroller.myList[0].date,
                                              fontSize:
                                                  cx.height > 800 ? 20 : 17,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF414141)),
                                          const SizedBox(
                                            width: 40,
                                          ),
                                          NunitoText(
                                              text: "Time",
                                              fontSize:
                                                  cx.height > 800 ? 20 : 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColor.grey),
                                          NunitoText(
                                              text: mycontroller.myList[0].time,
                                              fontSize:
                                                  cx.height > 800 ? 20 : 17,
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
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 5.0),
                                      child: Container(
                                        width: cx.width * 0.7,
                                        child: NunitoText(
                                            text:
                                                mycontroller.myList[0].address,
                                            maxLines: cx.height > 800 ? 4 : 3,
                                            textOverflow: TextOverflow.ellipsis,
                                            fontSize: cx.height > 800 ? 20 : 17,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF414141)),
                                      ),
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
                                padding: const EdgeInsets.only(
                                    right: 25.0, left: 10),
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
                                        // width: cx.width * 0.45,
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
                                                    mycontroller
                                                        .myList[0].paidAmount
                                                        .toStringAsFixed(2),
                                                fontSize:
                                                    cx.responsive(24, 20, 17),
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
                                                    text: "\$" +
                                                        mycontroller
                                                            .myList[0].dueAmount
                                                            .toStringAsFixed(2),
                                                    fontSize: cx.responsive(
                                                        25, 20, 17),
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
                                            mycontroller.myList[0].totalAmount
                                                .toStringAsFixed(2),
                                        fontSize: cx.responsive(29, 24, 21),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: cx.responsive(25, 22.5, 20),
                                          backgroundColor: Colors.white,
                                          child: CachedNetworkImage(
                                            imageUrl: cx.read("image"),
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: cx.responsive(25, 20, 17),
                                              backgroundImage: NetworkImage(
                                                cx.read("image"),
                                              ),
                                            ),
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: cx.responsive(25, 20, 17),
                                              backgroundImage: AssetImage(
                                                Image1.anime,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
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
                                            text: mycontroller
                                                .myList[0].userInfo.email,
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
                  color: Colors.white,
                  height: cx.height * 0.36,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 55,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 25.0, left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: cx.responsive(25, 18, 13),
                                top: cx.responsive(18, 14, 12),
                              ),
                              child: Container(
                                // width: cx.width * 0.45,
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
                                left: cx.responsive(5, 3, 2),
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
                                            mycontroller.myList[0].paidAmount
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
                                            text: "\$" +
                                                mycontroller.myList[0].dueAmount
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
                        padding:
                            EdgeInsets.fromLTRB(cx.height / 55.58, 4, 20, 8),
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
                                    mycontroller.myList[0].totalAmount
                                        .toStringAsFixed(2),
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
                                    imageUrl: cx.read("image"),
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: cx.responsive(25, 20, 17),
                                      backgroundImage: NetworkImage(
                                        cx.read("image"),
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
                                    text: mycontroller.myList[0].userInfo.email,
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
              : Container(),
          mycontroller.myList[0].otherContributors.length != 1
              ? Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  // height: cx.height * 0.485,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(cx.height / 80),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SenticText(
                            textAlign: TextAlign.start,
                            text: "Other Contributors",
                            fontWeight: FontWeight.w600,
                            fontSize: cx.responsive(25, 19, 17),
                            color: Color(0xFF222222),
                          ),
                          InkWell(
                            child: Icon(Icons.refresh),
                            onTap: () {
                              mycontroller.setBid(
                                  mycontroller.myList[0].id.toString(),
                                  0,
                                  false,
                                  false);
                            },
                          )
                        ],
                      ),
                      Gap(cx.height / 60),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        // scrollDirection: Axis.horizontal,
                        itemCount:
                            mycontroller.myList[0].otherContributors.length,
                        itemBuilder: (context, index) {
                          OtherContributor data =
                              mycontroller.myList[0].otherContributors[index];
                          return index != 0
                              ? Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: AppColor.lightGreen,
                                        radius: cx.responsive(30, 25, 20),
                                        child: NunitoText(
                                          text: data.contributorName.isEmpty
                                              ? "Dome User"
                                              : data.contributorName
                                                  .substring(0, 1)
                                                  .toUpperCase(),
                                          fontWeight: FontWeight.w500,
                                          fontSize: cx.responsive(24, 20, 18),
                                          color: Colors.white,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                      title: NunitoText(
                                        text: data.contributorName.isEmpty
                                            ? "Dome User"
                                            : data.contributorName,
                                        fontWeight: FontWeight.w800,
                                        fontSize: cx.responsive(22, 18, 16),
                                        color: Color(0xFF6F6B6B),
                                      ),
                                      trailing: Container(
                                        child: SenticText(
                                          text: "\$${data.amount}",
                                          // text: "\$${data.amount.toStringAsFixed(2)}",
                                          fontWeight: FontWeight.w300,
                                          fontSize: cx.responsive(22, 17, 15),
                                          color: Color(0xFF07261A),
                                          textAlign: TextAlign.center,
                                        ),
                                        decoration: BoxDecoration(
                                            color: Color(0xFFFFE68A),
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        padding:
                                            EdgeInsets.fromLTRB(15, 10, 15, 10),
                                      ),
                                      // dense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    index ==
                                            mycontroller.myList[0]
                                                    .otherContributors.length -
                                                1
                                        ? Container()
                                        : Divider(
                                            thickness: 0.6,
                                          )
                                  ],
                                )
                              : Container();
                        },
                      )
                      // Column(
                      //   // mainAxisAlignment: MainAxisAlignment.center,
                      //   // crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Gap(cx.height / 60),
                      //
                      //     Container(
                      //       alignment: Alignment.center,
                      //       child:NunitoText(
                      //         textAlign: TextAlign.center,
                      //
                      //         text: "Oops! No one has\n contributed Yet",
                      //         fontWeight: FontWeight.w400,
                      //           fontSize: cx.responsive(25,21, 18),
                      //         color: Colors.grey,
                      //       ),
                      //     ),
                      //     Gap(cx.height / 60),
                      //
                      //   ],
                      // ),
                    ],
                  ),
                )
              : Container(),
          mycontroller.myList[0].bookingStatus.isEmpty &&
                  mycontroller.myList[0].paymentStatus == "Paid" &&
                  mycontroller.myList[0].isRattingExist == 0 &&
                  torontoCurTime.millisecondsSinceEpoch >=
                      bookingEndTimeAPI.millisecondsSinceEpoch
              ? Column(
                  children: [
                    Container(
                      height: cx.height / 9,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Gap(6),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                            child: const Divider(
                              color: Color(0xFFE7F4EF),
                              thickness: 2,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              print("Review Booking");
                              print(torontoCurTime);
                              print(bookingEndTimeAPI);
                              msgpasscontroller.clear();
                              starsValue = 5;
                              onRatingsPopUp(
                                  ratingContext: context,
                                  domeId: mycontroller.myList[0].domeId);
                              // showDialog(
                              //     context: context,
                              //     builder: (BuildContext context) =>
                              //         onRatingsPopUp(context: context,domeId: item.domeId));
                            },
                            child: Column(
                              children: [
                                Gap(7),
                                InterText(
                                  text: "Rate & Review",
                                  color: AppColor.lightGreen,
                                  fontWeight: FontWeight.w700,
                                  fontSize: cx.responsive(25, 21, 18),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget linkAccess() {
    return Padding(
      padding: EdgeInsets.only(
          top: 0, left: cx.height / 22.23, right: 32, bottom: 10),
      child: Column(
        children: [
          Container(
            // height: cx.height * 0.65,
            width: cx.width * 0.9,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.01,
                      0.18
                    ],
                    colors: [
                      Color(0xFFEFF6EA),
                      Colors.white,
                    ]),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(cx.height / 37.06),
                    topRight: Radius.circular(cx.height / 37.06),
                    bottomLeft: Radius.circular(cx.height / 37.06),
                    bottomRight: Radius.circular(cx.height / 37.06))),
            child: Column(
              children: [
                Gap(cx.height * 0.045),
                Container(
                  // height: cx.height*0.1,
                  alignment: Alignment.center,
                  child: NunitoText(
                    text: "Make The Payment Before The Timer Expires",
                    color: AppColor.darkGreen,
                    fontSize: cx.responsive(16, 14, 12),
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                ),
                timer(
                  isDefaultTime,
                  hours: hours,
                  minutes: minutes,
                  seconds: seconds,
                  hours1: hours1,
                  minutes1: minutes1,
                  seconds1: seconds1,
                ),
                Gap(cx.height * 0.015),
                Padding(
                  padding: EdgeInsets.fromLTRB(12.0, 0, 12, 0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: bottomNameController,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Your Name";
                      }
                      if (value.length < 3) {
                        return "Please Enter Valid Name";
                      }
                    },
                    style: GoogleFonts.nunito(
                      fontSize: cx.responsive(27, 21, 18),
                      fontWeight: FontWeight.w800,
                      color: AppColor.darkGreen,
                    ),

                    cursorColor: AppColor.darkGreen,
                    cursorHeight: 20,
                    keyboardType: TextInputType.text,
                    autofocus: false,

                    // textInputAction: TextInputAction.number,
                    decoration: InputDecoration(
                      hintText: "Enter your name",
                      hintStyle: TextStyle(
                        color: Color(0xFF628477),
                        fontWeight: FontWeight.w500,
                        fontSize: cx.responsive(19, 17, 15),
                      ),
                      fillColor: AppColor.bg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(cx.height / 6.67),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF9BD9C1),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(cx.height / 6.67),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF9BD9C1),
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(cx.height / 6.67),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF9BD9C1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(cx.height / 6.67),
                        borderSide: BorderSide(
                          width: 3,
                          color: Color(0xFF9BD9C1),
                        ),
                      ),
                      prefixIcon: Container(
                        height: 55,
                        width: 55,
                        child: InkWell(
                            onTap: () async {},
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(18.0, 8, 10, 8),
                              child: SvgPicture.asset(
                                "assets/svg/prof.svg",
                                // color: AppColor.darkGreen
                              ),
                            )),
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.fromLTRB(
                        cx.responsive(30, 24, 20),
                        cx.responsive(17, 13, 10),
                        cx.responsive(33, 25, 20),
                        cx.responsive(13, 8, 6),
                      ),
                    ),
                  ),
                ),
                Gap(cx.height * 0.015),
                Padding(
                  padding: EdgeInsets.fromLTRB(12.0, 0, 12, 0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: bottomMoneyController,
                    style: GoogleFonts.nunito(
                      fontSize: cx.responsive(27, 21, 18),
                      fontWeight: FontWeight.w800,
                      color: AppColor.darkGreen,
                    ),
                    onChanged: (text) {
                      print(amountCorrect);
                      if (text is double || _isNumeric(text)) {
                        if (double.parse(text) > 0 &&
                            double.parse(text) <
                                mycontroller.myList[0].dueAmount) {
                          setState(() {
                            amountCorrect = true;
                          });
                          print(text);
                        }
                      } else {
                        setState(() {
                          amountCorrect = false;
                        });
                      }
                    },

                    cursorColor: AppColor.darkGreen,
                    cursorHeight: 20,
                    keyboardType: Platform.isIOS
                        ? TextInputType.numberWithOptions(decimal: true)
                        : TextInputType.number,
                    autofocus: false,

                    // textInputAction: TextInputAction.number,
                    decoration: InputDecoration(
                      hintText: "Enter your amount",
                      hintStyle: TextStyle(
                        color: Color(0xFF628477),
                        fontWeight: FontWeight.w500,
                        fontSize: cx.responsive(19, 17, 15),
                      ),
                      fillColor: AppColor.bg,
                      // hintText: "Enter Initial Deposit",
                      // hintStyle: GoogleFonts.nunito(
                      //   fontSize: cx.responsive(25,21, 18),
                      //   fontWeight: FontWeight.w700,
                      //   color: AppColor.darkGreen,
                      // ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(cx.height / 6.67),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF9BD9C1),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(cx.height / 6.67),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF9BD9C1),
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(cx.height / 6.67),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF9BD9C1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(cx.height / 6.67),
                        borderSide: BorderSide(
                          width: 3,
                          color: Color(0xFF9BD9C1),
                        ),
                      ),
                      prefixIcon: Container(
                        height: 55,
                        width: 55,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(18.0, 10, 10, 8),
                          child: InkWell(
                              onTap: () async {},
                              child: SvgPicture.asset(
                                "assets/svg/dollar.svg",

                                // color: AppColor.darkGreen
                              )),
                        ),
                      ),
                      filled: true,

                      contentPadding: EdgeInsets.fromLTRB(
                        cx.responsive(30, 24, 20),
                        cx.responsive(17, 13, 10),
                        cx.responsive(33, 25, 20),
                        cx.responsive(13, 8, 6),
                      ),
                    ),
                    validator: (value) {
                      // if (value != null) {
                      //   if (value.contains('.')) {
                      //     isDecimal = true;
                      //   } else {
                      //     isDecimal = false;
                      //   }
                      // }

                      if (value == null || value.isEmpty) {
                        return "Please Enter Your Amount";
                      }
                      if (value is double || _isNumeric(value)) {
                        if (double.parse(value) >
                            mycontroller.myList[0].dueAmount) {
                          print(value);
                          print(value);
                          print(bottomMoneyController.text);
                          return "Please Enter Valid Amount";
                        }
                        else if (double.parse(value) <
                            0) {
                          showLongToast(
                              "Please Enter Positive Amount");
                        }
                        else if (double.parse(value) <
                            minimumAmount) {
                          return "Minimum Amount is ${minimumAmount}";

                        }
                      } else {
                        return "Please Enter Valid Amount";
                      }

                      // else if (double.parse(value) <
                      //     double.parse(defaultAmount.toStringAsFixed(2))) {
                      //   print(value);
                      //   print(defaultAmount);
                      //   return "Not Less Than Min Initial Deposit";
                      // }
                    },
                  ),
                ),
                Gap(cx.height * 0.02),
                Container(
                  width: cx.width * 0.75,
                  child: RadioListTile(
                    dense: true,
                    toggleable: true,
                    value: "true",
                    title: NunitoText(
                      text: "Pay All Remaining Amount",
                      fontSize: cx.responsive(18, 16, 14),
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF757575),
                    ),
                    groupValue: site,
                    onChanged: (value) {
                      print(site);

                      setState(() {
                        if (site != "true") {
                          bottomMoneyController.text = mycontroller
                              .myList[0].dueAmount
                              .toStringAsFixed(2);
                        } else {
                          bottomMoneyController.text = "";
                        }
                        site = value.toString();
                      });
                    },
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
                Padding(
                  padding: const EdgeInsets.only(right: 25.0, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: cx.responsive(25, 18, 13),
                          top: cx.responsive(18, 14, 12),
                        ),
                        child: Container(
                          // width: cx.width * 0.45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          left: cx.responsive(5, 3, 2),
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
                                      mycontroller.myList[0].paidAmount
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
                                      text: "\$" +
                                          mycontroller.myList[0].dueAmount
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
                Gap(cx.height * 0.01),
              ],
            ),
          ),
          Container(
            height: 20,
          ),
        ],
      ),
    );
  }

  displayPaymentSheet({
    int? paymentMethod,
  }) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        setState(() {
          isPaymentAPICalling = true;
        });

        debugPrint("After payment intent2");
        debugPrint(torontoCurTime.toString());
        print(paymentIntent);
        confirmPayment();
        splitPayment(
          paymentIntent!['id'],
        ).then((value) async {
          setState(() {
            isPaymentAPICalling = false;
          });
          _onAlertWithCustomContentPressed(context);

          Timer(du, () async {
            await mycontroller
                .setBid(
              mycontroller.myList[0].id.toString(),
              2,
              true,
              true,
              linkAccess: false,
              // isLinkTimerExpire: true
            )
                .then((value) {
              // bottomMoneyController.text = '';
              bottomNameController.text = '';
              isPaymentAPICalling = false;
              isDataProcesssing = false;
              print("hiiiiiiii Ahmed");

              var data=mycontroller.myList[0];

              if (data.dueAmount > 0 &&
                  ((data.players - data.otherContributors.length) > 0)) {
                amountCorrect = true;
                bottomMoneyController.text =
                    (data.dueAmount / (data.players - data.otherContributors.length))
                        .toStringAsFixed(2);
                minimumAmount=double.parse((data.dueAmount / (data.players - data.otherContributors.length))
                    .toStringAsFixed(2));

                print("Ahmed");
                print(minimumAmount);
                print(data.dueAmount);
                print(data.players);
                print(data.otherContributors.length);
              } else {
                amountCorrect = true;
                bottomMoneyController.text = data.dueAmount.toStringAsFixed(2);
              }
            });
          });
        });
      }).onError((error, stackTrace) {
        setState(() {
          isDataProcesssing = false;
        });
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      setState(() {
        isDataProcesssing = false;
      });
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      setState(() {
        isDataProcesssing = false;
      });
      print('$e');
    }
  }

  void confirmPayment() async {
    try {
      print("data.toString()");

      var data = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: paymentIntent!['client_secret'],
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
        options: PaymentMethodOptions(
          setupFutureUsage: PaymentIntentsFutureUsage.OnSession,
        ),
      );
      print("data.toString()");
      print(data.toString());

      // PaymentIntentResult paymentIntentResult =
      // await Stripe.instance.confirmPaymentIntent(PaymentIntent(
      //   clientSecret: _clientSecret,
      //   paymentMethodId: _paymentMethodId,
      // ));
      //
      // if (paymentIntentResult.status == PaymentStatus.succeeded) {
      //   // Payment completed successfully
      // } else {
      //   // Payment failed
      // }
    } catch (e) {
      // Error occurred during payment processing
    }
  }

  _onAlertWithCustomContentPressed(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          AbsorbPointer(absorbing: true, child: reserveSuccessful()),
    );
    Timer(du, () {
      Get.back();
    });
  }

  Widget reserveSuccessful() => StatefulBuilder(builder: (BuildContext context,
          StateSetter setState /*You can rename this!*/) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          //this right here
          insetPadding: EdgeInsets.zero,
          child: Container(
            height: cx.height / 2.55,
            width: cx.width / 1.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset("assets/svg/rsuccess.svg"),
                Gap(cx.height / 30),
                InterText(
                  text: cx.isSplitAmount.value ? "Payment" : "Reservation",
                  fontWeight: FontWeight.w500,
                  fontSize: cx.height > 800 ? 26 : 24,
                  color: Color(0xFF70A792),
                ),
                SenticText(
                  height: 1.4,
                  text: "Successful",
                  fontWeight: FontWeight.w500,
                  fontSize: cx.height > 800 ? 34 : 30,
                  color: Colors.black,
                ),
                Gap(cx.height / 100),
              ],
            ),
          ),
        );
      });

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${Constant.stripeSecretKey}',
          // 'Bearer ${cx.read(Constant.stripeSecretKey)}',
          // 'Bearer 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',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    // print(double.parse(amount)*100.ceilToDouble());
    // print((double.parse(amount)).toInt());
    // print((double.parse(amount)).toInt()*100);
    double convertToDouble = double.parse(amount);
    print(convertToDouble);

    int convertToInt = (convertToDouble * 100).ceil();
    print(convertToInt);

    String convertAmount = convertToInt.toString();
    // String convertAmount=(double.parse(amount)*100).toInt().toString();
    print("amount");
    print(convertAmount);
    print(amount);

    final calculatedAmout = int.parse(convertAmount);

    return calculatedAmout.toString();
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

  bool _isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  Future<void> splitPayment(
    String? paymentIntent,
  ) async {
    onAlert(context: context, type: 1, msg: "Loading...");

    try {
      print("bottomMoneyController.text");
      print(bottomMoneyController.text);
      var request =
          http.MultipartRequest('POST', Uri.parse(Constant.splitPayment));
      request.fields.addAll({
        'contributor_name': bottomNameController.text,
        'transaction_id': paymentIntent.toString(),
        'amount': bottomMoneyController.text,
        // 'amount': (double.tryParse(bottomMoneyController.text) ?? 0.0).toStringAsFixed(2),
        'booking_id': mycontroller.myList[0].id.toString(),
        'payment_method': '1'
      });
      print(request.fields);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      if (jsonBody['status'] == 1) {
        print(jsonBody.toString());

        onAlert(context: context, type: 2, msg: jsonBody['message']);
      } else {
        print("0");
        onAlert(context: context, type: 3, msg: jsonBody['message']);
        print(jsonBody.toString());
      }
    } catch (e) {
      Get.back();

      showLongToast("Oops! Server Unavailable");
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }

  Future<void> _createDynamicLink(
      bool short, String link, String bookingId) async {
    setState(() {
      _isCreatingLink = true;
    });
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: Constant.kUriPrefix,
      // link: Uri.parse(Constant.kUriPrefix + link+'?bookingId=45'),
      link: Uri.parse(
          "https://www.domez.io/domeBooking?bookingId=${bookingId.toString()}"),
      // link: Uri.parse(Constant.kUriPrefix + link),
      // longDynamicLink: Uri.parse(
      //   'https://flutterfiretests.page.link?efr=0&ibi=io.flutter.plugins.firebase.dynamiclinksexample&apn=io.flutter.plugins.firebase.dynamiclinksexample&imv=0&amv=0&link=https%3A%2F%2Fexample%2Fhelloworld&ofl=https://ofl-example.com',
      // ),
      androidParameters: const AndroidParameters(
        packageName: 'domez.io',
        minimumVersion: 0,
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
    print("Hey NORA" + _linkMessage.toString());
  }
}
