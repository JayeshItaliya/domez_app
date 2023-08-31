import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../commonModule/AppColor.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/utils.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../commonModule/widget/common/webView.dart';
import '../../commonModule/widget/search/customButton.dart';
import '../../controller/commonController.dart';
import '../../main_page.dart';
import '../../service/getAPI.dart';
import '../authPage/signIn.dart';

class BottomSheetSignUp extends StatefulWidget {
  final int curIndex;
  int noOfPopTime;

  BottomSheetSignUp({Key? key, this.noOfPopTime = -1, required this.curIndex})
      : super(key: key);

  @override
  State<BottomSheetSignUp> createState() => _BottomSheetSignUpState();
}

class _BottomSheetSignUpState extends State<BottomSheetSignUp> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  TextEditingController confirmpasscontroller = TextEditingController();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  bool isloading = false;
  Map _userObj = {};
  CommonController cx = Get.put(CommonController());
  bool isLoggedInGoogle = false;
  String? name;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  bool fav = false;
  bool emailCorrect = false;
  TextEditingController bottomEmailController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> bottomEmailKey = GlobalKey<FormState>();

  String thisText = "";
  String countryCode = "";
  String twodigitcountryCode = 'CA';
  int pinLength = 4;
  bool hasError = false;
  bool isconfirm = true;
  bool isprocessing = false;
  bool isuccessful = false;
  bool isfailed = false;
  bool checkedValue = false;
  bool termsError = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: size.height / 3.8,
        ),
        Container(
          // height: size.height*2.2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(cx.height / 13.34),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                left: cx.height / 33.5, right: cx.height / 44.47),
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: [
                Gap(cx.height / 22.23),
                SenticText(
                  textAlign: TextAlign.center,
                  text: 'Sign Up',
                  fontSize: cx.height > 800 ? 32 : 28,
                  fontWeight: FontWeight.w500,
                ),
                Gap(cx.height / 95.29),
                NunitoText(
                  textAlign: TextAlign.center,
                  text: "Create your new account",
                  fontWeight: FontWeight.w400,
                  fontSize: cx.height > 800 ? 19 : 17,
                  color: Color(0xFF6F6B6B),
                ),
                Gap(cx.height / 22.23),
                Form(
                  key: signUpFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: namecontroller,
                        cursorColor: Color(0xFF628477),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: cx.height > 800 ? 19 : 17,
                          color: AppColor.darkGreen,
                        ),
                        decoration: InputDecoration(
                          fillColor: AppColor.bg,
                          // hintText: Constant.Location==""?"Search Dome":'${Constant.Location}',
                          hintText: "Enter Name",
                          hintStyle: TextStyle(
                            fontSize: cx.height > 800 ? 17 : 15,
                            color: Color(0xFF628477),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),

                          filled: true,
                          contentPadding: EdgeInsets.fromLTRB(
                            cx.height / 26.68,
                            cx.height / 41.69,
                            0,
                            cx.height / 41.69,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Full Name";
                          }
                          return null;
                        },
                      ),
                      Gap(cx.height / 44.47),
                      TextFormField(
                        controller: emailcontroller,
                        textInputAction: TextInputAction.next,
                        cursorColor: Color(0xFF628477),
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontSize: cx.height > 800 ? 19 : 17,
                          color: AppColor.darkGreen,
                        ),
                        decoration: InputDecoration(
                          fillColor: AppColor.bg,
                          // hintText: Constant.Location==""?"Search Dome":'${Constant.Location}',
                          hintText: "abc@xyz.com",
                          hintStyle: TextStyle(
                            fontSize: cx.height > 800 ? 17 : 15,
                            color: Color(0xFF628477),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),

                          filled: true,
                          contentPadding: EdgeInsets.fromLTRB(
                            cx.height / 26.68,
                            cx.height / 41.69,
                            0,
                            cx.height / 41.69,
                          ),
                        ),
                        onChanged: (value) {
                          // debugPrint("Searching Domes");
                          // if (value.isNotEmpty) {
                          //   autoCompleteSearch(value);
                          // } else {
                          //   if (predictions.length > 0 && mounted) {
                          //     setState(() {
                          //       predictions = [];
                          //     });
                          //   }
                          // }
                        },
                        validator: (value) {
                          String pattern =
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                          RegExp regex = RegExp(pattern);
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Email Address";
                          } else if (!regex.hasMatch(value)) {
                            return "Please Enter Valid Email";
                          } else {}
                          return null;
                        },
                      ),
                      Gap(cx.height / 44.47),
                      IntlPhoneField(
                        textInputAction: TextInputAction.next,
                        obscureText: false,
                        controller: mobilecontroller,
                        flagsButtonPadding: EdgeInsets.all(10),
                        style: TextStyle(
                          fontSize: cx.height > 800 ? 19 : 17,
                          color: AppColor.darkGreen,
                        ),
                        cursorColor: AppColor.darkGreen,
                        dropdownTextStyle: TextStyle(
                          fontSize: cx.height > 800 ? 16 : 14,
                          color: AppColor.darkGreen,
                        ),
                        dropdownIcon: Icon(
                          Icons.arrow_drop_down_outlined,
                          size: 30,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.fromLTRB(
                            cx.responsive(35, 30, 26),
                            cx.responsive(22, 18, 16),
                            cx.responsive(35, 30, 26),
                            cx.responsive(22, 18, 16),
                          ),
                          filled: true,
                          fillColor: AppColor.bg,
                          hintText: "Phone Number",
                          hintStyle: TextStyle(
                            fontSize: cx.height > 800 ? 17 : 15,
                            color: Color(0xFF628477),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFFD53E3E),
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFFD53E3E),
                            ),
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        invalidNumberMessage: "Please Enter Valid Length",
                        initialCountryCode: 'CA',
                        onCountryChanged: (country) {
                          setState(() {
                            twodigitcountryCode = country.code;
                            countryCode = country.dialCode;
                          });
                        },
                      ),
                      Gap(cx.height / 44.47),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        // obscuringCharacter: '●',
                        obscureText: hidePassword ? true : false,
                        controller: passcontroller,
                        cursorColor: Color(0xFF628477),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: cx.height > 800 ? 19 : 17,
                          color: AppColor.darkGreen,
                        ),
                        decoration: InputDecoration(
                          fillColor: AppColor.bg,
                          // hintText: Constant.Location==""?"Search Dome":'${Constant.Location}',
                          hintText: "Enter Password",
                          hintStyle: TextStyle(
                            fontSize: cx.height > 800 ? 17 : 15,
                            color: Color(0xFF628477),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                            child: hidePassword
                                ? Icon(Icons.visibility_rounded)
                                : Icon(Icons.visibility_off_rounded),
                          ),

                          filled: true,
                          contentPadding: EdgeInsets.fromLTRB(
                            cx.height / 26.68,
                            cx.height / 41.69,
                            0,
                            cx.height / 41.69,
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return "Please Enter Valid Password";
                          } else if (value.length < 8) {
                            return "Password must be greater than or equal to 8 char";
                          } else {
                            return null;
                          }
                        },
                      ),
                      Gap(cx.height / 44.47),
                      TextFormField(
                        obscureText: hideConfirmPassword ? true : false,
                        textInputAction: TextInputAction.next,
                        // obscuringCharacter: '●',
                        controller: confirmpasscontroller,
                        cursorColor: Color(0xFF628477),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: cx.height > 800 ? 19 : 17,
                          color: AppColor.darkGreen,
                        ),
                        decoration: InputDecoration(
                          fillColor: AppColor.bg,
                          // hintText: Constant.Location==""?"Search Dome":'${Constant.Location}',
                          hintText: "Confirm Password",
                          hintStyle: TextStyle(
                            fontSize: cx.height > 800 ? 17 : 15,
                            color: Color(0xFF628477),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                hideConfirmPassword = !hideConfirmPassword;
                              });
                            },
                            child: hideConfirmPassword
                                ? Icon(Icons.visibility_rounded)
                                : Icon(Icons.visibility_off_rounded),
                          ),
                          filled: true,

                          contentPadding: EdgeInsets.fromLTRB(
                            cx.height / 26.68,
                            cx.height / 41.69,
                            0,
                            cx.height / 41.69,
                          ),
                        ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Valid Confirm Password";
                          } else if (value != passcontroller.text) {
                            print(value);
                            print(passcontroller.text);
                            return "Password and confirm password must be same";
                          } else if (value.length < 8) {
                            return "Password must be greater than or equal to 8 char";
                          } else {
                            return null;
                          }
                        },
                      ),
                      Gap(cx.height / 44.47),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Checkbox(
                                  value: checkedValue,
                                  fillColor: MaterialStateProperty.all(
                                      checkedValue
                                          ? AppColor.darkGreen
                                          : Colors.transparent),
                                  side: BorderSide(
                                      color: termsError
                                          ? Color(0xFFD32F2F)
                                          : AppColor.darkGreen),
                                  onChanged: (value) {
                                    setState(() {
                                      checkedValue = !checkedValue;
                                      print(checkedValue);
                                    });
                                  }),
                              Container(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        NunitoText(
                                          textAlign: TextAlign.center,
                                          text: "By signing in you agree ",
                                          fontWeight: FontWeight.w400,
                                          fontSize: cx.height > 800 ? 17 : 15,
                                          color: Color(0xFFB9B6B6),
                                        ),
                                        // NunitoText(
                                        //   textAlign: TextAlign.center,
                                        //   text: "agree ",
                                        //   fontWeight: FontWeight.bold,
                                        //   fontSize: cx.height > 800 ? 17 : 15,
                                        //   color: Color(0xFFB9B6B6),
                                        // ),
                                        NunitoText(
                                          textAlign: TextAlign.center,
                                          text: "to our",
                                          fontWeight: FontWeight.w400,
                                          fontSize: cx.height > 800 ? 17 : 15,
                                          color: Color(0xFFB9B6B6),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.to(WebViewClass("Terms Of Use",
                                                Constant.termsUrl));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2.0),
                                            child: NunitoText(
                                              textAlign: TextAlign.center,
                                              text: "Terms Of Use",
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  cx.height > 800 ? 17 : 15,
                                              color: Color(0xFFB9B6B6),
                                            ),
                                          ),
                                        ),
                                        NunitoText(
                                          textAlign: TextAlign.start,
                                          text: " and ",
                                          fontWeight: FontWeight.w400,
                                          fontSize: cx.height > 800 ? 18 : 16,
                                          color: Color(0xFFB9B6B6),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.to(WebViewClass(
                                                "Privacy Policy",
                                                Constant.privacyUrl));
                                          },
                                          child: NunitoText(
                                            textAlign: TextAlign.center,
                                            text: "Privacy Policy",
                                            fontWeight: FontWeight.bold,
                                            fontSize: cx.height > 800 ? 18 : 16,
                                            color: Color(0xFFB9B6B6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Gap(cx.height / 100),
                          NunitoText(
                            text: "        Please Check Terms and Condition",
                            fontSize: cx.responsive(15, 13, 12.5),
                            color: termsError
                                ? Color(0xFFD32F2F)
                                : Colors.transparent,
                          ),
                        ],
                      ),
                      Gap(cx.height / 25.65),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: cx.responsive(33, 25, 20),
                          right: cx.responsive(27, 20, 15),
                          left: cx.responsive(23, 15, 10),
                        ),
                        child: Container(
                          height: cx.responsive(cx.height / 13.8,
                              cx.height / 13.8, cx.height / 12.13),
                          width: cx.width / 1.25,
                          child: CustomButton(
                            text: "Sign Up",
                            fun: () {
                              if (signUpFormKey.currentState!.validate() &&
                                  checkedValue) {
                                signUp();
                              } else {
                                if (!checkedValue) {
                                  setState(() {
                                    termsError = true;
                                  });
                                } else {
                                  setState(() {
                                    termsError = false;
                                  });
                                }
                              }
                            },
                            color: AppColor.darkGreen,
                            radius: cx.height / 11.17,
                            width: cx.width / 4,
                            size: cx.responsive(23, 19, 15),
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(cx.height / 66.7),
                Padding(
                  padding: EdgeInsets.only(
                    left: cx.responsive(12, 10, 9),
                    right: cx.responsive(12, 10, 9),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: DottedLine(
                          dashLength: 10,
                          dashColor: Color(0xFFD6D6D6),
                          lineThickness: 1.7,
                          lineLength: cx.responsive(
                              cx.height / 7.2, cx.height / 7.2, cx.height / 6),
                        ),
                      ),
                      NunitoText(
                        text: "OR",
                        fontWeight: FontWeight.w500,
                        fontSize: cx.height > 800 ? 21 : 18,
                        color: Color(0xFFD6D6D6),
                      ),
                      Flexible(
                        child: DottedLine(
                          dashLength: 10,
                          dashColor: Color(0xFFD6D6D6),
                          lineThickness: 1.7,
                          lineLength: cx.responsive(
                              cx.height / 7.2, cx.height / 7.2, cx.height / 6),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(cx.height / 38),
                NunitoText(
                  textAlign: TextAlign.center,
                  text: "Sign up with",
                  fontWeight: FontWeight.w700,
                  fontSize: cx.height > 800 ? 19 : 17,
                  color: Color(0xFF757575),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Image.asset(
                        'assets/images/google.png',
                        scale: 2.1,
                      ),
                      onTap: () {
                        googleSignin();
                      },
                    ),
                    Platform.isIOS
                        ? InkWell(
                            child: Image.asset(
                              'assets/images/apple.png',
                              scale: 2.1,
                            ),
                            onTap: () async {
                              final appleIdCredential =
                                  await SignInWithApple.getAppleIDCredential(
                                scopes: [
                                  AppleIDAuthorizationScopes.email,
                                  AppleIDAuthorizationScopes.fullName,
                                ],
                                webAuthenticationOptions:
                                    WebAuthenticationOptions(
                                  // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
                                  clientId:
                                      'de.lunaone.flutter.signinwithappleexample.service',

                                  redirectUri:
                                      // For web your redirect URI needs to be the host of the "current page",
                                      // while for Android you will be using the API server that redirects back into your app via a deep link
                                      // kIsWeb
                                      //     ? Uri.parse('https://${window.location.host}/')
                                      //     :
                                      Uri.parse(
                                    'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                                  ),
                                ),
                                // TODO: Remove these if you have no need for them
                                // nonce: 'example-nonce',
                                // state: 'example-state',
                              );

                              final credential =
                                  OAuthProvider('apple.com').credential(
                                idToken: appleIdCredential.identityToken,
                                accessToken:
                                    appleIdCredential.authorizationCode,
                                // rawNonce: 'example-nonce'
                              );
                              await FirebaseAuth.instance
                                  .signInWithCredential(credential);

                              // ignore: avoid_print
                              print(FirebaseAuth.instance.currentUser);

                              print("credential2");
                              print(appleIdCredential);
                              print(appleIdCredential.identityToken);
                              print(appleIdCredential.email);
                              print(appleIdCredential.authorizationCode);
                              print(appleIdCredential.familyName);
                              print(appleIdCredential.givenName);
                              print(appleIdCredential.userIdentifier);

                              print(credential);

                              final userData =
                                  FirebaseAuth.instance.currentUser;

                              TaskProvider.appleSignInAPI(
                                  email: userData?.providerData[0].email
                                              .toString() !=
                                          null
                                      ? userData?.email.toString()
                                      : "",
                                  // name: userData?.displayName.toString()!=null?userData?.displayName.toString():"",
                                  name: userData?.providerData[0].displayName
                                              .toString() !=
                                          null
                                      ? userData?.providerData[0].displayName
                                          .toString()
                                      : "",
                                  phone: userData?.providerData[0].phoneNumber
                                              .toString() !=
                                          null
                                      ? userData?.phoneNumber.toString()
                                      : "",
                                  uid: userData?.providerData[0].uid
                                              .toString() !=
                                          null
                                      ? userData?.uid.toString()
                                      : "",
                                  context: context,
                                  curIndex: widget.curIndex,
                                  noOfPopTime: widget.noOfPopTime);

                              // This is the endpoint that will convert an authorization code obtained
                              // via Sign in with Apple into a session in your system
                              final signInWithAppleEndpoint = Uri(
                                scheme: 'https',
                                host:
                                    'flutter-sign-in-with-apple-example.glitch.me',
                                path: '/sign_in_with_apple',
                                queryParameters: <String, String>{
                                  'code': appleIdCredential.authorizationCode,
                                  if (appleIdCredential.givenName != null)
                                    'firstName': appleIdCredential.givenName!,
                                  if (appleIdCredential.familyName != null)
                                    'lastName': appleIdCredential.familyName!,
                                  'useBundleId': !kIsWeb &&
                                          (Platform.isIOS || Platform.isMacOS)
                                      ? 'true'
                                      : 'false',
                                  if (appleIdCredential.state != null)
                                    'state': appleIdCredential.state!,
                                },
                              );

                              final session = await http.Client().post(
                                signInWithAppleEndpoint,
                              );

                              // If we got this far, a session based on the Apple ID credential has been created in your system,
                              // and you can now set this as the app's session
                              // ignore: avoid_print
                              print("session");
                              print(session);
                              print(session.body);
                              print(session.contentLength);
                              print(session.request);
                              print(session.persistentConnection);
                              print(session.reasonPhrase);
                              print(session.headers);
                            },
                          )
                        : Container(),
                    InkWell(
                      onTap: () async {
                        FacebookAuth.instance.login(permissions: [
                          "public_profile",
                          "email"
                        ]).then((value) {
                          FacebookAuth.instance
                              .getUserData()
                              .then((userData) async {
                            setState(() {
                              _userObj = userData;
                            });
                            TaskProvider.facebooSignInAPI(
                                image: _userObj['picture']['data']['url'],
                                name: _userObj['name'],
                                email: _userObj['email'],
                                uid: _userObj['id'],
                                context: context,
                                curIndex: widget.curIndex,
                                noOfPopTime: widget.noOfPopTime);
                          });
                        });
                      },
                      child: Image.asset(
                        'assets/images/facebook.png',
                        scale: 2.1,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NunitoText(
                      textAlign: TextAlign.center,
                      text: "Already have an account? ",
                      fontWeight: FontWeight.w400,
                      fontSize: cx.height > 800 ? 18 : 16,
                      color: Color(0xFFA8A8A8),
                    ),
                    InkWell(
                      onTap: () {
                        Get.off(
                            SignIn(
                              curIndex: widget.curIndex,
                              noOfPopTime: widget.noOfPopTime,
                            ),
                            transition: Transition.rightToLeft);
                      },
                      child: NunitoText(
                        textAlign: TextAlign.center,
                        text: " Sign In",
                        fontWeight: FontWeight.bold,
                        fontSize: cx.height > 800 ? 18 : 16,
                        color: AppColor.darkGreen,
                      ),
                    ),
                  ],
                ),
                Gap(cx.height / 9),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void signUp() async {
    onAlert(context: context, type: 1, msg: "Loading...");

    try {
      print(mobilecontroller.text + countryCode);
      var request = http.MultipartRequest('POST', Uri.parse(Constant.signUp));
      request.fields.addAll({
        'email': emailcontroller.text,
        'name': namecontroller.text,
        'phone': countryCode + mobilecontroller.text,
        'countrycode': twodigitcountryCode,
        'password': passcontroller.text,
        'cpassword': confirmpasscontroller.text,
        'fcm_token': Constant.fcmToken.isEmpty ? "test" : Constant.fcmToken,
      });

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      if (jsonBody['status'] == 1) {
        setState(() {
          print(jsonBody.toString());
          Constant.signUpotp = jsonBody['userdata']['otp'];

          isconfirm = true;
          isprocessing = true;
          isfailed = false;
          isuccessful = false;
        });

        onAlert(context: context, type: 2, msg: jsonBody['message']);

        Timer(du, () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => emailVerifyDialog());
        });
        // Get.back();
      } else {
        onAlert(context: context, type: 3, msg: jsonBody['message']);
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

  Widget emailVerifyDialog() {
    TextEditingController controller = TextEditingController(text: "");

    return StatefulBuilder(builder:
        (BuildContext context, StateSetter setState /*You can rename this!*/) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        //this right here
        insetPadding: EdgeInsets.zero,

        child: Container(
          height: cx.height / 1.97,
          width: cx.width / 1.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SenticText(
                  height: 1.2,
                  text: isconfirm
                      ? 'Please verify your email'
                      : isprocessing
                          ? "Email Verification"
                          : isuccessful
                              ? "Email Verification"
                              : isfailed
                                  ? "Email Verification"
                                  : "Email Verification",
                  fontSize: cx.height > 800 ? 20 : 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              Gap(cx.height / 50),
              Padding(
                padding: EdgeInsets.only(
                  left: 08.0,
                  right: 08.0,
                ),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    NunitoText(
                      textAlign: TextAlign.center,
                      text: isconfirm
                          ? 'An email has been sent to you at '
                          : isprocessing
                              ? "Enter The Four Digit Code That You"
                              : isuccessful
                                  ? "Enter The Four Digit Code That You"
                                  : isfailed
                                      ? "Enter The Four Digit Code That You"
                                      : "Enter The Four Digit Code That You",
                      fontWeight: FontWeight.w400,
                      fontSize: cx.height > 800 ? 16 : 14,
                      color: Color(0xFFA8A8A8),
                    ),
                    NunitoText(
                      textAlign: TextAlign.center,
                      text: isconfirm
                          ? emailcontroller.text
                          : "Received On Your Email",
                      fontWeight: isconfirm ? FontWeight.w500 : FontWeight.w700,
                      fontSize: cx.height > 800 ? 16 : 14,
                      color: Color(0xFFA8A8A8),
                    ),
                    NunitoText(
                      textAlign: TextAlign.center,
                      text: "with a verification code ",
                      fontWeight: FontWeight.w400,
                      fontSize: cx.height > 800 ? 16 : 14,
                      color: Color(0xFFA8A8A8),
                    ),
                  ],
                ),
              ),
              Gap(cx.height / 25),
              Theme(
                data: ThemeData(
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                ),
                child: GestureDetector(
                  // splashColor: Colors.white,
                  // splashFactory: NoSplash.splashFactory,
                  // onLongPress: _showSimpleDialog,
                  onLongPress: () async {
                    ClipboardData? data = await Clipboard.getData('text/plain');
                    print(data?.text);
                    if (data!.text!.toString().isNotEmpty) {
                      setState(() {
                        controller.text = data!.text.toString().substring(0, 4);
                      });

                      if (Constant.signUpotp.toString() == controller.text) {
                        Future verify() async {
                          setState(() {
                            isprocessing = true;
                            isconfirm = false;
                            isfailed = false;
                            isuccessful = false;
                          });
                          onAlert(context: context, type: 1, msg: "Loading...");

                          try {
                            var request = http.MultipartRequest(
                                'POST', Uri.parse(Constant.verify));
                            request.fields.addAll({
                              'email': emailcontroller.text,
                              'name': namecontroller.text,
                              'countrycode': twodigitcountryCode,
                              'phone': mobilecontroller.text,
                              'password': passcontroller.text,
                              'cpassword': confirmpasscontroller.text
                            });

                            final response = await request.send();
                            final respStr =
                                await response.stream.bytesToString();
                            final jsonBody = await jsonDecode(respStr);

                            if (jsonBody['status'] == 1) {
                              cx.write(
                                  'username', jsonBody['userdata']['name']);
                              cx.write(
                                  'useremail', jsonBody['userdata']['email']);
                              cx.write('phone', jsonBody['userdata']['phone']);
                              cx.write('countrycode',
                                  jsonBody['userdata']['countrycode']);
                              cx.write('image', jsonBody['userdata']['image']);
                              cx.write('id', jsonBody['userdata']['id']);
                              cx.write('islogin', true);
                              cx.write('isVerified', true);

                              cx.id.value = cx.read("id");
                              cx.email.value = cx.read("useremail");
                              cx.phone.value = cx.read("phone");
                              cx.countrycode.value = cx.read("countrycode");
                              cx.image.value = cx.read("image");
                              cx.isLogin.value = cx.read("islogin");
                              cx.name.value = cx.read("username");
                              cx.isVerified.value = cx.read("isVerified");
                              setState(() {
                                isuccessful = true;
                                isprocessing = false;
                                isconfirm = false;
                                isfailed = false;
                              });
                              print(jsonBody.toString());
                              onAlert(
                                  context: context,
                                  type: 2,
                                  msg: jsonBody['message']);
                              Duration du = const Duration(seconds: 3);

                              Timer(du, () {
                                if (widget.noOfPopTime != -1) {
                                  while (widget.noOfPopTime != 0) {
                                    widget.noOfPopTime--;
                                    Get.back();
                                  }
                                } else {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => MainPageScreen(
                                              curIndex: widget.curIndex,
                                            )),
                                    (Route<dynamic> route) => false,
                                  );
                                }
                              });
                            } else {
                              onAlert(
                                  context: context,
                                  type: 3,
                                  msg: jsonBody['message']);
                              print(jsonBody);
                            }
                          } catch (e) {
                            Get.back();
                            print(e.toString());
                            if (e is SocketException) {
                              showLongToast("Could not connect to internet");
                            }
                          }
                        }

                        verify();
                      } else {
                        setState(() {
                          isprocessing = false;
                          isconfirm = false;
                          isfailed = true;
                          isuccessful = false;
                        });
                      }
                      print("DONE CONTROLLER ${controller.text}");
                    }
                  },
                  child: PinCodeTextField(
                    autofocus: true,
                    controller: controller,
                    pinBoxColor: isfailed ? Color(0xFFFFEBEB) : AppColor.bg,
                    hideCharacter: false,
                    highlight: true,
                    highlightColor:
                        isfailed ? Color(0xFFC46464) : AppColor.darkGreen,
                    defaultBorderColor:
                        isfailed ? Color(0xFFFFC8C8) : AppColor.Green,
                    hasTextBorderColor:
                        isfailed ? Color(0xFFFFC8C8) : Colors.green,
                    // highlightPinBoxColor: isfailed?Color(0xFFFFEBEB):AppColor.bg,
                    maxLength: pinLength,
                    hasError: hasError,
                    onTextChanged: (text) {
                      setState(() {
                        print(text);
                        hasError = false;
                      });
                    },
                    onDone: (text) {
                      setState(() {
                        isprocessing = true;
                        isconfirm = false;
                        isfailed = false;
                        isuccessful = false;
                      });
                      print(Constant.signUpotp.toString());
                      print("DONE $text");
                      Timer(du, () {
                        if (Constant.signUpotp.toString() == text) {
                          Future verify() async {
                            setState(() {
                              isprocessing = true;
                              isconfirm = false;
                              isfailed = false;
                              isuccessful = false;
                            });
                            onAlert(
                                context: context, type: 1, msg: "Loading...");

                            try {
                              var request = http.MultipartRequest(
                                  'POST', Uri.parse(Constant.verify));
                              request.fields.addAll({
                                'email': emailcontroller.text,
                                'name': namecontroller.text,
                                'countrycode': twodigitcountryCode,
                                'phone': mobilecontroller.text,
                                'password': passcontroller.text,
                                'cpassword': confirmpasscontroller.text
                              });
                              print("query2");

                              final response = await request.send();
                              final respStr =
                                  await response.stream.bytesToString();
                              final jsonBody = await jsonDecode(respStr);

                              if (jsonBody['status'] == 1) {
                                print("query3");

                                cx.write(
                                    'username', jsonBody['userdata']['name']);
                                cx.write(
                                    'useremail', jsonBody['userdata']['email']);
                                cx.write(
                                    'phone', jsonBody['userdata']['phone']);
                                cx.write('countrycode',
                                    jsonBody['userdata']['countrycode']);
                                cx.write(
                                    'image', jsonBody['userdata']['image']);
                                cx.write('id', jsonBody['userdata']['id']);
                                cx.write('islogin', true);
                                cx.write('isVerified', true);

                                cx.id.value = cx.read("id");
                                cx.email.value = cx.read("useremail");
                                cx.phone.value = cx.read("phone");
                                cx.countrycode.value = cx.read("countrycode");
                                cx.image.value = cx.read("image");
                                cx.isLogin.value = cx.read("islogin");
                                cx.name.value = cx.read("username");
                                cx.isVerified.value = cx.read("isVerified");
                                setState(() {
                                  isuccessful = true;
                                  isprocessing = false;
                                  isconfirm = false;
                                  isfailed = false;
                                });
                                print(jsonBody.toString());
                                onAlert(
                                    context: context,
                                    type: 2,
                                    msg: jsonBody['message']);
                                Duration du = const Duration(seconds: 3);

                                Timer(du, () {
                                  Get.back();

                                  //Navigation from receipt
                                  if (widget.noOfPopTime == 99) {
                                    widget.noOfPopTime = 1;
                                    while (widget.noOfPopTime != 0) {
                                      widget.noOfPopTime--;
                                      Get.back(result: true);
                                    }
                                  } else if (widget.noOfPopTime != -1) {
                                    while (widget.noOfPopTime != 0) {
                                      widget.noOfPopTime--;
                                      Get.back();
                                    }
                                  } else {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => MainPageScreen(
                                                curIndex: widget.curIndex,
                                              )),
                                      (Route<dynamic> route) => false,
                                    );
                                  }
                                });
                              } else {
                                onAlert(
                                    context: context,
                                    type: 3,
                                    msg: jsonBody['message']);
                                print(jsonBody);
                              }
                            } catch (e) {
                              Get.back();
                              print(e.toString());
                              if (e is SocketException) {
                                showLongToast("Could not connect to internet");
                              }
                            }
                          }

                          verify();
                        } else {
                          setState(() {
                            isprocessing = false;
                            isconfirm = false;
                            isfailed = true;
                            isuccessful = false;
                          });
                        }
                      });
                      print("DONE CONTROLLER ${controller.text}");
                    },
                    pinBoxWidth: cx.width / 7,
                    pinBoxHeight: cx.height / 10.3,
                    hasUnderline: false,
                    wrapAlignment: WrapAlignment.spaceAround,
                    pinBoxDecoration: defaultPinBoxDecoration,
                    pinTextStyle: GoogleFonts.nunito(
                      fontSize: cx.responsive(55, 43, 33),
                      fontWeight: FontWeight.w800,
                      color: isfailed ? Color(0xFF9A5C5C) : Color(0xFF628477),
                      decorationStyle: TextDecorationStyle.solid,
                    ),

                    pinTextAnimatedSwitcherTransition:
                        ProvidedPinBoxTextAnimation.scalingTransition,
                    pinTextAnimatedSwitcherDuration:
                        Duration(milliseconds: 300),
                    highlightAnimationBeginColor: Colors.black,
                    highlightAnimationEndColor: Colors.white12,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              Gap(
                cx.height / 33.5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NunitoText(
                    textAlign: TextAlign.center,
                    text: "Didn't recieve the code?",
                    fontWeight: FontWeight.w500,
                    fontSize: cx.height > 800 ? 17 : 15,
                    color: Color(0xFFA8A8A8),
                  ),
                  InkWell(
                    onTap: () async {
                      onAlert(context: context, type: 1, msg: "Loading...");

                      try {
                        var request = http.MultipartRequest(
                            'POST', Uri.parse(Constant.ressendOtp));
                        request.fields.addAll({
                          'email': emailcontroller.text,
                          'name': namecontroller.text,
                        });

                        final response = await request.send();
                        final respStr = await response.stream.bytesToString();
                        final jsonBody = await jsonDecode(respStr);
                        if (jsonBody['status'] == 1) {
                          print(jsonBody.toString());
                          onAlert(
                              context: context,
                              type: 2,
                              msg: jsonBody['message']);

                          setState(() {
                            Constant.signUpotp = jsonBody['otp'];
                            print(Constant.signUpotp.toString());
                          });
                        } else {
                          onAlert(
                              context: context,
                              type: 3,
                              msg: jsonBody['message']);

                          print(jsonBody);
                        }
                      } catch (e) {
                        if (e is SocketException) {
                          showLongToast("Could not connect to internet");
                        }
                      }
                    },
                    child: NunitoText(
                      textAlign: TextAlign.center,
                      text: "Resend ",
                      fontWeight: FontWeight.w500,
                      fontSize: cx.height > 800 ? 17 : 15,
                      color: AppColor.darkGreen,
                    ),
                  ),
                ],
              ),
              Gap(
                cx.height / 28,
              ),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: cx.responsive(
                      cx.height / 11, cx.height / 11, cx.height / 10),
                  decoration: BoxDecoration(
                      color: isconfirm
                          ? Colors.black
                          : isprocessing
                              ? Color(0xFF468B8F)
                              : isuccessful
                                  ? Color(0xFF15812D)
                                  : isfailed
                                      ? Color(0xFFB01717)
                                      : Colors.black,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      isconfirm
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                              size: cx.responsive(42, 36, 32),
                            )
                          : isprocessing
                              ? CupertinoActivityIndicator(
                                  color: Colors.white,
                                  radius: cx.responsive(15, 14, 13),
                                )
                              : isuccessful
                                  ? SvgPicture.asset(
                                      "assets/svg/smile.svg",
                                      height: cx.responsive(33, 29, 27),
                                    )
                                  : isfailed
                                      ? SvgPicture.asset(
                                          "assets/svg/sad.svg",
                                          height: cx.responsive(33, 29, 27),
                                        )
                                      : Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: cx.responsive(42, 36, 32),
                                        ),
                      NunitoText(
                        textAlign: TextAlign.center,
                        text: isconfirm
                            ? "  Confirm"
                            : isprocessing
                                ? "  Processing"
                                : isuccessful
                                    ? "  Successful"
                                    : isfailed
                                        ? "  Failed"
                                        : "",
                        fontWeight: FontWeight.w700,
                        fontSize: cx.height > 800 ? 25 : 22,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Future<void> googleSignin() async {
    final googleSignIn = GoogleSignIn();
    final signInAccount = await googleSignIn.signIn();

    final googleAccountAuthentication = await signInAccount?.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAccountAuthentication?.accessToken,
        idToken: googleAccountAuthentication?.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);

    if (FirebaseAuth.instance.currentUser != null) {
      onAlert(context: context, type: 1, msg: "Loading...");

      print("Google Account success");
      print("${FirebaseAuth.instance.currentUser?.displayName} signed in");
      print("${FirebaseAuth.instance.currentUser?.toString()}");
      setState(() {
        name = FirebaseAuth.instance.currentUser?.displayName;
        cx.profilePicture.value = FirebaseAuth.instance.currentUser!.photoURL!;

        print(name);
        print(FirebaseAuth.instance.currentUser?.photoURL);
      });

      final userData = FirebaseAuth.instance.currentUser;
      TaskProvider.googleSignInAPI(
          email: userData?.providerData[0].email.toString() ?? "",
          name: userData?.providerData[0].displayName.toString() ?? "",
          phone: userData?.providerData[0].phoneNumber ?? "",
          uid: userData?.providerData[0].uid.toString() ?? "",
          is_verified: userData?.emailVerified.toString() ?? "",
          image: userData?.providerData[0].photoURL.toString() ?? "",
          context: context,
          curIndex: widget.curIndex,
          noOfPopTime: widget.noOfPopTime);
    } else {
      onAlert(context: context, type: 3, msg: "Google SignIn Failed");

      print("Unable to sign in");
    }
  }

  void showCustomDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 240,
            child: SizedBox.expand(child: FlutterLogo()),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(40)),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  static PinBoxDecoration defaultPinBoxDecoration = (
    Color borderColor,
    Color pinBoxColor, {
    double borderWidth = 1.0,
    double radius = 25.0,
  }) {
    return BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 0.4,
        ),
        color: pinBoxColor,
        borderRadius: BorderRadius.circular(10));
  };
}
