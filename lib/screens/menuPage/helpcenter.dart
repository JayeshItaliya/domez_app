import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:domez/commonModule/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../commonModule/widget/search/customButton.dart';
import '../../controller/commonController.dart';
import 'package:http/http.dart'as http;
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textNunito.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({Key? key}) : super(key: key);

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  CommonController cx = Get.put(CommonController());
  bool iscategories = false;
  bool isdistance = false;
  bool isprice = false;

  double start = 0.0;
  double end = 200.0;
  double minDistance = 0.0;
  double maxDistance = 500.0;


  double start1 = 0.0;
  double end1 = 50.0;
  double minPrice = 0.0;
  double maxPrice = 200.0;
  RangeLabels labels =RangeLabels('1', "500");
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController subjectcontroller = TextEditingController();
  TextEditingController msgcontroller = TextEditingController();

  bool msgError = false;
  int vollyIndex=0;
  final GlobalKey<FormState> ChangePassFormKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          //color set to transperent or set your own color
          statusBarIconBrightness: Constant.deviceBrightness,
          //set brightness for icons, like dark background light icons
        )
    );
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
                text: 'Help Center',
                fontSize: cx.height > 800 ? 32 : 28,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              Gap(cx.height /30),


              Form(
                key:ChangePassFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    AbsorbPointer(

                      child: TextFormField(
                        textInputAction: TextInputAction.next,

                        controller: emailcontroller,
                        cursorColor: Color(0xFF628477),
                        keyboardType: TextInputType.emailAddress,

                        style: TextStyle(
                          fontSize: cx.height > 800 ? 19 : 17,
                          color: AppColor.darkGreen,
                        ),
                        decoration: InputDecoration(
                          fillColor: AppColor.bg,
                          hintText: cx.read("useremail").isEmpty?"testdomez@gmail.com":cx.read("useremail"),
                          hintStyle: TextStyle(
                            fontSize: cx.height > 800 ? 17 : 15,
                              color: AppColor.darkGreen,
                              fontWeight: FontWeight.w500
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

                      ),
                      absorbing: true,
                    ),
                    Gap(cx.height / 44.47),
                    TextFormField(
                      textInputAction: TextInputAction.next,

                      controller: subjectcontroller,
                      cursorColor: Color(0xFF628477),
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: cx.height > 800 ? 19 : 17,
                        color: AppColor.darkGreen,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      //
                      decoration: InputDecoration(

                        fillColor: AppColor.bg,
                        hintText: "Enter Subject",
                        hintStyle: TextStyle(
                          fontSize: cx.height > 800 ? 17 : 15,
                          color: AppColor.darkGreen,
                          fontWeight: FontWeight.w500
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(cx.height / 6.67),
                          borderSide: BorderSide(
                            width: 1,
                            color: AppColor.Green,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(cx.height / 6.67),
                          borderSide: BorderSide(
                            width: 1,
                            color: Color(0xFFD32F2F),
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(cx.height / 6.67),
                          borderSide: BorderSide(
                            width: 1,
                            color:Color(0xFFD32F2F),
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
                          cx.height / 26.68,
                          cx.height / 41.69,
                        ),
                      ),

                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return "Please Enter Your Subject";
                        }
                        return null;

                      },
                    ),
                    Gap(cx.height /28),
                    InterText(
                      text: "Message",
                      color: Colors.black,
                      fontSize: cx.responsive(26,20,16),
                      fontWeight: FontWeight.w400,
                    ),
                    Gap(cx.height / 60),

                    Container(
                      height: cx.height/5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: msgError?Color(0xFFD32F2F):AppColor.Green,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Color(0xFFF5F7F9),
                        //     blurRadius: 8,
                        //     spreadRadius: 7, //New
                        //   )
                        // ],

                      ),
                      child:Padding(
                        padding: const EdgeInsets.fromLTRB(15.0,4,15,4,),
                        child: TextFormField(
                          textInputAction: TextInputAction.done,

                          maxLines: 6,
                          onChanged: (value){
                            if(value.length<=1){
                              setState((){
                                msgError=false;
                              });
                            }
                          },
                          onTap: (){
                            if(msgcontroller.text.length==0||msgcontroller.text.isEmpty){
                              setState((){
                                msgError=true;
                              });
                            }
                          },
                          maxLength: 150,
                          controller: msgcontroller,
                          cursorColor: Color(0xFF628477),
                          decoration: InputDecoration(
                            hintText: "Describe Your Issue Here",
                            hintStyle:  TextStyle(
                              fontSize: cx.height > 800 ? 19 : 17,
                              color: Color(0xFF444444),

                            ),
                            border: InputBorder.none
                          ),

                          keyboardType: TextInputType.multiline,
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
                    NunitoText(
                      text: "        Please Enter Your Message",
                      fontSize: cx.responsive(15,13, 12.5),
                      color: msgError?Color(0xFFD32F2F):Colors.transparent,

                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //
                    //     NunitoText(
                    //       text: "Upto 100 Characters",
                    //       fontSize: cx.responsive(18,15, 13),
                    //       color: Color(0xFFA8A8A8),
                    //
                    //     ),
                    //   ],
                    // )


                  ],
                ),
              ),

            ],
          ),
        ),
        // floatingActionButtonLocation:FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar:Padding(
          padding: EdgeInsets.only(
            bottom: cx.height/17,
            right: cx.responsive(27,25, 15),
            left: cx.responsive(27,25, 15),
          ),
          child: Container(
            height: cx.height/12.13,
            width: cx.width / 1.2,
            child: CustomButton(
              text: "Submit",
              fun: () {
                if(msgcontroller.text.isEmpty){
                  setState(() {
                    msgError=true;
                  });
                }

                if(ChangePassFormKey.currentState!.validate()){
                  helpCenter();
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
        ),
      );
  }
  void helpCenter() async {
    onAlert(context: context,type: 1,msg: "Loading...");

    try {
      var request = http.MultipartRequest('POST', Uri.parse(Constant.helpcenter));
      request.fields.addAll({
        'email': cx.read("useremail"),
        'subject': subjectcontroller.text,
        'message': msgcontroller.text
      });
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

