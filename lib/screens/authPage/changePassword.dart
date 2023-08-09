import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:domez/commonModule/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../commonModule/Constant.dart';
import 'package:gap/gap.dart';
import '../../commonModule/utils.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../commonModule/widget/search/customButton.dart';
import '../../controller/commonController.dart';
import 'package:http/http.dart'as http;


class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  CommonController cx = Get.put(CommonController());

  RangeLabels labels =RangeLabels('1', "500");
  TextEditingController oldpasscontroller = TextEditingController();
  TextEditingController newpasscontroller = TextEditingController();
  TextEditingController confirmpasscontroller = TextEditingController();

  int vollyIndex=0;
  final GlobalKey<FormState> ChangePassFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 18, 30, 18),
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    Get.back();
                  },
                  child: Container(
                    width: cx.width*0.09,
                    height:cx.width*0.09,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFF5F7F9),
                            blurRadius: 8,
                            spreadRadius: 7, //New
                          )
                        ],

                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          width: 1,
                          color: Color(0xFFE8FFF6),
                        )
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left:cx.width*0.02),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 18,
                        color: Colors.black,

                      ),
                    ),
                  ),
                ),
              ],
            ),
            Gap(cx.height / 15),
            SenticText(
              text: 'Change Password',
              fontSize: cx.height > 800 ? 32 : 28,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            Gap(cx.height /30),


            Container(
              height: cx.height*0.7,
              child: Form(
                key:ChangePassFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Column(
                      children: [
                        TextFormField(

                          controller: oldpasscontroller,
                          cursorColor: Color(0xFF628477),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            fontSize: cx.height > 800 ? 19 : 17,
                              color: AppColor.darkGreen,
                              fontWeight: FontWeight.w500
                          ),
                          decoration: InputDecoration(
                            fillColor: AppColor.bg,
                            hintText: "Enter Current Password",
                            hintStyle: TextStyle(
                              fontSize: cx.height > 800 ? 17 : 15,
                                color: AppColor.darkGreen,
                                fontWeight: FontWeight.w500                      ),
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
                          textInputAction: TextInputAction.next,

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
                                color: AppColor.darkGreen,
                                fontWeight: FontWeight.w500                      ),
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
                          textInputAction: TextInputAction.done,

                          controller: confirmpasscontroller,
                          maxLines: 1,
                          cursorColor: Color(0xFF628477),
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontSize: cx.height > 800 ? 19 : 17,
                              color: AppColor.darkGreen,
                              fontWeight: FontWeight.w500
                          ),
                          decoration: InputDecoration(

                            fillColor: AppColor.bg,
                            hintText: "Confirm Password",
                            hintStyle: TextStyle(
                              fontSize: cx.height > 800 ? 17 : 15,
                                color: AppColor.darkGreen,
                                fontWeight: FontWeight.w500                      ),
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
                              return "Password and confirm password must be the same";
                            }
                            else{
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: cx.responsive(35,25, 20),
                        right: cx.responsive(35,25, 15),
                        left: cx.responsive(35,25, 15),
                      ),
                      child: Container(
                        height: cx.height/12.13,
                        width: cx.width / 1.2,
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
                          size: cx.responsive(25, 22, 15),
                          textColor: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),


          ],
        ),
      ),

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

