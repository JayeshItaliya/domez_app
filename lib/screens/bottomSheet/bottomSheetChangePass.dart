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
import 'package:http/http.dart' as http;



class BottomSheetChangePass extends StatefulWidget {
  const BottomSheetChangePass({Key? key}) : super(key: key);

  @override
  State<BottomSheetChangePass> createState() => _BottomSheetChangePassState();
}

class _BottomSheetChangePassState extends State<BottomSheetChangePass> {

  TextEditingController oldpasscontroller = TextEditingController();
  TextEditingController newpasscontroller = TextEditingController();
  TextEditingController confirmpasscontroller = TextEditingController();
  final GlobalKey<FormState> ChangePassFormKey = GlobalKey<FormState>();
  bool isloading = false;
  CommonController cx = Get.put(CommonController());
  bool isLoggedInGoogle = false;
  String? name;


  bool fav = false;
  bool emailCorrect = false;

  String thisText = "";
  int pinLength = 4;
  bool hasError = false;
  bool isconfirm = true;
  bool isprocessing = false;
  bool isuccessful = false;
  bool isfailed = false;
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
          // height: size.height*2.2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(cx.height / 13.34),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                left: cx.height / 33.5, right: cx.height / 44.47),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: [
                Gap(cx.height / 22.23),

                SenticText(
                  textAlign: TextAlign.center,
                  text: 'Change Password',
                  fontSize: cx.height > 800 ? 32 : 28,
                  fontWeight: FontWeight.w500,
                ),
                Gap(cx.height / 95.29),
                NunitoText(
                  textAlign: TextAlign.center,
                  text: "Replace Your Old Password",
                  fontWeight: FontWeight.w400,
                  fontSize: cx.height > 800 ? 19 : 17,
                  color: Color(0xFF6F6B6B),
                ),
                Gap(cx.height / 22.23),
                Form(
                  key:ChangePassFormKey,
                  child: Column(
                    children: [

                      TextFormField(
                        controller: oldpasscontroller,
                        cursorColor: Color(0xFF628477),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: cx.height > 800 ? 19 : 17,
                          color: AppColor.darkGreen,
                        ),
                        decoration: InputDecoration(
                          fillColor: AppColor.bg,
                          hintText: "Enter Old Password",
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
                          if (value == null ) {
                            return "Please Enter Valid Password";
                          }
                          else if(value.length<8){
                            return "Password must be greater than or equal to 8 char";
                          }
                          else{
                            return null;
                          }
                        },
                      ),
                      Gap(cx.height / 44.47),
                      TextFormField(
                        controller: newpasscontroller,
                        cursorColor: Color(0xFF628477),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: cx.height > 800 ? 19 : 17,
                          color: AppColor.darkGreen,
                        ),
                        decoration: InputDecoration(
                          fillColor: AppColor.bg,
                          // hintText: Constant.Location==""?"Search Dome":'${Constant.Location}',
                          hintText: "Enter New Password",
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
                          if (value == null ) {
                            return "Please Enter Valid Password";
                          }
                          else if(value.length<8){
                            return "Password must be greater than or equal to 8 char";
                          }
                          else{
                            return null;
                          }
                        },
                      ),
                      Gap(cx.height / 44.47),
                      TextFormField(
                        controller: confirmpasscontroller,
                        cursorColor: Color(0xFF628477),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: cx.height > 800 ? 19 : 17,
                          color: AppColor.darkGreen,
                        ),
                        decoration: InputDecoration(
                          fillColor: AppColor.bg,
                          hintText: "Confirm Password",
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
                          if (value == null || value.isEmpty) {
                            return "Please Enter Valid Confirm Password";
                          }
                          else if(value != newpasscontroller.text){
                            print(value);
                            print(newpasscontroller.text);
                            return "Password and confirm password must be same";
                          }
                          else{
                            return null;
                          }
                        },
                      ),
                      Gap(cx.height / 10),

                      Padding(
                        padding: EdgeInsets.only(
                          bottom: cx.responsive(33,25, 20),
                          right: cx.responsive(27,20, 15),
                          left: cx.responsive(23,15, 10),
                        ),
                        child: Container(
                          height: cx.responsive(cx.height/13.8,cx.height/13.8,cx.height/12.13),
                          width: cx.width/1.25,
                          child: CustomButton(
                            text: "Change Password",
                            fun: () {
                              if(ChangePassFormKey.currentState!.validate()){
                                print(cx.read('id'));
                                print(oldpasscontroller.text);
                                print(newpasscontroller.text,);
                                print(confirmpasscontroller.text);

                                changePass();
                              }
                              else{
                                print("no fetch data");

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

                      Gap(cx.height / 25.65),
                    ],
                  ),
                ),

                Gap(cx.height / 66.7),

              ],
            ),
          ),
        ),
      ],
    );
  }

  void changePass() async {
    onAlert(context: context,type: 1,msg: "Loading...");

    try {
      var request = http.MultipartRequest('POST', Uri.parse(Constant.changepassword));
      request.fields.addAll({
        'user_id':cx.read('id').toString(),
        'current_password': oldpasscontroller.text,
        'new_password': newpasscontroller.text,
        'confirm_password': confirmpasscontroller.text
      });
      print("Crash1");
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      if (jsonBody['status'] == 1) {
        print(jsonBody.toString());
        onAlert(context: context,type: 2,msg: jsonBody['message']);
        Timer(du, () {
          Get.back();
        });

      } else {

        onAlert(context: context,type: 3,msg: jsonBody['message']);
        print(jsonBody);
      }
    } catch (e) {
      print("Crash2");
      print(e);

      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }

    }
  }

}
