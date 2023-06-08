import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:domez/commonModule/AppColor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../commonModule/Constant.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../controller/commonController.dart';
import '../../main_page.dart';
import '../authPage/changePassword.dart';
import 'package:http/http.dart'as http;


class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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


  int vollyIndex=0;

  @override
  void initState() {
    super.initState();
  }

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
            Gap(cx.height / 26.68),
            SenticText(
              text: 'Settings',
              fontSize: cx.height > 800 ? 32 : 28,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            Gap(cx.height /15),

            InkWell(
              onTap: (){
                Get.to(ChangePassword());
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child:SenticText(
                            height: 1.2,
                            text: 'Change Password',
                            fontSize: cx.height>800?20:18,
                            fontWeight: FontWeight.w500,
                            color:Color(0xFF6A6A6A)
                        ),
                      ),
                      Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: AppColor.darkGreen,
                          size: 22,
                      )
                    ],
                  ),
                  Gap(cx.height /60),
                ],
              ),
            ),
            Divider(
              color: Color(0xFFD6D6D6),
              thickness: 1,
            ),
            InkWell(
              onTap: (){
                // showDeleteDialog(context);
                onDeleteAlert(context: context);

              },

              child: Column(

                children: [
                  Gap(cx.height /60),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child:SenticText(
                            height: 1.2,
                            text: 'Delete Account',
                            fontSize: cx.height>800?20:18,
                            fontWeight: FontWeight.w500,
                            color:Color(0xFF6A6A6A)
                        ),
                      ),
                      Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: AppColor.darkGreen,
                          size: 22,
                      )
                    ],
                  ),
                  Gap(cx.height /60),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                onLogOutAlert(context: context);
              },
              child: Column(
                children: [
                  Divider(
                    color: Color(0xFFD6D6D6),
                    thickness: 1,
                  ),
                  Gap(cx.height /60),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child:SenticText(
                            height: 1.2,
                            text: 'Logout',
                            fontSize: cx.height>800?20:18,
                            fontWeight: FontWeight.w500,
                            color:Color(0xFF6A6A6A)
                        ),
                      ),
                      Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: AppColor.darkGreen,
                          size: 22,
                      )
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Future deleteAccount() async {
    onAlert(context: context,type: 1,msg: "Loading...");

    try {
      print(cx.read('id'));
      print(Constant.deleteAccount+'-'+cx.read('id').toString());

      var request = http.Request('GET',Uri.parse(Constant.deleteAccount+'-'+cx.read('id').toString()));

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);

      if (jsonBody['status'] == 1) {
        print(cx.read('id'));

        cx.write('username','');
        cx.write('useremail','');
        cx.write('phone','');
        cx.write('countrycode','CA');
        cx.write('image',Constant.dummyProfileUrl);
        cx.write('id',0);
        cx.write('islogin',false);
        cx.write('isVerified',false);

        print(jsonBody.toString());

        cx.id.value=cx.read("id");
        cx.email.value=cx.read("useremail");
        cx.phone.value=cx.read("phone");
        cx.countrycode.value=cx.read("countrycode");
        cx.image.value=cx.read("image");
        cx.isLogin.value=cx.read("islogin");
        cx.name.value=cx.read("username");
        cx.isVerified.value=cx.read("isVerified");

        Duration du = const Duration(seconds: 2);
        onAlert(context: context,type: 2,msg: "User Deleted Successfully");
        Timer(du, () {
          Get.offAll(WonderEvents());
          cx.curIndex.value=0;
        });
      } else {
        onAlert(context: context,type: 3,msg: "Oops! User Unable To Get Delete");
        print(jsonBody);
      }
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        showLongToast("Could not connect to internet!!");
      }
    }
  }
  onDeleteAlert({required BuildContext context,}) {
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
          isButtonVisible: false

      ),
      onWillPopActive:true,
      context: context,
      content: Column(
        children: <Widget>[
          Gap(cx.height/60),
          Text(
            "Delete Account",
            style: TextStyle(
                fontSize: cx.responsive(24,20, 18),
              fontWeight: FontWeight.w700
            ),
          ),
          Gap(cx.height/60),
          Text(
            "Are You Sure You Want To Delete This Account?",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: cx.responsive(22,18, 14),
                fontWeight: FontWeight.w400,
              color: Colors.grey

            ),
          ),
          Gap(cx.height/20),
          InkWell(
          onTap: (){
            Get.back();
            deleteAccount();
          },
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xFFB01717),
                borderRadius: BorderRadius.circular(30)
            ),
            padding: EdgeInsets.all(cx.height/66.7),
            child: Center(
              child: NunitoText(
                text: "Delete Account",
                fontWeight: FontWeight.w700,
                fontSize: cx.responsive(26,20, 16),
                color: Colors.white,
              ),
            ),
          ),
        ),
          Gap(cx.height/70),
          InkWell(
            onTap: (){
              Get.back();
            },
            child: Text(
              "Go Back",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6F6B6B)

              ),
            ),
          ),


          // Gap(cx.height/41),
          //
          // Text(
          //   "Please check your email to reset your password",
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     fontWeight: FontWeight.w400,
          //     fontSize: cx.height > 800 ? 20 : 18,
          //     color: Color(0xFF757575),
          //   ),
          //   overflow: TextOverflow.clip,
          // ),
          // Gap(cx.height/40),
        ],
      ),
      closeIcon: Container(
        height: cx.height/44.47,
      ),
      // onWillPopActive:true ,
    ).show();
  }
  onLogOutAlert({required BuildContext context,}) {
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
          isButtonVisible: false

      ),
      onWillPopActive:true,

      context: context,
      content: Column(
        children: <Widget>[
          Gap(cx.height/60),
          Text(
            "Logout",
            style: TextStyle(
                fontSize: cx.responsive(24,20, 18),
                fontWeight: FontWeight.w700
            ),
          ),
          Gap(cx.height/60),
          Text(
            "Are you sure you would like to logout this account?",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: cx.responsive(22,18, 14),
                fontWeight: FontWeight.w400,
                color: Colors.grey

            ),
          ),
          Gap(cx.height/20),
          InkWell(
            onTap: (){
              print(FirebaseAuth.instance.currentUser);



              if(FirebaseAuth.instance.currentUser!=null){
                print("Social Logged Out");
                print(FirebaseAuth.instance.currentUser);
                FirebaseAuth.instance.signOut();

              }

              cx.write('username','');
              cx.write('useremail','');
              cx.write('phone','');
              cx.write('countrycode','CA');
              cx.write('image',Constant.dummyProfileUrl);
              cx.write('id',0);
              cx.write('islogin',false);
              cx.write('isVerified',false);


              cx.id.value=cx.read("id");
              cx.email.value=cx.read("useremail");
              cx.phone.value=cx.read("phone");
              cx.countrycode.value=cx.read("countrycode");
              cx.image.value=cx.read("image");
              cx.isLogin.value=cx.read("islogin");
              cx.name.value=cx.read("username");
              cx.isVerified.value=cx.read("isVerified");

              Duration du = const Duration(seconds: 2);
              onAlert(context: context,type: 2,msg: "User Logged Out Successfully");
              Timer(du, () {
                Get.offAll(WonderEvents());
                cx.curIndex.value=0;
              });
              },
            child: Container(
              // width: widget.width,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.all(cx.height/66.7),
              child: Center(
                child: NunitoText(
                  text: "Logout",
                  fontWeight: FontWeight.w700,
                  fontSize: cx.responsive(26,20, 16),
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Gap(cx.height/70),
          InkWell(
            onTap: (){
              Get.back();
            },
            child: Text(
              "Go Back",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6F6B6B)

              ),
            ),
          ),


          // Gap(cx.height/41),
          //
          // Text(
          //   "Please check your email to reset your password",
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     fontWeight: FontWeight.w400,
          //     fontSize: cx.height > 800 ? 20 : 18,
          //     color: Color(0xFF757575),
          //   ),
          //   overflow: TextOverflow.clip,
          // ),
          // Gap(cx.height/40),
        ],
      ),
      closeIcon: Container(
        height: cx.height/44.47,
      ),
      // onWillPopActive:true ,
    ).show();
  }

}

