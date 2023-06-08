import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../commonModule/AppColor.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/Strings.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../controller/commonController.dart';
import '../../controller/domesDetailsController.dart';
import '../../controller/favListController.dart';
import '../authPage/editProfile.dart';
import '../bottomSheet/bottomSheetFav.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textInter.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  Container buildHandle() {
    return Container(
      width: cx.width / 9,
      height: 6,
      decoration: BoxDecoration(
          color: Color(0xFFE7F4EF), borderRadius: BorderRadius.circular(99)),
    );
  }

  final ScrollController _scroller = ScrollController();
  bool fav = true;
  var popularIndex = [true, true, true, true];
  bool search = false;
  bool League = false;
  CommonController cx = Get.put(CommonController());
  FavListController mycontroller = Get.put(FavListController());
  final dx = Get.put(DomesDetailsController());

  TextEditingController favController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      search = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(AppColor.bg);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: AppColor.bg,
          //color set to transperent or set your own color
          statusBarIconBrightness: Constant.deviceBrightness,
          //set brightness for icons, like dark background light icons
        )
    );
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          controller: _scroller,
          child: cx.isoffline.value
              ? noInternetLottie(backbutton: true)
              : cx.isDataProcessing.value
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColor.darkGreen,
                      ),
                    )
                  : Container(
                      height: cx.height,
                      decoration: BoxDecoration(
                          color: AppColor.bg,
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [
                                0.6,
                                0.65
                              ],
                              colors: [
                                AppColor.bg,
                                Colors.white,
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
                                  padding:
                                      EdgeInsets.only(left: cx.height / 33.5),
                                  child: Row(
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
                                          child:Padding(
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                  ),
                                ),
                                Gap(cx.height / 66.7),

                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: cx.height / 33.5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Gap(cx.height / 66.7),
                                              InterText(
                                                text: "Here Are Your",
                                                color: Color(0xFF70A792),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              Gap(7),
                                              SenticText(
                                                text: "Favourites",
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: cx.responsive(42,34, 28),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Stack(
                                              fit: StackFit.passthrough,
                                              alignment: Alignment(50,50),
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    if(cx.read("islogin")){
                                                      Get.to(EditProfile());
                                                      }
                                                    else{
                                                      cx.curIndex.value=4;
                                                    }
                                                    },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: cx.height / 41.7),
                                                    child: CircleAvatar(
                                                      radius: cx.responsive(26,22.5, 20),
                                                      backgroundColor: Colors.white,

                                                      child:  CachedNetworkImage(

                                                        imageUrl:
                                                        cx.read("image"),

                                                        imageBuilder: (context, imageProvider) => CircleAvatar(

                                                          backgroundColor: Colors.transparent,
                                                          radius: cx.responsive(25,20, 17),
                                                          backgroundImage: NetworkImage(
                                                            cx.read("image"),

                                                          ),
                                                        ),
                                                        fit: BoxFit
                                                            .cover,
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
                                                        errorWidget: (context, url, error) =>
                                                            CircleAvatar(
                                                              backgroundColor: Colors.transparent,
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
                                                    radius: cx.responsive(
                                                        13,6, 4.5),

                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Color(0xFFFF5C5C),
                                                        borderRadius: BorderRadius.circular(50),
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
                                    // Gap(cx.height / 70),
                                    // Padding(
                                    //   padding: EdgeInsets.fromLTRB(
                                    //       cx.height / 37.06,
                                    //       8,
                                    //       cx.height / 37.06,
                                    //       8),
                                    //   child: Obx(
                                    //     () =>
                                    //         TextFormField(
                                    //       controller: favController,
                                    //       onTap: () async {
                                    //         // debugPrint("Tap");
                                    //         // var place = await Navigator.push(
                                    //         //   context,
                                    //         //   MaterialPageRoute(
                                    //         //     builder: (context) => LocationPicker(),
                                    //         //   ),
                                    //         // );
                                    //         // setState(() {
                                    //         //   cx.searchDome.value = place['location'];
                                    //         //   search = false;
                                    //         //   if (!currentFocus.hasPrimaryFocus) {
                                    //         //     currentFocus.unfocus();
                                    //         //   }
                                    //         //   // lat = place['lat'];
                                    //         //   // lng = place['lng'];
                                    //         // });
                                    //       },
                                    //       cursorColor: AppColor.darkGreen,
                                    //       keyboardType: TextInputType.text,
                                    //       autofocus: search,
                                    //       decoration: InputDecoration(
                                    //         fillColor: Colors.white,
                                    //         hintText: cx.searchDome.value
                                    //                     .toString() ==
                                    //                 ""
                                    //             ? "Search Favourites"
                                    //             : cx.searchDome.value.toString(),
                                    //         hintStyle: TextStyle(
                                    //           fontSize: cx.height > 800 ? 17 : 15,
                                    //           color: Color(0xFF81B5A1),
                                    //         ),
                                    //         border: OutlineInputBorder(
                                    //           borderRadius: BorderRadius.circular(
                                    //               cx.height / 6.67),
                                    //           borderSide: BorderSide(
                                    //             width: 3,
                                    //             color: Color(0xFFECFFF8),
                                    //           ),
                                    //         ),
                                    //         enabledBorder: OutlineInputBorder(
                                    //           borderRadius: BorderRadius.circular(
                                    //               cx.height / 6.67),
                                    //           borderSide: BorderSide(
                                    //             width: 3,
                                    //             color: Color(0xFFECFFF8),
                                    //           ),
                                    //         ),
                                    //         disabledBorder: OutlineInputBorder(
                                    //           borderRadius: BorderRadius.circular(
                                    //               cx.height / 6.67),
                                    //           borderSide: BorderSide(
                                    //             width: 3,
                                    //             color: Color(0xFFECFFF8),
                                    //           ),
                                    //         ),
                                    //         focusedBorder: OutlineInputBorder(
                                    //           borderRadius: BorderRadius.circular(
                                    //               cx.height / 6.67),
                                    //           borderSide: BorderSide(
                                    //             width: 3,
                                    //             color: Color(0xFFECFFF8),
                                    //           ),
                                    //         ),
                                    //         filled: true,
                                    //         contentPadding: EdgeInsets.fromLTRB(
                                    //           cx.responsive(30,24,20),
                                    //           cx.responsive(30,24,20),
                                    //           cx.responsive(10, 20),
                                    //           cx.responsive(30,24,20),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Gap(12),
                          BottomSheetFav()
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
