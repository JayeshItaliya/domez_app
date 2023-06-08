import 'dart:ui';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../commonModule/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/Strings.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../controller/bookingDetailsController.dart';
import '../../controller/commonController.dart';
import '../../controller/domesDetailsController.dart';
import '../../controller/domesListController.dart';
import '../../model/domesListModel.dart';
import '../bookSteps/DomePage.dart';
import '../homePage/domesAround.dart';
import '../homePage/mostPopular.dart';
import '../menuPage/bookings.dart';
import '../menuPage/requestDomez.dart';


class BottomScroll extends StatefulWidget {
  const BottomScroll({Key? key}) : super(key: key);

  @override
  State<BottomScroll> createState() => _BottomScrollState();
}

class _BottomScrollState extends State<BottomScroll> {
  Container buildHandle() {
    return Container(
      width: cx.width / 7.08,
      height: cx.height / 111.17,
      decoration: BoxDecoration(
          color: Color(0xFFE7F4EF),
          borderRadius: BorderRadius.circular(cx.height / 6.74)),
    );
  }

  var sController = DraggableScrollableController();
  ScrollController scrollController1 = ScrollController();
  CommonController cx = Get.put(CommonController());
  final mycontroller = Get.put(DomesListController());
  final dx = Get.put(DomesDetailsController());
  BookingDetailsController bx = Get.put(BookingDetailsController());
  String location = '';
  String Address = '';
  List<bool> mostPopular = [false, false, false];
  List<bool> domesAround = [false, false, false];
  List<int> errorRecentBooking = [];
  List<int> errorImagesMostPopular = [];
  List<int> errorImagesDomeAround = [];
  double scrollValue = 0.0;
  var dragScrollKey = UniqueKey();
  double mostPopularWidth= 0.0;

  // DraggableScrollableController draggableScrollableController =
  //     DraggableScrollableController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)=>addPostFrameBack);

    mostPopularWidth=cx.responsive(300, 220, 200);

    print(cx.lat.value);
    print(cx.lng.value);
    cx.write(Keys.lat, cx.lat.value);
    cx.write(Keys.lng, cx.lng.value);
    print(cx.read("id"));
    cx.isReset.value = false;
    print("Internet");
    print(mycontroller.isoffline.value);
    print(mycontroller.isDataProcessing1.value);
    print(mycontroller.isDataProcessing2.value);
    print(mycontroller.isDataProcessing3.value);
  }

  @override
  Widget build(BuildContext context) {
    print("Hey shivakar");
    print(mycontroller.isoffline.value);
    return WillPopScope(
      onWillPop: () async {
        if (!cx.isReset.value) {
          cx.isReset.value = true;
          print("Reset HomePaqe");
          return false;
        }
        // sController.animateTo(0.0, duration: Duration(seconds: 1), curve: Curves.ease);
        // scrollController1.animateTo(0, duration: Duration(seconds: 1), curve: Curves.ease);

        return false;
      },
      child: Obx(() => mycontroller.isoffline.value
          ? noInternetLottie()
          : mycontroller.isDataProcessing1.value||
          mycontroller.isDataProcessing2.value||
          mycontroller.isDataProcessing3.value
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColor.darkGreen,
                    ),
                  ),
                )
              : DraggableScrollableSheet(
                // controller: sController,
                // key: UniqueKey(),
                // snap: true,
                initialChildSize: cx.height > 800 ? 0.58 : 0.54,
                expand: true,
                minChildSize: cx.height > 800 ? 0.58 : 0.54,
                builder: (BuildContext draggableSheetContext,
                    ScrollController scrollController) {

                  return Obx(
                    () => ListView(
                      controller: scrollController,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      children: [
                        mycontroller.myList1.length == 0 &&
                                mycontroller.myList2.length == 0 &&
                                mycontroller.myList3.length == 0
                            ? Container(
                              height: cx.height,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    cx.height / 22),
                              ),
                              child: Column(
                                children: [
                                  Gap(cx.height / 44.47),
                                  Center(child: buildHandle()),
                                  Gap(cx.height / 33.5),
                                  Image.asset(
                                      "assets/images/noData.png"),
                                  Gap(cx.height / 7.5),
                                  InkWell(
                                    onTap: () {
                                      cx.read("islogin")
                                          ? Get.to(
                                              RequestDomez(),
                                            )
                                          : onAlertSignIn(
                                              context: context);
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(18.0),
                                      child: Container(
                                        height:
                                            cx.responsive(110, 80, 60),
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(
                                                    50)),
                                        // padding: EdgeInsets.all(cx.responsive(33,25, 20),),
                                        child: Center(
                                          child: NunitoText(
                                            text: "Request Domez App",
                                            fontWeight: FontWeight.w700,
                                            fontSize: cx.responsive(
                                                33, 25, 20),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(cx.height / 22),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  children: [
                                    Gap(cx.height / 44.47),
                                    Center(child: buildHandle()),
                                    Gap(cx.height / 33.5),
                                    cx.read("islogin")
                                        ? mycontroller.myList1.length == 0
                                            ? Container()
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            left:
                                                                cx.height /
                                                                    23.82),
                                                        child: SenticText(
                                                          text:
                                                              'Recent Bookings',
                                                          fontSize:
                                                              cx.responsive(
                                                                  26,
                                                                  20,
                                                                  16),
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                          textAlign:
                                                              TextAlign
                                                                  .left,
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          Get.to(Bookings(
                                                            isBackButton:
                                                                true,
                                                          ));
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets.only(
                                                              right:
                                                                  cx.height /
                                                                      23.82),
                                                          child: SenticText(
                                                            text: 'See All',
                                                            color: AppColor
                                                                .darkGreen,
                                                            fontSize:
                                                                cx.height >
                                                                        800
                                                                    ? 20
                                                                    : 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500,
                                                            textAlign:
                                                                TextAlign
                                                                    .left,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Gap(cx.height / 66.7),
                                                  Container(
                                                    height:
                                                        cx.height / 6.069,
                                                    child: Obx(
                                                      () =>
                                                          ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            BouncingScrollPhysics(),
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            mycontroller
                                                                .myList1
                                                                .length,
                                                        // reverse: true,
                                                        itemBuilder:
                                                            (context,
                                                                index) {
                                                          DomesListModel
                                                              item =
                                                              mycontroller
                                                                      .myList1[
                                                                  index];

                                                          return InkWell(
                                                            onTap: () {
                                                              // if(item.type==1){
                                                              bx.setBid(
                                                                  item.bookingId
                                                                      .toString(),
                                                                  item
                                                                      .bookingPaymentType,
                                                                  item.isActive ==
                                                                          1
                                                                      ? true
                                                                      : false,
                                                                  true);

                                                              // }
                                                              // else{
                                                              //   bx.setBid(item.bookingId.toString(),3);
                                                              //
                                                              // }
                                                            },
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                index == 0
                                                                    ? SizedBox(
                                                                        width:
                                                                            cx.height / 26.68)
                                                                    : Container(),
                                                                Container(
                                                                  height: cx
                                                                          .height /
                                                                      6.06,
                                                                  width: cx
                                                                          .width /
                                                                      1.84,
                                                                  // color: Colors.white,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      border: Border.all(
                                                                          color: AppColor.bg,
                                                                          width: 1.2),
                                                                      borderRadius: BorderRadius.circular(12)),
                                                                  child:
                                                                      Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(cx.height / 83.375),
                                                                        child:
                                                                            Container(
                                                                          decoration: errorRecentBooking.contains(item.id)
                                                                              ? BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(20),
                                                                                  image: DecorationImage(
                                                                                    image: AssetImage(
                                                                                      Image1.domesAround,
                                                                                    ),
                                                                                    fit: BoxFit.cover,
                                                                                  ))
                                                                              : BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(20),
                                                                                  image: DecorationImage(
                                                                                    image: NetworkImage(
                                                                                      item.image.isEmpty ? "https://thumbs.dreamstime.com/b/indoor-stadium-view-behind-wicket-cricket-160851985.jpg" : item.image,
                                                                                      scale: cx.height > 800 ? 1.8 : 2.4,
                                                                                    ),
                                                                                    fit: BoxFit.cover,
                                                                                    onError: (Object e, StackTrace? stackTrace) {
                                                                                      setState(() {
                                                                                        errorRecentBooking.add(item.id);
                                                                                      });
                                                                                    },
                                                                                  )),
                                                                          width: cx.width * 0.18,
                                                                          height: cx.height / 6.06,
                                                                        ),
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            width: cx.width * 0.3,
                                                                            child: NunitoText(
                                                                              text: item.name,
                                                                              fontWeight: FontWeight.w700,
                                                                              textOverflow: TextOverflow.ellipsis,
                                                                              maxLines: 1,
                                                                              fontSize: cx.height > 800 ? 22 : 18,
                                                                              color: Color(0xFF6E6B6B),
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Image.asset("assets/images/location.png", scale: cx.responsive(1.2, 1.5, 2), color: AppColor.darkGreen),
                                                                              Container(
                                                                                width: cx.width * 0.23,
                                                                                child: NunitoText(
                                                                                  textAlign: TextAlign.start,
                                                                                  text: "${item.city}, ${item.state}",
                                                                                  fontWeight: FontWeight.w400,
                                                                                  fontSize: cx.height > 800 ? 18 : 14,
                                                                                  color: Color(0xFF629C86),
                                                                                  textOverflow: TextOverflow.ellipsis,
                                                                                  maxLines: 1,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          NunitoText(
                                                                            text: item.bookingDate,
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: cx.height > 800 ? 20 : 16,
                                                                            color: Color(0xFFA8A8A8),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: cx
                                                                          .height /
                                                                      55.58,
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Gap(cx.height / 33.5),
                                                ],
                                              )
                                        : Container(),
                                    mycontroller.myList2.length == 0
                                        ? Container()
                                        : Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (mycontroller
                                                          .myList2.length !=
                                                      0) {
                                                    Get.to(MostPopular());
                                                  }
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          cx.height / 26.68,
                                                      right: cx.height /
                                                          19.057),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(
                                                                cx.height /
                                                                    83.375),
                                                        child: SenticText(
                                                          height: 1.2,
                                                          text: cx.width >
                                                                  550
                                                              ? 'Most Popular'
                                                              : 'Most\nPopular',
                                                          fontSize:
                                                              cx.height >
                                                                      800
                                                                  ? 30
                                                                  : 26,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                        ),
                                                      ),
                                                      Container(
                                                        height: cx.width >
                                                                550
                                                            ? cx.height / 35
                                                            : cx.height /
                                                                20.21,
                                                        width: cx.width >
                                                                550
                                                            ? cx.height / 35
                                                            : cx.height /
                                                                20.21,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: AppColor
                                                                    .darkGreen),
                                                            borderRadius: BorderRadius
                                                                .circular(cx
                                                                        .height /
                                                                    13.34)),
                                                        child: Icon(
                                                          Icons
                                                              .arrow_forward_ios_rounded,
                                                          size: cx.width > 550
                                                              ? cx.height /
                                                                  60
                                                              : cx.height /
                                                                  44.47,
                                                          color: AppColor
                                                              .darkGreen,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Gap(cx.height / 33.5),
                                              mycontroller.myList2.length ==
                                                      0
                                                  ? Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Gap(cx.height *
                                                            0.1),
                                                        Container(
                                                          height:
                                                              cx.height *
                                                                  0.2,
                                                          // height: 200,
                                                          color:
                                                              Colors.white,
                                                          alignment:
                                                              Alignment
                                                                  .topCenter,
                                                          child: NunitoText(
                                                              text:
                                                                  'No Data Found',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              fontSize: cx
                                                                  .responsive(
                                                                      35,
                                                                      27,
                                                                      23),
                                                              color: Colors
                                                                  .grey
                                                                  .shade600),
                                                        ),
                                                      ],
                                                    )
                                                  : Container(
                                                      height:cx.responsive(350, 300, 265),
                                                      decoration:
                                                          BoxDecoration(
                                                        color: Colors
                                                            .transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    16.7),
                                                      ),
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      // width: 250,
                                                      child: Obx(
                                                        () => ListView
                                                            .builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              BouncingScrollPhysics(),
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount:
                                                              mycontroller
                                                                  .myList2
                                                                  .length,
                                                          itemBuilder:
                                                              (context,
                                                                  index) {
                                                            DomesListModel
                                                                item =
                                                                mycontroller
                                                                        .myList2[
                                                                    index];

                                                            return InkWell(
                                                              onTap: () {
                                                                Get.to(
                                                                    DomePage(
                                                                      isFav: item.isFav,
                                                                      domeId: item.id.toString(),
                                                                    ),);
                                                                // dx.setDid(
                                                                //     item.id
                                                                //         .toString(),
                                                                //     item.isFav);
                                                              },
                                                              child:
                                                                  Padding(
                                                                padding: EdgeInsets.only(
                                                                    left: index ==
                                                                            0
                                                                        ? cx.height /
                                                                            26.68
                                                                        : 0,
                                                                    right: cx.height /
                                                                        51.31),
                                                                child: Card(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(cx.responsive(cx.width /22,cx.width /15,cx.width /9)),
                                                                  ),
                                                                  color: Colors
                                                                      .transparent,
                                                                  elevation:
                                                                      4,
                                                                  clipBehavior:
                                                                      Clip.antiAliasWithSaveLayer,
                                                                  child:
                                                                      Container(
                                                                        height:cx.height / 2.78,
                                                                        width:mostPopularWidth,
                                                                    // color: Colors.white,
                                                                    decoration: errorImagesMostPopular.contains(item.id)
                                                                        ? BoxDecoration(
                                                                            image: DecorationImage(
                                                                              image: AssetImage(Image1.domesAround),
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          )
                                                                        : BoxDecoration(
                                                                            image: DecorationImage(
                                                                              image: NetworkImage(item.image.isEmpty ? "https://www.playall.in/images/gallery/orbitMall_box_cricket_2.png" : item.image),
                                                                              fit: BoxFit.cover,
                                                                              onError: (Object e, StackTrace? stackTrace) {
                                                                                setState(() {
                                                                                  errorImagesMostPopular.add(item.id);
                                                                                });
                                                                              },
                                                                            ),
                                                                            color: Colors.transparent,
                                                                          ),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          cx.height / 2.78,
                                                                      width:cx.width / 2,
                                                                      decoration: BoxDecoration(
                                                                          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                                                                        Colors.black.withOpacity(.0),
                                                                        Colors.black.withOpacity(.7),
                                                                      ])),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Container(
                                                                                width: mostPopularWidth* 0.55,
                                                                                height: cx.responsive(50, 42, 38),
                                                                                child: ListView.builder(
                                                                                    shrinkWrap: true,
                                                                                    physics: NeverScrollableScrollPhysics(),
                                                                                    scrollDirection: Axis.horizontal,
                                                                                    itemCount: mycontroller.myList2[index].sportsList.length,
                                                                                    itemBuilder: (context, i) {
                                                                                      if (i <= 2) {
                                                                                        return Padding(
                                                                                          padding: EdgeInsets.fromLTRB(i == 0 ? cx.height / 41.69 : 3, 10, 0, 0),
                                                                                          child: Image.network(
                                                                                            item.sportsList[i].image,
                                                                                            scale: cx.height > 800 ? 1.2 : 1.4,
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                        );
                                                                                      } else {
                                                                                        return Container();
                                                                                      }
                                                                                    }),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.fromLTRB(0.0, cx.height / 33.5, cx.height / 44.47, 0),
                                                                                child: Container(
                                                                                  height: cx.responsive(70, 62, 55),
                                                                                  alignment: Alignment(0, 0),
                                                                                  width: cx.responsive(68, 60, 53),
                                                                                  decoration: BoxDecoration(color: Color(0xFFFFE68A), borderRadius: BorderRadius.circular(cx.responsive(20,14,12))),
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      InterText(
                                                                                        // text: item.price.toStringAsFixed(0).toString(),
                                                                                        text: "\$" + item.price.toInt().toString(),
                                                                                        fontSize: cx.height > 800 ? 18 : 16,
                                                                                        fontWeight: FontWeight.w700,
                                                                                        color: Color(0xFF07261A),
                                                                                        textAlign: TextAlign.center,
                                                                                        height: 0,
                                                                                      ),
                                                                                      InterText(
                                                                                        height: 0,
                                                                                        textAlign: TextAlign.center,
                                                                                        text: '/Hour',
                                                                                        fontSize: cx.height > 800 ? 12 : 10,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: Color(0xFF07261A),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsets.fromLTRB(cx.height / 41.69, cx.height / 83.375, cx.height / 44.47, cx.height / 83.375),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                      width: mostPopularWidth * 0.6,
                                                                                      child: InterText(
                                                                                        shadow: <Shadow>[
                                                                                          Shadow(
                                                                                            offset: Offset(1.0, 1.0),
                                                                                            blurRadius: 3.0,
                                                                                            color: Color.fromARGB(255, 0, 0, 0),
                                                                                          ),
                                                                                          Shadow(
                                                                                            offset: Offset(1.0, 1.0),
                                                                                            blurRadius: 8.0,
                                                                                            color: Color.fromARGB(255, 0, 0, 0),
                                                                                          ),
                                                                                        ],
                                                                                        text: item.totalFields == 1 ? item.totalFields.toString() + " Field" : item.totalFields.toString() + " Fields",
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: Colors.white.withOpacity(0.7),
                                                                                        fontSize: cx.height > 800 ? 18 : 15,
                                                                                        height: 2,
                                                                                      ),
                                                                                    ),
                                                                                    Container(
                                                                                      width: mostPopularWidth * 0.6,
                                                                                      child: InterText(
                                                                                        shadow: <Shadow>[
                                                                                          Shadow(
                                                                                            offset: Offset(1.0, 1.0),
                                                                                            blurRadius: 3.0,
                                                                                            color: Color.fromARGB(255, 0, 0, 0),
                                                                                          ),
                                                                                          Shadow(
                                                                                            offset: Offset(1.0, 1.0),
                                                                                            blurRadius: 8.0,
                                                                                            color: Color.fromARGB(255, 0, 0, 0),
                                                                                          ),
                                                                                        ],
                                                                                        text: item.name,
                                                                                        fontWeight: FontWeight.w700,
                                                                                        color: Colors.white,
                                                                                        fontSize: cx.height > 800 ? 21 : 18,
                                                                                        height: 1.7,
                                                                                      ),
                                                                                    ),
                                                                                    Row(
                                                                                      children: [
                                                                                        Image.asset(
                                                                                          "assets/images/location.png",
                                                                                          scale: cx.responsive(1, 1.5, 2),
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                        Container(
                                                                                          width: mostPopularWidth* 0.55,
                                                                                          child: NunitoText(
                                                                                            shadow: <Shadow>[
                                                                                              Shadow(
                                                                                                offset: Offset(1.0, 1.0),
                                                                                                blurRadius: 3.0,
                                                                                                color: Color.fromARGB(255, 0, 0, 0),
                                                                                              ),
                                                                                              Shadow(
                                                                                                offset: Offset(1.0, 1.0),
                                                                                                blurRadius: 8.0,
                                                                                                color: Color.fromARGB(255, 0, 0, 0),
                                                                                              ),
                                                                                            ],
                                                                                            textAlign: TextAlign.start,
                                                                                            text: "${item.city}, ${item.state}",
                                                                                            fontWeight: FontWeight.w400,
                                                                                            fontSize: cx.height > 800 ? 19 : 16,
                                                                                            color: Colors.white,
                                                                                            height: 2.3,
                                                                                            textOverflow: TextOverflow.ellipsis,
                                                                                            maxLines: 1,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    Gap(5),

                                                                                  ],
                                                                                ),
                                                                                Container(
                                                                                  // width: cx.height / 3.35,

                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                                    children: [
                                                                                      InkWell(
                                                                                        child: Icon(
                                                                                          item.isFav ? Icons.favorite : Icons.favorite_border_rounded,
                                                                                          color: Colors.white,
                                                                                          size:  28,
                                                                                        ),
                                                                                        onTap: () {
                                                                                          if (cx.read("islogin")) {
                                                                                            setState(() {
                                                                                              // fav=!fav;
                                                                                              // print(mostPopular);
                                                                                              // mostPopular[index] =!mostPopular[index];
                                                                                              item.isFav = !item.isFav;
                                                                                            });
                                                                                            cx.favourite(uid: cx.read("id").toString(), type: "1", did: item.id.toString());
                                                                                          } else {
                                                                                            // Get.to(SignIn());
                                                                                            onAlertSignIn(context: context);
                                                                                          }
                                                                                        },
                                                                                      ),
                                                                                      SizedBox(height: cx.height / 44.47),
                                                                                      Image.asset(
                                                                                        Image1.calendar,
                                                                                        scale: 2,
                                                                                      ),
                                                                                      SizedBox(height: cx.height / 44.47),
                                                                                    ],
                                                                                  ),
                                                                                ),

                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                              Gap(cx.height / 33.5),
                                            ],
                                          ),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (mycontroller
                                                    .myList3.length !=
                                                0) {
                                              Get.to(DomesAroundYou());
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: cx.height / 23.82,
                                                right: cx.height / 19.06),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SenticText(
                                                  height: 1.2,
                                                  text: cx.width > 550
                                                      ? "Domes Around You"
                                                      : 'Domes\nAround You',
                                                  fontSize: cx.height > 800
                                                      ? 30
                                                      : 26,
                                                  fontWeight:
                                                      FontWeight.w500,
                                                ),
                                                Container(
                                                  height: cx.width > 550
                                                      ? cx.height / 35
                                                      : cx.height / 20.21,
                                                  width: cx.width > 550
                                                      ? cx.height / 35
                                                      : cx.height / 20.21,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: AppColor
                                                              .darkGreen),
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                                  cx.height /
                                                                      13.34)),
                                                  child: Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: cx.width > 550
                                                        ? cx.height / 60
                                                        : cx.height / 44.47,
                                                    color:
                                                        AppColor.darkGreen,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        cx.read(Keys.lat) == '' &&
                                                cx.read(Keys.lng) == '' &&
                                                cx.lat.value == '' &&
                                                cx.lng.value == ''
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                children: [
                                                  // Gap(cx.height/33.5),
                                                  Column(
                                                    children: [
                                                      Gap(cx.height / 80),
                                                      InkWell(
                                                        onTap: () {
                                                          getCurrentLocation();
                                                        },
                                                        child: Container(
                                                          height:
                                                              cx.height /
                                                                  12,
                                                          width: cx.width *
                                                              0.55,
                                                          alignment:
                                                              Alignment
                                                                  .center,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            color: AppColor
                                                                .darkGreen,
                                                          ),
                                                          child: NunitoText(
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                            text:
                                                                "Get Nearby Domes",
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                            fontSize:
                                                                cx.height >
                                                                        800
                                                                    ? 20
                                                                    : 18,
                                                            color: Colors
                                                                .white,
                                                            // height: 2.3,
                                                            textOverflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            : Obx(
                                                () =>
                                                    mycontroller.myList3
                                                                .length ==
                                                            0
                                                        ? Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Gap(cx.height *
                                                                  0.1),
                                                              Container(
                                                                height:
                                                                    cx.height *
                                                                        0.2,
                                                                // height: 200,
                                                                color: Colors
                                                                    .white,
                                                                alignment:
                                                                    Alignment
                                                                        .topCenter,
                                                                child: NunitoText(
                                                                    text:
                                                                        'No Data Found',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    fontSize: cx.responsive(
                                                                        33,
                                                                        27,
                                                                        23),
                                                                    color: Colors
                                                                        .grey
                                                                        .shade600),
                                                              ),
                                                            ],
                                                          )
                                                        : ListView.builder(
                                                            shrinkWrap:
                                                                true,
                                                            physics:
                                                                BouncingScrollPhysics(),
                                                            // scrollDirection: Axis.horizontal,
                                                            itemCount:
                                                                mycontroller.myList3.length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              DomesListModel
                                                                  item =
                                                                  mycontroller
                                                                          .myList3[
                                                                      index];

                                                              return Column(
                                                                children: [
                                                                  Gap(cx.height /33.5),
                                                                  InkWell(
                                                                    onTap:
                                                                        () {
                                                                          Get.to(
                                                                              DomePage(
                                                                                isFav: item.isFav,
                                                                                domeId: item.id.toString(),
                                                                              ),
                                                                          );
                                                                              // arguments: false,);
                                                                      // dx.setDid(
                                                                      //     item.id.toString(),
                                                                      //     item.isFav);
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets.only(
                                                                        left:
                                                                            cx.height / 26.68,
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Column(
                                                                            children: [
                                                                              Container(
                                                                                height: cx.height > 800 ? 300 : 265,
                                                                                width: cx.width - cx.height / 13.34,
                                                                                // color: Colors.white,
                                                                                decoration: BoxDecoration(
                                                                                    // image: DecorationImage(
                                                                                    //   image: AssetImage(
                                                                                    //     Image1.domesAround,
                                                                                    //   ),
                                                                                    //   fit: BoxFit.fill,
                                                                                    //
                                                                                    // ),
                                                                                    color: Colors.transparent,
                                                                                    // border: Border.all(color: AppColor.bg, width: 1.2),
                                                                                    // borderRadius: BorderRadius.circular(40),
                                                                                    border: Border.all(color: Color(0xFFEDEBEB), width: 1.2),
                                                                                    borderRadius: BorderRadius.circular(12)),
                                                                                child: Stack(
                                                                                  children: [
                                                                                    Container(
                                                                                      height: cx.height > 800 ? 200 : 170,
                                                                                      width: double.infinity,
                                                                                      decoration: errorImagesDomeAround.contains(item.id)
                                                                                          ? BoxDecoration(
                                                                                              border: Border.all(color: Colors.transparent, width: 1.2),
                                                                                              borderRadius: BorderRadius.only(
                                                                                                bottomRight: Radius.circular(0),
                                                                                                bottomLeft: Radius.circular(0),
                                                                                                topLeft: Radius.circular(12),
                                                                                                topRight: Radius.circular(12),
                                                                                              ),
                                                                                              image: DecorationImage(image: AssetImage(Image1.domesAround), fit: BoxFit.cover, scale: 0.8))
                                                                                          : BoxDecoration(
                                                                                              border: Border.all(color: Colors.transparent, width: 1.2),
                                                                                              borderRadius: BorderRadius.only(
                                                                                                topLeft: Radius.circular(12),
                                                                                                topRight: Radius.circular(12),
                                                                                              ),
                                                                                              image: DecorationImage(
                                                                                                  image: NetworkImage(
                                                                                                    item.image.isEmpty ? "https://cdn.xxl.thumbs.canstockphoto.com/3d-render-of-a-round-cricket-stadium-with-black-seats-and-vip-boxes-3d-render-of-a-beautiful-modern-clipart_csp46450310.jpg" : item.image,
                                                                                                  ),
                                                                                                  fit: BoxFit.cover,
                                                                                                  onError: (Object e, StackTrace? stackTrace) {
                                                                                                    setState(() {
                                                                                                      errorImagesDomeAround.add(item.id);
                                                                                                    });
                                                                                                  },
                                                                                                  scale: 0.8)),
                                                                                    ),
                                                                                    Positioned(
                                                                                      right: 25,
                                                                                      top: 18,
                                                                                      child: Column(
                                                                                        children: [
                                                                                          InkWell(
                                                                                            child: Icon(
                                                                                              item.isFav ? Icons.favorite : Icons.favorite_border_rounded,
                                                                                              color: Colors.white,
                                                                                              size: cx.height / 23.82,
                                                                                            ),
                                                                                            onTap: () {
                                                                                              if (cx.read("islogin")) {
                                                                                                setState(() {
                                                                                                  item.isFav = !item.isFav;
                                                                                                  print(index);
                                                                                                });
                                                                                                cx.favourite(uid: cx.read("id").toString(), type: "1", did: item.id.toString());
                                                                                              } else {
                                                                                                print(index);
                                                                                                // Get.to(SignIn());
                                                                                                onAlertSignIn(context: context);
                                                                                              }
                                                                                            },
                                                                                          ),
                                                                                          SizedBox(height: cx.height / 44.47),
                                                                                          Image.asset(
                                                                                            Image1.calendar,
                                                                                            scale: cx.height > 800 ? 1.6 : 2,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Positioned(
                                                                                        right: cx.height > 800 ? cx.height / 40 : cx.height / 37.06,
                                                                                        bottom: cx.responsive(95, 70, 55),
                                                                                        child: Container(
                                                                                          height: cx.responsive(75, 72, 65),
                                                                                          alignment: Alignment(0, 0),
                                                                                          width: cx.responsive(76, 69, 65),
                                                                                          decoration: BoxDecoration(color: Color(0xFFFFE68A), borderRadius: BorderRadius.circular(cx.height / 66.7)),
                                                                                          child: Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              Container(
                                                                                                width: cx.width / 8,
                                                                                                child: InterText(
                                                                                                  // text: item.price.toStringAsFixed(0).toString(),
                                                                                                  text: "\$" + item.price.toInt().toString(),
                                                                                                  fontWeight: FontWeight.w700,
                                                                                                  color: Color(0xFF07261A),
                                                                                                  fontSize: cx.responsive(22, 18, 16),
                                                                                                  textAlign: TextAlign.center,

                                                                                                ),
                                                                                              ),
                                                                                              InterText(
                                                                                                text: '/Hour',
                                                                                                fontSize: cx.responsive(16, 12, 10),
                                                                                                fontWeight: FontWeight.w500,
                                                                                                color: Color(0xFF07261A),
                                                                                                textAlign: TextAlign.center,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        )
                                                                                    ),
                                                                                    Positioned(
                                                                                        left: cx.height / 44.47,
                                                                                        bottom: cx.height / 44.47,
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            InterText(
                                                                                              text: item.totalFields == 1 ? item.totalFields.toString() + " Field" : item.totalFields.toString() + " Fields",
                                                                                              fontWeight: FontWeight.w500,
                                                                                              color: AppColor.darkGreen,
                                                                                              fontSize: cx.height > 800 ? 18 : 15,
                                                                                              height: 1,
                                                                                            ),
                                                                                            Gap(3),
                                                                                            Container(
                                                                                              width: cx.width / 1.6,
                                                                                              child: InterText(
                                                                                                text: item.name,
                                                                                                fontWeight: FontWeight.w700,
                                                                                                color: Colors.black,
                                                                                                fontSize: cx.height > 800 ? 21 : 18,
                                                                                                height: 1,
                                                                                              ),
                                                                                            ),
                                                                                            Gap(4),
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              children: [
                                                                                                Image.asset("assets/images/location.png", scale: cx.responsive(2.5, 1.5, 2), color: AppColor.darkGreen),
                                                                                                Container(
                                                                                                    width: cx.width / 2,
                                                                                                    child: NunitoText(
                                                                                                      textAlign: TextAlign.start,
                                                                                                      text: "${item.city}, ${item.state}",
                                                                                                      fontWeight: FontWeight.w400,
                                                                                                      fontSize: cx.height > 800 ? 18 : 15,
                                                                                                      maxLines: 1,
                                                                                                      color: AppColor.darkGreen,
                                                                                                      height: 1,
                                                                                                      textOverflow: TextOverflow.ellipsis,
                                                                                                    )),
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        )),
                                                                                    Positioned(
                                                                                      right: cx.responsive(26, 20, 16),
                                                                                      bottom: cx.height / 42,
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                                                        children: [
                                                                                          Container(
                                                                                            alignment: Alignment.centerRight,
                                                                                            width: cx.width / 4,
                                                                                            height: cx.responsive(50, 40, 34),
                                                                                            child: Obx(
                                                                                              () => ListView.builder(
                                                                                                  shrinkWrap: true,
                                                                                                  physics: NeverScrollableScrollPhysics(),
                                                                                                  scrollDirection: Axis.horizontal,
                                                                                                  itemCount: mycontroller.myList3[index].sportsList.length,
                                                                                                  itemBuilder: (context, i) {
                                                                                                    if (i <= 1) {
                                                                                                      return Padding(
                                                                                                        padding: EdgeInsets.fromLTRB(i == 0 ? cx.height / 41.69 : 3, 10, 0, 0),
                                                                                                        child: Image.network(
                                                                                                          item.sportsList[i].image,
                                                                                                          scale: cx.height > 800 ? 1.2 : 1.4,
                                                                                                          color: AppColor.darkGreen,
                                                                                                        ),
                                                                                                      );
                                                                                                    } else {
                                                                                                      return Container();
                                                                                                    }
                                                                                                  }),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Gap(cx.height / 22.23)
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  );
                },
              )),
    );
  }

  Future<void> getCurrentLocation() async {
    Position position = await _getGeoLocationPosition();
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    GetAddressFromLatLong(position);

    cx.lat.value = position.latitude.toString();
    cx.lng.value = position.longitude.toString();

    print(cx.lat.value);
    print(cx.lng.value);
    cx.write(Keys.lat, cx.lat.value);
    cx.write(Keys.lng, cx.lng.value);
    debugPrint(location);
    debugPrint(Address);
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
        permission = await Geolocator.requestPermission();

      await Geolocator.openLocationSettings();
      // return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    print("permission");
    print(permission);


    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      // await Geolocator.openLocationSettings();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }



    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }


  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    debugPrint("++++++" + placemarks.toString());
    Placemark place = placemarks[0];
    Address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    cx.searchDome.value = place.locality! + "," + place.country.toString();

    debugPrint(cx.searchDome.value.toString());
  }
  void addPostFrameBack(
      FrameCallback callback){

  }

}
