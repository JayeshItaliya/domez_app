import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../commonModule/AppColor.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/Strings.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../controller/commonController.dart';
import '../../controller/domesDetailsController.dart';
import '../authPage/editProfile.dart';
import '../bottomSheet/bottomSheetBookings.dart';

class Bookings extends StatefulWidget {
  bool isBackButton;

  Bookings({Key? key, required this.isBackButton}) : super(key: key);

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> with WidgetsBindingObserver {
  final ScrollController _scroller = ScrollController();
  var popularIndex = [true, true, true, true];
  bool search = false;
  CommonController cx = Get.put(CommonController());
  final dx = Get.put(DomesDetailsController());

  bool Previous = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    setState(() {
      search = false;
    });

    // print("hell11");
  }

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: AppColor.bg,
          //color set to transperent or set your own color
          statusBarIconBrightness: Constant.deviceBrightness,
          //set brightness for icons, like dark background light icons
        )
    );
    return Obx(()=> WillPopScope(
        onWillPop: () async{
          if(cx.curIndex.value!=0){
            if(widget.isBackButton==true){
              cx.curIndex.value=4;
            }
            else{
              cx.curIndex.value=0;

            }
          }

          if(widget.isBackButton){
            Get.back();
          }
          return false;

        },

        child: SafeArea(
          top: false,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              controller: _scroller,
              child: Container(
                height: cx.height,
                decoration: BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [
                          0.6,
                          0.65
                        ],
                        colors: [
                          AppColor.bg,
                          cx.isoffline.value ?Colors.white: Colors.white,
                        ])),
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),

                  children: [
                    // IgnorePointer(child: Gap(WonderEvents.topHeight)),
                    Container(
                      height: cx.height / 5,
                      decoration: BoxDecoration(
                        color: AppColor.bg,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.elliptical(
                                cx.height / 16.7, cx.height / 23.82),
                            bottomRight: Radius.elliptical(
                                cx.height / 16.7, cx.height / 23.82)),
                      ),
                      child: Column(

                        children: [
                          Gap(5),
                          Padding(
                            padding: EdgeInsets.only(left: cx.height / 33.5),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: (){
                                    Get.back();
                                  },
                                  child: widget.isBackButton
                                      ?Container(
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
                                  ):Container(),
                                ),

                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                            ),
                          ),
                          Gap(cx.height / 25),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: cx.height / 33.5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Gap(cx.height / 66.7),
                                        InterText(
                                          text: "Here are Your",
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF70A792),
                                          fontSize: cx.responsive(30,24,20),
                                          height: 0.15,
                                        ),
                                        Gap(cx.height / 95.29),
                                        SenticText(
                                          text: "Bookings",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: cx.responsive(42,36, 32),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Stack(
                                        fit: StackFit.passthrough,
                                        alignment: Alignment(50, 50),
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (cx.read("islogin")) {
                                                Get.to(EditProfile());
                                              }
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: cx.height / 41.7),
                                              child: CircleAvatar(
                                                radius: cx.responsive(25,22.5, 20),
                                                backgroundColor: Colors.white,
                                                child: CachedNetworkImage(
                                                  imageUrl: cx.read("image"),
                                                  imageBuilder:
                                                      (context, imageProvider) =>
                                                          CircleAvatar(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    radius: cx.responsive(25,20, 17),
                                                    backgroundImage: NetworkImage(
                                                      cx.read("image"),
                                                    ),
                                                  ),
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => CircleAvatar(
                                                    backgroundColor:
                                                    Colors.transparent,
                                                    radius: cx.responsive(
                                                        25,20, 17),
                                                    backgroundImage:
                                                    AssetImage(
                                                      Image1.anime,
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          CircleAvatar(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    radius: cx.responsive(25,20, 17),
                                                    backgroundImage: AssetImage(
                                                      Image1.anime,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: cx.responsive(3.5,2, 0.1),
                                            right: cx.height / 33,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: cx.responsive(13,6, 4.5),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFFF5C5C),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                height:cx.responsive(20,17, 13),
                                                width: double.infinity,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Gap(cx.height / 33.5),
                            ],
                          ),
                        ],
                      ),
                    ),
                    BottomSheetBooking(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
