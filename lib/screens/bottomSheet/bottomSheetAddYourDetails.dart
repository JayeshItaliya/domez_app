import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../commonModule/AppColor.dart';
import '../../commonModule/Strings.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../controller/commonController.dart';

class BottomSheetAddYourDetails extends StatefulWidget {
  int minPlayers;
  int maxPlayers;
  BottomSheetAddYourDetails({Key? key,required this.minPlayers,required this.maxPlayers}) : super(key: key);

  @override
  State<BottomSheetAddYourDetails> createState() => _BottomSheetAddYourDetailsState();
}


class _BottomSheetAddYourDetailsState extends State<BottomSheetAddYourDetails> {
  CommonController cx = Get.put(CommonController());
  TextEditingController fullNamecontroller = TextEditingController();
  TextEditingController phonecontroller1 = TextEditingController();
  TextEditingController teamNamecontroller = TextEditingController();
  TextEditingController playerscontroller = TextEditingController();
  String countryCode = "";
  bool msgError = false;
  int vollyIndex=0;

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.maxPlayers);
    print(widget.minPlayers);
  }
  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: cx.height / 2.9,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight:
                Radius.circular(cx.height / 16.7),
                topLeft:
                Radius.circular(cx.height / 16.7),
              )),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                cx.height / 26.68,
                8,
                cx.height / 26.68,
                cx.height / 83.375),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [

                Gap(cx.height / 40),
                Container(
                  alignment: Alignment.centerLeft,
                  child: InterText(
                    text: "Add Your Details",
                    fontSize: cx.responsive(33,27, 25),
                    color: AppColor.darkGreen,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.left,
                  ),
                ),
                Gap(cx.responsive(cx.height / 30,cx.height / 30,cx.height / 35)),

                ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key:cx.ChangePassFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              TextFormField(
                                controller: fullNamecontroller,
                                cursorColor: Color(0xFF628477),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  fontSize: cx.height > 800 ? 19 : 17,
                                  color: AppColor.darkGreen,
                                ),
                                onChanged: (value){
                                  cx.write(LKeys.customerfullName,value);
                                  print(value);
                                },
                                decoration: InputDecoration(
                                  fillColor: AppColor.bg,
                                  hintText: "Full Name",
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
                                validator: (value){
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter Your Full Name";
                                  }
                                  return null;

                                },
                                autovalidateMode: AutovalidateMode.onUserInteraction,

                              ),

                              Gap(cx.height / 44.47),
                              IntlPhoneField(
                                textInputAction: TextInputAction.next,

                                obscureText: false,
                                controller: phonecontroller1,
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

                                onChanged: (value){
                                  cx.write(LKeys.customerphone,value.countryCode+value.number);
                                  print("value");
                                  print(cx.read(LKeys.customerphone));
                                },

                                decoration: InputDecoration(
                                  isDense: true,

                                  contentPadding: EdgeInsets.fromLTRB(
                                    cx.height / 26.68,
                                    cx.height / 41.69,
                                    cx.width / 23,
                                    cx.height / 41.69,
                                  ),
                                  filled: true,
                                  fillColor: AppColor.bg,

                                  hintText: "Phone Number",
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
                                      color: Color(0xFFD53E3E),
                                    ),
                                  ),
                                  focusedErrorBorder:  OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color:  Color(0xFFD53E3E),
                                    ),
                                  ),

                                  border:const OutlineInputBorder(),
                                ),
                                invalidNumberMessage: "Please Enter Valid Length",
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

                              TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,

                                controller: teamNamecontroller,
                                textInputAction: TextInputAction.next,
                                onChanged: (value){
                                  cx.write(LKeys.teamName,value);
                                  print(value);
                                },
                                cursorColor: Color(0xFF628477),
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  fontSize: cx.height > 800 ? 19 : 17,
                                  color: AppColor.darkGreen,
                                ),
                                decoration: InputDecoration(
                                  fillColor: AppColor.bg,
                                  hintText: "Team Name",
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
                                validator: (value){
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter Your Team Name";
                                  }
                                  return null;

                                },
                              ),
                              Gap(cx.height / 44.47),
                              TextFormField(
                                controller: playerscontroller,
                                cursorColor: Color(0xFF628477),
                                keyboardType: TextInputType.numberWithOptions(signed: true),
                                style: TextStyle(
                                  fontSize: cx.height > 800 ? 19 : 17,
                                  color: AppColor.darkGreen,
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.go,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),

                                ],
                                onChanged: (value){
                                  cx.write(LKeys.players,value);
                                },
                                //
                                decoration: InputDecoration(

                                  fillColor: AppColor.bg,
                                  hintText: "Number Of Players",
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
                                    return "Please Enter Number Of Players";
                                  }
                                  else if(int.parse(value)<widget.minPlayers){
                                    return "Min Players are ${widget.minPlayers}";
                                  }
                                  else if(int.parse(value)>widget.maxPlayers){
                                    return "Max Players are ${widget.maxPlayers}";

                                  }
                                  return null;

                                },
                              ),
                              Gap(cx.height / 44.47),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
                Gap(cx.height / 40),

              ],
            ),
          ),
        ),
      ],
    );
  }
}
