import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:get/get.dart';
import '../../commonModule/AppColor.dart';
import '../../commonModule/Constant.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../commonModule/widget/search/customButton.dart';
import '../../controller/commonController.dart';
import 'package:http/http.dart'as http;
import '../../commonModule/utils.dart';


class BottomSheetForgotPassword extends StatefulWidget {
  const BottomSheetForgotPassword({Key? key}) : super(key: key);

  @override
  State<BottomSheetForgotPassword> createState() => _BottomSheetForgotPasswordState();
}

class _BottomSheetForgotPasswordState extends State<BottomSheetForgotPassword> {
  TextEditingController emailcontroller = TextEditingController();

  CommonController cx = Get.put(CommonController());
  final GlobalKey<FormState> forgotPassFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          height: size.height / 3.8,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(cx.height / 13.34),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                left: cx.height / 33.5, right: cx.height / 44.47),
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                Gap(cx.height / 22.23),
                SenticText(
                  textAlign: TextAlign.center,
                  text: 'Recover',
                  fontSize: cx.height > 800 ? 32 : 28,
                  fontWeight: FontWeight.w500,
                ),
                Gap(cx.height / 95.29),
                NunitoText(
                  textAlign: TextAlign.center,
                  text: "Please enter your email so we can send",
                  fontWeight: FontWeight.w400,
                  fontSize: cx.height > 800 ? 19 : 17,
                  color: Color(0xFF6F6B6B),
                ),
                NunitoText(
                  textAlign: TextAlign.center,
                  text: " you a temporary password",
                  fontWeight: FontWeight.w400,
                  fontSize: cx.height > 800 ? 19 : 17,
                  color: Color(0xFF6F6B6B),
                ),
                Gap(cx.height / 22.23),
                Form(
                  key: forgotPassFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailcontroller,
                        cursorColor: Color(0xFF628477),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                          fontSize: cx.height > 800 ? 19 : 17,
                          color: AppColor.darkGreen,
                        ),
                        decoration: InputDecoration(
                          fillColor: AppColor.bg,
                          // hintText: Constant.Location==""?"Search Dome":'${Constant.Location}',
                          hintText: "Enter Email",
                          hintStyle: TextStyle(
                            fontSize: cx.height > 800 ? 17 : 15,
                            color: Color(0xFF628477),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(cx.height / 6.67),
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
                        validator: (value){
                          String pattern =
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                          RegExp regex = RegExp(pattern);
                          if (value == null || value.isEmpty || !regex.hasMatch(value)) {
                            return "Please Enter Valid Email";
                          }
                          else{
                            return null;
                          }
                        },
                      ),
                      Gap(cx.height / 4.25),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: cx.responsive(33,25, 20),
                          right: cx.responsive(28,20, 15),
                          left:cx.responsive(28,15,10),
                        ),
                        child: Container(
                          height: cx.responsive(cx.height/10,cx.height/10,cx.height/11),
                          width: cx.width / 1.4,
                          child: CustomButton(
                            text: "Send",
                            fun:  () {
                              if(forgotPassFormKey.currentState!.validate()){
                                forgot();
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
                Gap(cx.height/20),

              ],
            ),
          ),
        ),
      ],
    );
  }
  Duration du = const Duration(seconds: 3);



  // loadingAlert(context) {
  //     Alert(
  //       style: AlertStyle(
  //         buttonsDirection: ButtonsDirection.column,
  //         alertBorder: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20.0),
  //           side: BorderSide(
  //             color: Color(0xFF9BD9C1),
  //             width: 2.5,
  //
  //           ),
  //         ),
  //
  //         alertElevation: 100,
  //         isButtonVisible: false
  //
  //       ),
  //         context: context,
  //         content: Column(
  //           children: <Widget>[
  //             Gap(cx.height/18),
  //
  //             CircularProgressIndicator(),
  //             Gap(cx.height/44.47),
  //             Text(
  //               "Loading...",
  //               style: TextStyle(
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: cx.height > 800 ? 25 : 22,
  //                 color: Color(0xFF222222),
  //               ),
  //             ),
  //             // Gap(cx.height/41),
  //             //
  //             // Text(
  //             //   "Please check your email to reset your password",
  //             //   textAlign: TextAlign.center,
  //             //   style: TextStyle(
  //             //     fontWeight: FontWeight.w400,
  //             //     fontSize: cx.height > 800 ? 20 : 18,
  //             //     color: Color(0xFF757575),
  //             //   ),
  //             //   overflow: TextOverflow.clip,
  //             // ),
  //             // Gap(cx.height/40),
  //
  //           ],
  //         ),
  //         closeIcon: Container(
  //           height: cx.height/44.47,
  //         ),
  //
  //         useRootNavigator: false,
  //     ).show();
  // Timer(du, () {
  //   Get.back();
  // });
  //
  // }


  Future forgot() async {

    onAlert(context: context,type: 1,msg: "Loading...");
    try {
      var request = http.MultipartRequest('POST', Uri.parse(Constant.forgotpass));
      request.fields.addAll({
        'email': emailcontroller.text,
      });

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (jsonBody['status'] == 1) {
        onAlert(context: context,type: 2,msg: jsonBody['message']);
        print(jsonBody.toString());
        Timer(du, () {
          Get.back();
        });
        //
      } else {
        onAlert(context: context,type: 3,msg: jsonBody['message']);
        print(jsonBody);
      }
    } catch (e) {

      if (e is SocketException) {
        showLongToast("Could not connect to internet!!");
      }
    }
  }

}
