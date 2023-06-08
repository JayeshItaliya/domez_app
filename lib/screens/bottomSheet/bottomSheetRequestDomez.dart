import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../commonModule/AppColor.dart';
import '../../commonModule/Constant.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../commonModule/widget/search/customButton.dart';
import '../../controller/commonController.dart';
import 'package:http/http.dart' as http;


class BottomSheetRequestDomez extends StatefulWidget {
  const BottomSheetRequestDomez({Key? key}) : super(key: key);

  @override
  State<BottomSheetRequestDomez> createState() => _BottomSheetRequestDomezState();
}

class _BottomSheetRequestDomezState extends State<BottomSheetRequestDomez> {
  TextEditingController venueNamecontroller = TextEditingController();
  TextEditingController venueAddressController = TextEditingController();
  TextEditingController yourNamecontroller = TextEditingController();
  TextEditingController numbercontroller = TextEditingController();
  TextEditingController commentscontroller = TextEditingController();
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  String? name;
  String countryCode = "";


  CommonController cx = Get.put(CommonController());
  

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
                  text: ''
                      'Venue Details',
                  fontSize: cx.height > 800 ? 32 : 28,
                  fontWeight: FontWeight.w500,
                ),
                Gap(cx.height / 95.29),
                NunitoText(
                  textAlign: TextAlign.center,
                  text: "Fill in the details below to help us out:",
                  fontWeight: FontWeight.w400,
                  fontSize: cx.height > 800 ? 19 : 17,
                  color: Color(0xFF6F6B6B),
                ),
                Gap(cx.height / 22.23),
                Form(
                  key: signInFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: venueNamecontroller,
                        cursorColor: Color(0xFF628477),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: cx.height > 800 ? 19 : 17,
                          color: AppColor.darkGreen,
                        ),
                        decoration: InputDecoration(
                          fillColor: AppColor.bg,
                          // hintText: Constant.Location==""?"Search Dome":'${Constant.Location}',
                          hintText: "Venue Name",
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

                          if (value == null || value.isEmpty ) {
                            return "Please Enter Venue Name";
                          }
                          return null;

                        },
                      ),
                      Gap(cx.height / 44.47),
                      TextFormField(
                        controller: venueAddressController,
                        textInputAction: TextInputAction.next,

                        cursorColor: Color(0xFF628477),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: cx.height > 800 ? 19 : 17,
                          color: AppColor.darkGreen,
                        ),
                        decoration: InputDecoration(
                          fillColor: AppColor.bg,
                          // hintText: Constant.Location==""?"Search Dome":'${Constant.Location}',
                          hintText: "Venue Address",
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

                          if (value == null || value.isEmpty ) {
                            return "Please Enter Venue Address";
                          }
                          return null;
                        },

                      ),



                      Gap(cx.height / 28),
                      SenticText(
                        textAlign: TextAlign.center,
                        text: 'Your Details',
                        fontSize: cx.height > 800 ? 32 : 28,
                        fontWeight: FontWeight.w500,
                      ),
                      Gap(cx.height / 95.29),
                      NunitoText(
                        textAlign: TextAlign.center,
                        text: "We won't share your details with anyone",
                        fontWeight: FontWeight.w400,
                        fontSize: cx.height > 800 ? 19 : 17,
                        color: Color(0xFF6F6B6B),
                      ),
                      Gap(cx.height / 22.23),
                      TextFormField(
                        // enabled: false,
                        textInputAction: TextInputAction.next,

                        controller: yourNamecontroller,
                        cursorColor: Color(0xFF628477),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: cx.height > 800 ? 19 : 17,
                          color: AppColor.darkGreen,
                        ),
                        decoration: InputDecoration(
                          fillColor: AppColor.bg,
                          hintText: "Your Name (Optional)",
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
                        // validator: (value){
                        //
                        //   if (value == null || value.isEmpty ) {
                        //     return "Please Enter Your Name";
                        //   }
                        //   return null;
                        //
                        // },
                      ),
                      Gap(cx.height / 44.47),
                      IntlPhoneField(
                        textInputAction: TextInputAction.next,

                        obscureText: false,
                        controller: numbercontroller,
                        flagsButtonPadding: EdgeInsets.all(10),
                        style: TextStyle(
                          fontSize: cx.height > 800 ? 19 : 17,
                          color: AppColor.darkGreen,
                        ),
                        cursorColor: AppColor.darkGreen,
                        dropdownTextStyle: TextStyle(
                          fontSize: cx.height > 800 ? 16 : 14,
                          color:AppColor.darkGreen,
                        ),
                        dropdownIcon: Icon(
                          Icons.arrow_drop_down_outlined,
                          size: 30,
                          color: Colors.black,

                        ),
                        decoration: InputDecoration(
                          isDense: true,

                          contentPadding: EdgeInsets.fromLTRB(
                            cx.responsive(35,30, 26),
                            cx.responsive(22,18, 16),
                            cx.responsive(35,30, 26),
                            cx.responsive(22,18, 16),
                          ),
                          filled: true,
                          fillColor: AppColor.bg,

                          hintText: "Phone Number (Optional)",
                          hintStyle: TextStyle(
                            fontSize: cx.height > 800 ? 17 : 15,
                            color: Color(0xFF628477),
                          ),
                          enabledBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          disabledBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          focusedBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          errorBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),
                          focusedErrorBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(
                              width: 1,
                              color: AppColor.Green,
                            ),
                          ),

                          border:const OutlineInputBorder(),
                        ),
                        invalidNumberMessage: "",

                        disableLengthCheck: false,
                        initialCountryCode: 'CA',
                        onCountryChanged: (country){

                          setState(() {
                            countryCode=country.dialCode;
                            print("countryCode");
                            print(countryCode);
                          });
                        },
                        // onChanged: (phone) {
                        //   setState(() {
                        //     countryCode=phone.countryCode;
                        //     print("countryCode");
                        //     print(countryCode);
                        //   });
                        // },
                      ),

                      Gap(cx.height / 44.47),
                      Container(
                        height: cx.height/5,
                        decoration: BoxDecoration(
                          color: AppColor.bg,
                          border: Border.all(
                            color: AppColor.Green,
                            // width: 1.5,
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
                            maxLines: 6,
                            textInputAction: TextInputAction.done,

                            maxLength: 150,
                            controller: commentscontroller,
                            cursorColor: Color(0xFF628477),
                            decoration: InputDecoration(
                                hintText: "Comments (Optional)",
                                hintStyle: TextStyle(
                                  fontSize: cx.height > 800 ? 17 : 15,
                                  color: Color(0xFF628477),
                                ),
                                border: InputBorder.none
                            ),

                            keyboardType: TextInputType.multiline,
                            style:TextStyle(
                              fontSize: cx.height > 800 ? 19 : 17,
                              color: AppColor.darkGreen,
                            ),
                          ),
                        ),

                      ),
                      Gap(cx.height / 100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NunitoText(
                            text: "        Please Enter Your Comment",
                            fontSize: cx.responsive(15,13, 12.5),
                            color: Colors.transparent,
                            textAlign: TextAlign.start,

                          ),
                        ],
                      ),
                      Gap(cx.height / 44.47),



                      Padding(
                        padding:  EdgeInsets.only(
                          bottom:cx.responsive(33,25,20),
                          right:cx.responsive(25,20,15),
                          left:cx.responsive(22,15,10),
                        ),
                        child: Container(
                          height: cx.responsive(cx.height/13.8,cx.height/13.8,cx.height/12.13),
                          width: cx.width/1.25,
                          child: CustomButton(
                            text: "Submit",
                            fun: () {


                              if(signInFormKey.currentState!.validate()){
                                requestDomez();
                              }
                              else if(venueNamecontroller.text.isNotEmpty&&
                                  venueNamecontroller.text.isNotEmpty){
                                requestDomez();

                              }
                              else{
                                print("no fetch data");
                              }
                            },
                            color:AppColor.darkGreen,
                            radius: cx.height / 11.17,
                            width: cx.width / 4,
                            size:  cx.responsive(23, 19, 15),
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),



              ],
            ),
          ),
        ),
      ],
    );
  }
  Future requestDomez() async {

    try {
      onAlert(context: context,type: 1,msg: "Loading...");

      print("Hello12345");
      var request = http.MultipartRequest('POST', Uri.parse(Constant.requestDomez));

      request.fields.addAll({
        'venue_name': venueNamecontroller.text,
        'venue_address': venueAddressController.text,
        'name': yourNamecontroller.text,
        'email': cx.read("useremail"),
        'phone': numbercontroller.text,
        'comment': commentscontroller.text
      });

      print(request.fields);
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (jsonBody['status'] == 1) {
        onAlert(context: context,type: 2,msg: "Thank you, we have received your request!");
        print(jsonBody.toString());
      } else {
        onAlert(context: context,type: 3,msg: jsonBody['message']);
        print(jsonBody);
      }
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet!!");
      }
    }
  }

}
