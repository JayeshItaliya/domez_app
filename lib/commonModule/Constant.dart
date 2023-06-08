import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:domez/commonModule/AppColor.dart';
import 'package:domez/commonModule/widget/search/customButton.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:gap/gap.dart';
import 'package:domez/commonModule/widget/common/textNunito.dart';
import 'package:domez/screens/authPage/signIn.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

import '../controller/bookingDetailsController.dart';
import '../controller/commonController.dart';
import '../main_page.dart';
import '../service/getAPI.dart';


class Constant {
  static const String stripePublishableKey = "pk_live_51LlAvQFysF0okTxJhOBTwVLwJpgRBlURYPJP5qrk0EvXKuivpbCD8wIBqCJMpnxQny54dCghUwUNMNDa35b7WoQb00VV8tfzP1";
  static const String stripeSecretKey = "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";
  static const String mapkey = "AIzaSyCvlZaKvRSMouyH9pDgGC6pMGADfytOrsA";



  //POST API
  static Brightness? deviceBrightness = Platform.isIOS?Brightness.light:Brightness.dark;
  static const String perPage = "10";
  // static const String baseUrl = "http://192.168.0.124/domez_backend/api/";



  // static const String baseUrl = "http://52.22.227.137/api/";
  static const String baseUrl="https://domez.io/api/";
  static const String dummyProfileUrl ="https://www.domez.io/storage/app/public/admin/images/profiles/default.png";
  static String fcmToken = "";
  static const String pushNotification = "${baseUrl}pushnotification";

  static const String signUp = "${baseUrl}sign-up";
  static const String verify = "${baseUrl}verify";
  static const String signIn = "${baseUrl}sign-in";
  static const String helpcenter = "${baseUrl}helpcenter";
  static const String editProfile = "${baseUrl}editprofile";
  static const String googleSignIn = "${baseUrl}google-login";
  static const String facebookSignIn = "${baseUrl}facebook-login";
  static const String appleSignIn = "${baseUrl}apple-login";
  static const String ressendOtp = "${baseUrl}resend-otp";
  static const String forgotpass = "${baseUrl}forgot-password";
  static const String changepassword = "${baseUrl}change-password";
  static const String deleteAccount = "${baseUrl}delete-account";
  static const String cancelAccount = "${baseUrl}booking-cancel";

  static const String review = "${baseUrl}review";


  static const String search = "${baseUrl}search?page=";
  static const String filter = "${baseUrl}filter";

  static const String categoryList = "${baseUrl}sportslist";
  static const String favourite = "${baseUrl}favourite";
  static const String favouriteList = "${baseUrl}favourite-list";
  static const String bookingList = "${baseUrl}booking-list";
  static const String bookingDetails = "${baseUrl}booking-details-";
  static const String payment = "${baseUrl}payment";
  static const String splitPayment = "${baseUrl}split-payment";
  static const String ratingsList = "${baseUrl}rattinglist-";

  static const String domesList = "${baseUrl}domes-list";
  static const String domesDetails = "${baseUrl}dome-details-";
  static const String getTimeSlots = "${baseUrl}timeslots";
  static const String availableFields = "${baseUrl}available-fields";
  static const String requestDomez = "${baseUrl}dome-request";

  static const String leaguesList = "${baseUrl}leagues-list";
  static const String leagueDetails = "${baseUrl}league-details-";

  static const String getStripeKey = "${baseUrl}stripe-key";

  static const String cmsPages = "https://domez.io/cms-pages";

  static int signUpotp = 0;
  static const String termsUrl = "https://domez.io/terms-conditions";
  static const String privacyUrl = "https://domez.io/privacy-policy";
  static const String cancelUrl = "https://domez.io/cancellation-policies";
  static const String refundUrl = "https://domez.io/refund-policies";

  static String kUriPrefix = 'https://domez.page.link';
  static const String linkBookingId = '33';
  // static String kHomepageLink = '/homepage';
  // static String kProductpageLink = '/productpage?id=24';


}
//User Details

CommonController cx = Get.put(CommonController());

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
            Get.off(SignIn(curIndex: 4));
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

Future cancelAccount(
    {required BuildContext context, required String bookingId}) async {
  onAlert(context: context, type: 1, msg: "Loading...");

  try {
    print(Constant.cancelAccount);

    var request =
        http.MultipartRequest('POST', Uri.parse(Constant.cancelAccount));
    request.fields.addAll({
      'booking_id': bookingId.toString(),
    });
    print(request.fields.toString());

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    final jsonBody = await jsonDecode(respStr);

    if (jsonBody['status'] == 1) {
      print(jsonBody.toString());

      onAlert(
          context: context,
          type: 2,
          msg: "Booking has been Cancelled Successfully");
    } else {
      onAlert(
          context: context,
          type: 3,
          msg: "Oops! We Are Unable To Cancel Your Booking");
      print(jsonBody);
    }
  } catch (e) {
    print(e.toString());
    if (e is SocketException) {
      showLongToast("Could not connect to internet!!");
    }
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
                WonderEvents(),
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
                            text: "domeapp/payment",
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
                  maxLength: 150,
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
      print(result);
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

// double responsiveFont(double value){
//   double fSize=(cx.width*value)/375;
//
//   return fSize;
// }