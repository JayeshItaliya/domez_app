import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:domez/commonModule/AppColor.dart';
import 'package:domez/commonModule/widget/search/customButton.dart';
import 'package:domez/controller/categoryController.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:gap/gap.dart';
import 'package:domez/commonModule/widget/common/textNunito.dart';
import 'package:domez/screens/authPage/signIn.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

import '../controller/bookingDetailsController.dart';
import '../controller/commonController.dart';
import '../main.dart';
import '../main_page.dart';
import '../screens/menuPage/filters.dart';
import '../screens/payment/linkAccess/initialLinkAccess.dart';
import '../service/getAPI.dart';
import 'Constant.dart';
import 'Strings.dart';
import 'notificationService.dart';


CommonController cx = Get.put(CommonController());
CategoryController categoryListController = Get.put(CategoryController());
String location = '';
String address = '';
String bookingId='';
FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
NotificationServices notificationServices = NotificationServices();

sportIdUpdate(String sportid){
  categoryListController.sportid.value=sportid;
}

showLongToast(String s) {
  Fluttertoast.showToast(
    msg: s,
    toastLength: Toast.LENGTH_LONG,
  );
}

Duration du = const Duration(seconds: 3);
BookingDetailsController mycontroller = Get.put(BookingDetailsController());


onAlert({required BuildContext context, int? type, String? msg}) {
  if (type == 2 || type == 3)
    Get.back();

  Alert(

    style: AlertStyle(
        buttonsDirection: ButtonsDirection.column,
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(
            color: type == 3 ? Color(0xFFFFC8C8) : Color(0xFF9BD9C1),
            width: 2.5,
          ),
        ),
        alertElevation: 100,
        isButtonVisible: false),
    onWillPopActive: true,
    context: context,
    content: Column(
      children: <Widget>[
        Gap(cx.height / 18),
        type == 1
            ? CircularProgressIndicator(
          color: AppColor.darkGreen,
        )
            : type == 2
            ? Image.asset(
          "assets/images/emailsent.png",
          scale: cx.height > 800 ? 2 : 2.5,
        )
            : type == 3
            ? Image.asset(
          "assets/images/cancel.png",
          scale: cx.height > 800 ? 2 : 2.5,
        )
            : Container(),
        Gap(cx.height / 44.47),
        Text(
          msg ?? "",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: cx.height > 800 ? 25 : 22,
            color: Color(0xFF222222),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
    closeIcon: Container(
      height: cx.height / 44.47,
    ),
    // onWillPopActive:true ,
  ).show();
  if (type == 2 || type == 3) {
    Timer(du, () {
      Get.back();
    });
  }
}



onAlertSignIn({
  required BuildContext context,
  required int currentIndex,
  required int noOfPopTimes,
}) {
  Alert(
    style: AlertStyle(
        buttonsDirection: ButtonsDirection.column,
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(
            color: Color(0xFF9BD9C1),
            width: 2.5,
          ),
        ),
        alertElevation: 100,
        isButtonVisible: false),
    onWillPopActive: false,
    context: context,
    content: Column(
      children: <Widget>[
        Gap(cx.height / 60),
        Text(
          "Sign In",
          style: TextStyle(
              fontSize: cx.responsive(24,20, 18), fontWeight: FontWeight.w700),
        ),
        Gap(cx.height / 60),
        Text(
          "Please Sign In To Get Access Of This Feature",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: cx.responsive(22,18, 14), fontWeight: FontWeight.w400, color: Colors.grey),
        ),
        Gap(cx.height / 20),
        InkWell(
          onTap: () {
            Get.off(SignIn(curIndex: currentIndex,noOfPopTime: noOfPopTimes,));
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.all(cx.height / 66.7),
            child: Center(
              child: NunitoText(
                text: "Sign In",
                fontWeight: FontWeight.w700,
                fontSize: cx.responsive(25,21, 17),
                color: Colors.white,
              ),
            ),
          ),
        ),
        Gap(cx.height / 120),
        InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.red,
                borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.all(cx.height / 66.7),
            child: Text(
              "No Thanks!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: cx.responsive(26,20, 16),
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6F6B6B)),
            ),
          ),
        ),

      ],
    ),
    closeIcon: Container(
      height: cx.height / 44.47,
    ),
    // onWillPopActive:true ,
  ).show();
}

onCancelAlert(
    {required BuildContext context,
      required String? bookingId,
      required VoidCallback onCancel})  {
  Alert(
    style: AlertStyle(
        buttonsDirection: ButtonsDirection.column,
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(
            color: Color(0xFF9BD9C1),
            width: 2.5,
          ),
        ),
        alertElevation: 100,
        isButtonVisible: false),
    onWillPopActive: false,
    context: context,
    content: Column(
      children: <Widget>[
        Gap(cx.height / 60),
        Text(
          "Cancel Booking",
          style: TextStyle(
              fontSize: cx.responsive(24,20, 18), fontWeight: FontWeight.w700),
        ),
        Gap(cx.height / 60),
        Text(
          "Cancellation fee will be applied.\nAre you sure?",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
        ),
        Gap(cx.height / 20),
        InkWell(
          onTap: onCancel,
          child: Container(
            // width: widget.width,
            decoration: BoxDecoration(
                color: Color(0xFFB01717),
                borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.all(cx.height / 66.7),
            child: Center(
              child: NunitoText(
                text: "Cancel Booking",
                fontWeight: FontWeight.w700,
                fontSize: cx.responsive(26,20, 16),
                color: Colors.white,
              ),
            ),
          ),
        ),
        Gap(cx.height / 70),
        InkWell(
          onTap: () {
            Get.back();
          },
          child: Text(
            "Go Back",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6F6B6B)),
          ),
        ),
      ],
    ),
    closeIcon: Container(
      height: cx.height / 44.47,
    ),
    // onWillPopActive:true ,
  ).show();
}

Future<int> cancelAccount(
    {required BuildContext context, required String bookingId}) async {
  onAlert(context: context, type: 1, msg: "Loading...");

  try {
    var request =
    http.MultipartRequest('POST', Uri.parse(Constant.cancelAccount));
    request.fields.addAll({
      'booking_id': bookingId.toString(),
    });
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    final jsonBody = await jsonDecode(respStr);

    if (jsonBody['status'] == 1) {
      print(jsonBody.toString());

      onAlert(
          context: context,
          type: 2,
          msg: "Booking has been Cancelled Successfully");
      return 1;
    } else {
      onAlert(
          context: context,
          type: 3,
          msg: "Oops! We Are Unable To Cancel Your Booking");
      print(jsonBody);
      return 0;

    }
  } catch (e) {
    print(e.toString());
    if (e is SocketException) {
      showLongToast("Could not connect to internet!!");
    }
    return 0;
  }
}

onShareData({String? text}) async {
  await Share.share(text!);
}

Future<String?> getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor;
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId;
  }
}

Widget noInternetLottie({bool? backbutton}) {
  return Column(
    mainAxisAlignment: backbutton ?? false
        ? MainAxisAlignment.spaceBetween
        : MainAxisAlignment.center,
    children: [
      backbutton ?? false
          ? Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: cx.responsive(20,15, 12), top: cx.responsive(43,35, 30)),
            child: Container(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 27,
                    color: Colors.black,
                  ),
                )),
          ),
        ],
      )
          : Container(),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset("lottie/no_internet_lottie.json",
              height: cx.height / 2, width: double.infinity),
          Gap(
            cx.height / 9,
          ),
          InkWell(
            onTap: () {
              Get.offAll(
                MainPageScreen(),
                transition: Transition.fade,
              );
            },
            child: Container(
              color: Colors.grey,
              height: cx.height / 18,
              width: cx.width / 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                  ),
                  NunitoText(
                    text: " Retry",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: cx.responsive(24,20, 18),
                  ),
                ],
              ),
            ),
          ),
          Gap(
            cx.height / 40,
          ),
        ],
      ),
    ],
  );
}

Widget timer(
    bool isDefaultTime,{ String? hours, String? minutes, String? seconds, String? hours1, String? minutes1, String? seconds1}) {
  return Column(
    children: [
      Gap(cx.height / 30),
      Container(
        height: cx.height / 13,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: cx.responsive(5,4, 3)),
              child: Container(
                width: cx.width * 0.10,
                alignment: Alignment.center,
                child: Text(
                  isDefaultTime ? '${hours1![0]}' : hours![0],
                  style: GoogleFonts.nunito(
                    fontSize: cx.responsive(46,40, 36),
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF494949),
                  ),
                  textAlign: TextAlign.center,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFD4D4D4))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: cx.responsive(3,2, 1)),
              child: Container(
                width: cx.width * 0.10,
                alignment: Alignment.center,
                child: Text(
                  isDefaultTime ? '${hours1![1]}' : hours![1],
                  style: GoogleFonts.nunito(
                    fontSize: cx.responsive(46,40, 36),
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF494949),
                  ),
                  textAlign: TextAlign.center,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFD4D4D4))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: cx.responsive(3,2, 1),
                bottom: cx.responsive(6,5, 4),
              ),
              child: Text(
                ':',
                style: GoogleFonts.nunito(
                  fontSize: cx.responsive(46,40, 36),
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF494949),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: cx.responsive(6,5, 4)),
              child: Container(
                width: cx.width * 0.10,
                alignment: Alignment.center,
                child: Text(
                  isDefaultTime ? '${minutes1![0]}' : minutes![0],
                  style: GoogleFonts.nunito(
                    fontSize: cx.responsive(46,40, 36),
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF494949),
                  ),
                  textAlign: TextAlign.center,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFD4D4D4))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: cx.responsive(3,2, 1)),
              child: Container(
                width: cx.width * 0.10,
                alignment: Alignment.center,
                child: Text(
                  isDefaultTime ? '${minutes1![1]}' : minutes![1],
                  style: GoogleFonts.nunito(
                    fontSize: cx.responsive(46,40, 36),
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF494949),
                  ),
                  textAlign: TextAlign.center,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFD4D4D4))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: cx.responsive(3,2, 1),
                bottom: cx.responsive(6,5, 4),
              ),
              child: Container(
                height: cx.height / 13,
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    ':',
                    style: GoogleFonts.nunito(
                      fontSize: cx.responsive(46,40, 36),
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF494949),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: cx.responsive(6,5, 4)),
              child: Container(
                width: cx.width * 0.10,
                alignment: Alignment.center,
                child: Text(
                  isDefaultTime ? '${seconds1![0]}' : seconds![0],
                  style: GoogleFonts.nunito(
                    fontSize: cx.responsive(46,40, 36),
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF494949),
                  ),
                  textAlign: TextAlign.center,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFD4D4D4))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: cx.responsive(3,2, 1)),
              child: Container(
                width: cx.width * 0.10,
                alignment: Alignment.center,
                child: Text(
                  isDefaultTime ? '${seconds1![1]}' : seconds![1],
                  style: GoogleFonts.nunito(
                    fontSize: cx.responsive(46,40, 36),
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF494949),
                  ),
                  textAlign: TextAlign.center,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFD4D4D4))),
              ),
            ),
          ],
        ),
      ),
      Gap(cx.height / 80),
    ],
  );
}
Widget timerBox(
    bool isDefaultTime,{ String? hours, String? minutes, String? seconds, String? hours1, String? minutes1, String? seconds1,String? paymentLink,String? timerMessage}) {
  return Padding(
    padding: EdgeInsets.only(
        top: 0,
        left: cx.height / 22.23,
        right: 32,
        bottom: 10),
    child: Container(
      decoration: BoxDecoration(
          color: AppColor.bg,
          borderRadius:
          BorderRadius.circular(cx.height / 44.47)),
      child: Column(
        children: [
          Container(
            width: cx.width * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                  cx.height / 37.06),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  // stops: [
                  //   0.5,
                  //   0.6
                  // ],
                  colors: [
                    Color(0xFFF1F5EF),
                    Color(0xFFFCFEFD),
                  ]),
            ),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [
                timer(isDefaultTime,seconds: seconds,minutes: minutes,hours: hours,
                    seconds1: seconds1,minutes1: minutes1,hours1: hours1),
                Text(
                  timerMessage.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Color(0xFFA8A8A8),
                      fontSize: cx.responsive(16,12, 10)),
                ),
                Gap(cx.height / 25),
                Padding(
                  padding: EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Container(
                      height: cx.height / 15,
                      width: cx.width * 0.7,
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(40),
                          color: AppColor.bg,
                          border: Border.all(
                              color:
                              Color(0xFF9BD9C1))),
                      padding: EdgeInsets.fromLTRB(
                          20, 0, 0, 0),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: [
                          NunitoText(
                            text: "domez/payment",
                            fontWeight: FontWeight.w700,
                            fontSize:
                            cx.responsive(18,15, 13),
                            color: Color(0xFF628477),
                          ),
                          InkWell(
                            onTap: () {
                              onShareData(
                                  text: paymentLink);
                            },
                            child: Container(
                              height: cx.height / 15,
                              width: cx.width * 0.22,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius
                                      .circular(40),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: AppColor
                                          .darkGreen)),
                              alignment:
                              Alignment.center,
                              child: NunitoText(
                                text: "Share",
                                fontWeight:
                                FontWeight.w800,
                                fontSize: cx.responsive(22,18, 16),
                                color:
                                Color(0xFF07261A),
                                textAlign:
                                TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      )),
                ),
                Gap(cx.height / 30),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
final GlobalKey<FormState> ratingsPopUpkey = GlobalKey<FormState>();
double starsValue = 5;
TextEditingController msgpasscontroller = TextEditingController();
bool msgError = false;

onRatingsPopUp({
  required BuildContext ratingContext,required int domeId,
}) {
  Alert(
    style: AlertStyle(
        buttonsDirection: ButtonsDirection.column,
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(
            color: Color(0xFF9BD9C1),
            width: 2.5,
          ),
        ),
        alertElevation: 100,
        isButtonVisible: false),
    onWillPopActive: false,
    context: ratingContext,
    content: StatefulBuilder(builder: (BuildContext context,
        StateSetter setState, /*You can rename this!*/) {
      return Form(
        key: ratingsPopUpkey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          children: <Widget>[
            Text(
              "Rate & Review",
              style: TextStyle(
                  fontSize: cx.responsive(24,20, 18),
                  fontWeight: FontWeight.w700),
            ),
            Gap(cx.height / 50),
            RatingStars(
              value: starsValue,
              onValueChanged: (v) {
                //
                setState(() {
                  starsValue = v;
                });
              },
              starBuilder: (index, color) => Icon(
                Icons.star,
                color: color,
                size: cx.responsive(43,35, 30),
              ),
              starCount: 5,
              starSize: 42,
              maxValue: 5,
              starSpacing: 0,
              maxValueVisibility: true,
              valueLabelVisibility: false,
              animationDuration: Duration(milliseconds: 1000),
              starOffColor: const Color(0xffe7e8ea),
              starColor: Color(0xFFFFC439),
            ),
            Gap(cx.height / 60),
            Container(
              height: cx.height / 5,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color:
                  msgError ? Color(0xFFD32F2F) : Color(0xFFE8FFF6),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF5F7F9),
                    blurRadius: 8,
                    spreadRadius: 7, //New
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  15.0,
                  4,
                  15,
                  4,
                ),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLines: 6,
                  onChanged: (value) {
                    if (value.length <= 1) {
                      setState(() {
                        msgError = false;
                      });
                    }
                  },
                  onTap: () {
                    if (msgpasscontroller.text.length == 0 ||
                        msgpasscontroller.text.isEmpty) {
                      setState(() {
                        msgError = true;
                      });
                    }
                  },
                  maxLength: 300,
                  controller: msgpasscontroller,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      hintText:
                      "Describe Your Experience With \nThe Dome",
                      hintStyle: TextStyle(
                        fontSize: cx.height > 800 ? 16 : 13,
                        color: Color(0xFF444444),
                      ),
                      border: InputBorder.none),

                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  style: TextStyle(
                    fontSize: cx.height > 800 ? 18 : 15,
                    color: Color(0xFF444444),
                  ),
                  // validator: (value){
                  //   if (value == null || value.isEmpty) {
                  //     return "Please Enter Valid Confirm Password";
                  //   }
                  // },
                ),
              ),
            ),
            Gap(cx.height / 100),
            Padding(
              padding: EdgeInsets.only(
                left: cx.responsive(28,23, 20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NunitoText(
                    text: "Please Enter Your Message",
                    fontSize: cx.responsive(15,13, 12.5),
                    color:
                    msgError ? Color(0xFFD32F2F) : Colors.transparent,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Gap(msgError ? cx.height / 25 : cx.height / 30),
            Padding(
              padding: EdgeInsets.only(
                bottom: cx.responsive(20,15, 12),
                right: cx.responsive(23,15, 10),
                left: cx.responsive(23,15, 10),
              ),
              child: Container(
                width: cx.width / 1.4,
                height: 50,
                child: CustomButton(
                  text: "Submit",
                  fun: () {
                    if (msgpasscontroller.text.isEmpty) {
                      setState(() {
                        msgError = true;
                      });
                    }
                    else{
                      if (ratingsPopUpkey.currentState!.validate()) {
                        Get.back();
                        TaskProvider.postRatings(ratingContext,domeId);

                        // changePass();
                      }
                    }


                  },
                  color: AppColor.darkGreen,
                  radius: cx.height / 11.17,
                  width: cx.width / 4,
                  size: cx.responsive(25,22, 15),
                  textColor: Colors.white,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: NunitoText(
                text: "Cancel",
                fontSize: cx.responsive(23,18, 15),
                color: Color(0xFF6F6B6B),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }),
    closeIcon: Container(
      height: cx.height / 44.47,
    ),
    // onWillPopActive:true ,
  ).show();
}

class NetworkConnectivity {
  NetworkConnectivity._();
  static final _instance = NetworkConnectivity._();
  static NetworkConnectivity get instance => _instance;
  final _networkConnectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;
  // 1.
  void initialise() async {
    ConnectivityResult result = await _networkConnectivity.checkConnectivity();
    _checkStatus(result);
    _networkConnectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }
// 2.
  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }
  void disposeStream() => _controller.close();


}



Future<void> getCurrentLocation() async {
  Position position = await getGeoLocationPosition();
  location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
  GetAddressFromLatLong(position);

  cx.lat.value = position.latitude.toString();
  cx.lng.value = position.longitude.toString();

  print(cx.lat.value);
  print(cx.lng.value);
  cx.write(Keys.lat, cx.lat.value);
  cx.write(Keys.lng, cx.lng.value);
  debugPrint(location);
  debugPrint(address);
}

Future<Position> getGeoLocationPosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    permission = await Geolocator.requestPermission();

    await Geolocator.openLocationSettings();
    // return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  print("permission");
  print(permission);

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    // await Geolocator.openLocationSettings();

    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    await Geolocator.openLocationSettings();

    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}

Future<void> GetAddressFromLatLong(Position position) async {
  List<Placemark> placemarks =
  await placemarkFromCoordinates(position.latitude, position.longitude);
  debugPrint("++++++" + placemarks.toString());
  Placemark place = placemarks[0];
  address =
  '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

  cx.searchDome.value = place.locality! + "," + place.country.toString();

  debugPrint(cx.searchDome.value.toString());
}

//If app is shutDown
void fetchLinkData() async {
  print("fetchLinkData");
  final PendingDynamicLinkData? data =
  await dynamicLinks.getInitialLink();
  final Uri? deepLink = data?.link;
  print(deepLink);
  if (deepLink != null) {
    try {
      String name = deepLink.queryParameters['bookingId'] ?? "";
      if (deepLink.pathSegments.isNotEmpty) {
        Get.to(InitialLinkAccess(bId: name,));
      }
    } catch (e) {
      debugPrint(e.toString());
    }


    // FirebaseDynamicLinks.getInitialLInk does a call to firebase to get us the real link because we have shortened it.
    var link = await FirebaseDynamicLinks.instance.getInitialLink();
    print(link);

    // This link may exist if the app was opened fresh so we'll want to handle it the same way onLink will.
    if (link != null) {
      handleLinkData(link);
    }
    // This will handle incoming links if the application is already opened
    FirebaseDynamicLinks.instance.onLink;
  }
  else{
    navigateToScreen();
    _requestPermissions();
  }
}
//If app is resume in backGround
Future<String> initDynamicLinks() async {
  print("Deep Linking when app is inn background");

  dynamicLinks.onLink.listen((dynamicLinkData) async {
    print("onListen");
    print(dynamicLinkData.link);
    print(dynamicLinkData.android);
    print(dynamicLinkData.ios);
    print(dynamicLinkData.utmParameters);
    print(dynamicLinkData.link.path);

    final Uri uri = dynamicLinkData.link;
    final queryParams = uri.queryParameters;
    print(uri);
    print(queryParams['bookingId']);
    bookingId=queryParams['bookingId'].toString();

    if (queryParams.isNotEmpty) {
      print("bookingID=>"+bookingId.toString());
      Get.to(InitialLinkAccess(bId: bookingId,));
    } else {
      Get.offAll(MainPageScreen());
    }

    //If app is shutDown
    final PendingDynamicLinkData? data =
    await dynamicLinks.getInitialLink();
    final Uri? deepLink = data?.link;
    print(deepLink);
    if (deepLink != null) {
      try {
        String name = deepLink.queryParameters['bookingId'] ?? "";
        if (deepLink.pathSegments.isNotEmpty) {
          Get.to(InitialLinkAccess(bId: name,));
        }
      } catch (e) {
        debugPrint(e.toString());
      }

    }

  }).onError((error) {
    print('onLink error');
    print(error.message);
  });
  return bookingId;
}

void handleLinkData(PendingDynamicLinkData data) {
  final Uri? uri = data?.link;
  if(uri != null) {
    final queryParams = uri.queryParameters;
    if(queryParams.length > 0) {
      String? bookingId = queryParams["bookingId"];
      // verify the username is parsed correctly
      Get.to(Filters());
      print("My users username is: $bookingId");
    }
  }
}
navigateToScreen() async {
  await Future.delayed(Duration(seconds: 2), () {
    Get.offAll(MainPageScreen());
  });
}
Future<void> _requestPermissions() async {
  if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  } else if (Platform.isAndroid) {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    final bool? granted = await androidImplementation?.requestPermission();
  }
}

Gradient? backShadowContainer(){
  return LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
  Colors.black.withOpacity(.0),
  Colors.black.withOpacity(.7),
  ]);
}
