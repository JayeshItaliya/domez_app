import 'package:domez/controller/categoryController.dart';
import 'package:flutter/services.dart';

import '../../../commonModule/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../commonModule/Strings.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../controller/commonController.dart';
import '../../controller/leagueDetailsController.dart';
import '../../controller/leaguesListController.dart';
import '../../model/leagueListModel.dart';
import '../league/leagueAroundYou.dart';
import '../league/leaguePageDetails.dart';
import '../league/mostLeague.dart';
import '../menuPage/requestDomez.dart';
import '../../commonModule/utils.dart';

class BottomSheetLeague extends StatefulWidget {
  const BottomSheetLeague({Key? key}) : super(key: key);

  @override
  State<BottomSheetLeague> createState() => _BottomSheetLeagueState();
}

class _BottomSheetLeagueState extends State<BottomSheetLeague> {
  Container buildHandle() {
    return Container(
      width: cx.width / 7.08,
      height: cx.height / 111.17,
      decoration: BoxDecoration(
          color: Color(0xFFE7F4EF),
          borderRadius: BorderRadius.circular(cx.height / 6.74)),
    );
  }

  CommonController cx = Get.put(CommonController());
  CategoryController categoryListController = Get.put(CategoryController());
  final mycontroller = Get.put(LeagueListController());
  final lx = Get.put(LeagueDetailsController());
  String location = '';
  String Address = '';
  List<bool> mostPopular = [false, false, false];
  List<bool> domesAround = [false, false, false];
  List<int> errorImagesMostPopular = [];
  List<int> errorImagesLeagueAround = [];
  double mostPopularWidth = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(cx.read(Keys.lat)!=null&&cx.read(Keys.lng)!=null){
      cx.lat.value=cx.read(Keys.lat);
      cx.lat.value=cx.read(Keys.lng);
    }


    mostPopularWidth = cx.responsive(300, 220, 200);

    mycontroller.getTask2(categoryListController.sportid.value);
    mycontroller.getTask3(categoryListController.sportid.value);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => mycontroller.isoffline.value
          ? Container()
          : mycontroller.isDataProcessing2.value ||
                  mycontroller.isDataProcessing3.value
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColor.darkGreen,
                    ),
                  ),
                )
              : DraggableScrollableSheet(
                  initialChildSize: cx.height > 800 ? 0.58 : 0.54,
                  expand: true,
                  minChildSize: cx.height > 800 ? 0.58 : 0.54,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return ListView(
                      controller: scrollController,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      children: [
                        Obx(
                          () =>
                              mycontroller.isDataProcessing2.value ||
                                      mycontroller.isDataProcessing3.value
                                  ? Container()
                                  : mycontroller.myList2.length == 0 &&
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
                                                          context: context,currentIndex: 2,noOfPopTimes: 1);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      18.0),
                                                  child: Container(
                                                    height: cx.responsive(
                                                        110, 80, 60),
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50)),
                                                    // padding: EdgeInsets.all(cx.responsive(33,25, 20),),
                                                    child: Center(
                                                      child: NunitoText(
                                                        text:
                                                            "Request Domez",
                                                        fontWeight:
                                                            FontWeight.w700,
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
                                            borderRadius: BorderRadius.circular(
                                                cx.height / 22),
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
                                              Obx(
                                                () =>
                                                    mycontroller.myList2
                                                                .length ==
                                                            0
                                                        ? Container()
                                                        : Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  if (mycontroller
                                                                          .myList2
                                                                          .length !=
                                                                      0) {
                                                                    Get.to(
                                                                        MostPopularLeague());
                                                                  }
                                                                },
                                                                child: Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: cx.height /
                                                                          26.68,
                                                                      right: cx
                                                                              .height /
                                                                          19.057),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.all(cx.height /
                                                                                83.375),
                                                                        child:
                                                                            SenticText(
                                                                          height:
                                                                              1.2,
                                                                          text: cx.width > 550
                                                                              ? 'Most Popular League'
                                                                              : 'Most\nPopular League',
                                                                          fontSize: cx.height > 800
                                                                              ? 30
                                                                              : 26,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                      mycontroller.myList2.length == 0?Container():Container(
                                                                        height: cx.width > 550
                                                                            ? cx.height /
                                                                                35
                                                                            : cx.height /
                                                                                20.21,
                                                                        width: cx.width > 550
                                                                            ? cx.height /
                                                                                35
                                                                            : cx.height /
                                                                                20.21,
                                                                        decoration: BoxDecoration(
                                                                            border:
                                                                                Border.all(color: AppColor.darkGreen),
                                                                            borderRadius: BorderRadius.circular(cx.height / 13.34)),
                                                                        child:
                                                                            Icon(
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
                                                              Gap(cx.height /
                                                                  33.5),
                                                              Obx(
                                                                () => Container(
                                                                  height: cx
                                                                      .responsive(
                                                                          350,
                                                                          300,
                                                                          265),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .transparent,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16.7),
                                                                  ),
                                                                  // width: 250,
                                                                  child: ListView
                                                                      .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        BouncingScrollPhysics(),
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    itemCount: mycontroller
                                                                        .myList2
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      LeagueListModel
                                                                          item =
                                                                          mycontroller
                                                                              .myList2[index];

                                                                      return InkWell(
                                                                        onTap:
                                                                            () {
                                                                          print(
                                                                              item.isFav);
                                                                          cx.write(Keys.image, item.image);

                                                                          Get.to(
                                                                              LeaguePageDetails(
                                                                            isFav:
                                                                                item.isFav,
                                                                            leagueId:
                                                                                item.id.toString(),
                                                                          ));
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsets.only(
                                                                              left: index == 0 ? cx.height / 26.68 : 0,
                                                                              right: cx.height / 51.31),
                                                                          child:
                                                                              Card(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(cx.responsive(cx.width / 22, cx.width / 15, cx.width / 9)),
                                                                            ),
                                                                            color:
                                                                                Colors.transparent,
                                                                            elevation:
                                                                                4,
                                                                            clipBehavior:
                                                                                Clip.antiAliasWithSaveLayer,
                                                                            child:
                                                                                Container(
                                                                              height: cx.height / 2.78,
                                                                              width: mostPopularWidth,
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
                                                                                        image: NetworkImage(item.image),
                                                                                        fit: BoxFit.cover,
                                                                                        onError: (Object e, StackTrace? stackTrace) {
                                                                                          setState(() {
                                                                                            errorImagesMostPopular.add(item.id);
                                                                                          });
                                                                                        },
                                                                                      ),
                                                                                      color: Colors.transparent,
                                                                                    ),
                                                                              child: Container(
                                                                                height: cx.height / 2.78,
                                                                                width: cx.width / 2,
                                                                                decoration: BoxDecoration(
                                                                                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                                                                                  Colors.black.withOpacity(.0),
                                                                                  Colors.black.withOpacity(.7),
                                                                                ])),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      children: [
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            Container(
                                                                                              width: mostPopularWidth * 0.25,
                                                                                              child: Padding(
                                                                                                padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                                                                                                child: Image.network(
                                                                                                  // item
                                                                                                  //     .sportData[
                                                                                                  //         0]
                                                                                                  //     .image,
                                                                                                  item.sportData[0].image,
                                                                                                  scale: cx.height > 800 ? 1.2 : 1.4,
                                                                                                  color: Colors.white,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              width: mostPopularWidth * 0.6,
                                                                                              child: NunitoText(
                                                                                                height: cx.responsive(2.5, 2.2, 2.8),
                                                                                                text: item.leagueName,
                                                                                                color: Colors.white,
                                                                                                fontSize: cx.responsive(25, 19, 16),
                                                                                                fontWeight: FontWeight.bold,
                                                                                                textOverflow: TextOverflow.ellipsis,
                                                                                                maxLines: 1,
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
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                        Row(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            Container(
                                                                                              height: cx.height / 20,
                                                                                              width: mostPopularWidth * 0.8,
                                                                                              decoration: BoxDecoration(
                                                                                                  // color: Color(0xFFFFE68A),
                                                                                                  image: DecorationImage(
                                                                                                      image: AssetImage(
                                                                                                        'assets/images/priceTag.png',
                                                                                                      ),
                                                                                                      scale: cx.responsive(1, 1.7, 2),
                                                                                                      alignment: Alignment.centerLeft)),
                                                                                              child: Row(
                                                                                                children: [
                                                                                                  InterText(
                                                                                                    text: ' \$${item.price} ',
                                                                                                    fontWeight: FontWeight.w700,
                                                                                                    color: Color(0xFF444444),
                                                                                                    fontSize: cx.responsive(26, 21, 18),
                                                                                                  ),
                                                                                                  InterText(
                                                                                                    text: '/Team',
                                                                                                    fontWeight: FontWeight.w400,
                                                                                                    color: Color(0xFF444444),
                                                                                                    fontSize: cx.height > 800 ? 12 : 10,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: EdgeInsets.fromLTRB(cx.responsive(cx.width / 35, cx.width / 30, cx.width / 25), cx.height / 83.375, cx.responsive(cx.width / 35, cx.width / 30, cx.width / 25), cx.height / 83.375),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Container(
                                                                                                width: mostPopularWidth * 0.7,
                                                                                                child: InterText(
                                                                                                  text: item.domeName,
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
                                                                                                  // text: "item.name",
                                                                                                  fontWeight: FontWeight.w700,
                                                                                                  color: Colors.white,
                                                                                                  fontSize: cx.height > 800 ? 21 : 18,
                                                                                                  height: 1.7,
                                                                                                ),
                                                                                              ),
                                                                                              Container(
                                                                                                width: mostPopularWidth * 0.6,
                                                                                                child: Row(
                                                                                                  children: [
                                                                                                    Image.asset(
                                                                                                      "assets/images/location.png",
                                                                                                      scale: cx.responsive(1, 1.5, 2),
                                                                                                      color: Colors.white,
                                                                                                    ),
                                                                                                    Container(
                                                                                                      width: mostPopularWidth * 0.43,
                                                                                                      child: NunitoText(
                                                                                                        textAlign: TextAlign.start,
                                                                                                        text: "${item.city}, ${item.state}",
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
                                                                                                        fontWeight: FontWeight.w200,
                                                                                                        fontSize: cx.height > 800 ? 17 : 15,
                                                                                                        color: Colors.white,
                                                                                                        height: 2,
                                                                                                        textOverflow: TextOverflow.ellipsis,
                                                                                                        maxLines: 1,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Container(
                                                                                                width: mostPopularWidth * 0.7,
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
                                                                                                  text: item.date,
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  color: Colors.white,
                                                                                                  fontSize: cx.height > 800 ? 15 : 13,
                                                                                                  height: 1.5,
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(height: 7),
                                                                                            ],
                                                                                          ),
                                                                                          Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                                                            children: [
                                                                                              InkWell(
                                                                                                child: Icon(
                                                                                                  item.isFav ? Icons.favorite : Icons.favorite_border_rounded,
                                                                                                  color: Colors.white,
                                                                                                  size: 28,
                                                                                                ),
                                                                                                onTap: () {
                                                                                                  if (cx.read("islogin")) {
                                                                                                    setState(() {
                                                                                                      // fav=!fav;
                                                                                                      // print(mostPopular);
                                                                                                      // mostPopular[index] =!mostPopular[index];
                                                                                                      item.isFav = !item.isFav;
                                                                                                    });
                                                                                                    cx.favourite(uid: cx.read("id").toString(), type: "2", lid: item.id.toString());
                                                                                                  } else {
                                                                                                    onAlertSignIn(context: context,currentIndex: 2,noOfPopTimes: 1);
                                                                                                  }
                                                                                                },
                                                                                              ),
                                                                                              SizedBox(height: cx.height / 44.47),
                                                                                              Image.asset(
                                                                                                Image1.calendar,
                                                                                                scale: 2,
                                                                                              ),
                                                                                              SizedBox(height: 7),
                                                                                            ],
                                                                                          ),
                                                                                          // Gap(50),
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
                                                            ],
                                                          ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Gap(cx.height / 33.5),
                                                  InkWell(
                                                    onTap: () {
                                                      if (mycontroller
                                                              .myList3.length !=
                                                          0) {
                                                        Get.to(
                                                            LeagueAroundYou());
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left:
                                                              cx.height / 23.82,
                                                          right: cx.height /
                                                              19.06),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SenticText(
                                                            height: 1.2,
                                                            text: cx.width > 550
                                                                ? "Leagues Around You"
                                                                : 'Leagues\nAround You',
                                                            fontSize:
                                                                cx.height > 800
                                                                    ? 30
                                                                    : 26,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          mycontroller.myList3.length == 0?Container():Container(
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
                                                  Obx(
                                                    () => cx.read(Keys.lat) == '' ||
                                                        cx.read(Keys.lng) == ''||
                                                        cx.read(Keys.lat) == null ||
                                                        cx.read(Keys.lng) == null
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
                                                                  Gap(cx.height /
                                                                      80),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      if(cx.read(Keys.lat) != '' &&
                                                                          cx.read(Keys.lng) != '' &&
                                                                          cx.read(Keys.lat) != null &&
                                                                          cx.read(Keys.lng) != null){
                                                                        mycontroller.getTask3(categoryListController.currentCategoryId.value.toString());
                                                                      }
                                                                      getCurrentLocation();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          cx.height /
                                                                              12,
                                                                      width: cx
                                                                              .width *
                                                                          0.55,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(25),
                                                                        color: AppColor
                                                                            .darkGreen,
                                                                      ),
                                                                      child:
                                                                          NunitoText(
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        text:
                                                                            "Get Nearby Domes",
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize: cx.height >
                                                                                800
                                                                            ? 20
                                                                            : 18,
                                                                        color: Colors
                                                                            .white,
                                                                        // height: 2.3,
                                                                        textOverflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                        : mycontroller.myList3
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
                                                                    mycontroller
                                                                        .myList3
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  LeagueListModel
                                                                      item =
                                                                      mycontroller
                                                                              .myList3[
                                                                          index];

                                                                  return InkWell(
                                                                    onTap: () {
                                                                      cx.write(Keys.image, item.image);

                                                                      Get.to(
                                                                          LeaguePageDetails(
                                                                        isFav: item
                                                                            .isFav,
                                                                        leagueId: item
                                                                            .id
                                                                            .toString(),
                                                                      ));
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .only(
                                                                        left: cx.height /
                                                                            26.68,
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
                                                                                    border: Border.all(color: AppColor.bg, width: 1.2),
                                                                                    borderRadius: BorderRadius.circular(12)),
                                                                                child: Stack(
                                                                                  children: [
                                                                                    Container(
                                                                                      height: cx.height > 800 ? 200 : 170,
                                                                                      width: double.infinity,
                                                                                      decoration: errorImagesLeagueAround.contains(item.id)
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
                                                                                                bottomRight: Radius.circular(0),
                                                                                                bottomLeft: Radius.circular(0),
                                                                                                topLeft: Radius.circular(12),
                                                                                                topRight: Radius.circular(12),
                                                                                              ),
                                                                                              image: DecorationImage(
                                                                                                  image: NetworkImage(item.image),
                                                                                                  onError: (Object e, StackTrace? stackTrace) {
                                                                                                    setState(() {
                                                                                                      errorImagesLeagueAround.add(item.id);
                                                                                                    });
                                                                                                  },
                                                                                                  fit: BoxFit.cover,
                                                                                                  scale: 0.8)),
                                                                                    ),
                                                                                    Positioned(
                                                                                      right: 10,
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
                                                                                                  // fav=!fav;
                                                                                                  // print(mostPopular);
                                                                                                  // mostPopular[index] =!mostPopular[index];
                                                                                                  item.isFav = !item.isFav;
                                                                                                });
                                                                                                cx.favourite(uid: cx.read("id").toString(), type: "2", lid: item.id.toString());
                                                                                              } else {
                                                                                                onAlertSignIn(context: context,currentIndex: 2,noOfPopTimes: 1);
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
                                                                                        left: cx.height / 44.47,
                                                                                        bottom: cx.height / 44.47,
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Container(
                                                                                              width: cx.width * 0.57,
                                                                                              child: InterText(
                                                                                                text: item.domeName,
                                                                                                // text: "item.name",
                                                                                                fontWeight: FontWeight.w700,
                                                                                                color: Colors.black,
                                                                                                fontSize: cx.height > 800 ? 21 : 18,
                                                                                                height: 1,
                                                                                              ),
                                                                                            ),
                                                                                            Gap(3),
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              children: [
                                                                                                Image.asset(
                                                                                                  "assets/images/location.png",
                                                                                                  scale: cx.responsive(1, 1.5, 2),
                                                                                                  color: AppColor.darkGreen,
                                                                                                ),
                                                                                                Container(
                                                                                                  width: cx.width * 0.53,
                                                                                                  child: NunitoText(textAlign: TextAlign.start, text: "${item.city}, ${item.state}", fontWeight: FontWeight.w400, maxLines: 1, fontSize: cx.height > 800 ? 18 : 15, color: AppColor.darkGreen, height: 1),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            Gap(4),
                                                                                            InterText(
                                                                                              text: item.date,
                                                                                              fontWeight: FontWeight.w500,
                                                                                              color: AppColor.darkGreen,
                                                                                              fontSize: cx.height > 800 ? 18 : 15,
                                                                                              height: 1,
                                                                                            ),
                                                                                          ],
                                                                                        )),
                                                                                    Positioned(
                                                                                      right: cx.height / 44.47,
                                                                                      bottom: cx.height / 44.47,
                                                                                      child: Image.network(
                                                                                        item.sportData[0].image,
                                                                                        // item.image,
                                                                                        scale: cx.height > 800 ? 1.2 : 1.4,
                                                                                        color: AppColor.darkGreen,
                                                                                      ),
                                                                                    ),
                                                                                    Positioned(
                                                                                        left: cx.width / 25,
                                                                                        top: cx.height / 30,
                                                                                        child: Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Container(
                                                                                              width: cx.width * 0.65,
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
                                                                                                text: "${item.leagueName.split(" ").sublist(0, 1).join(" ")}\n",
                                                                                                // text: "item.name",
                                                                                                fontWeight: FontWeight.w600,
                                                                                                color: Colors.white,
                                                                                                fontSize: cx.height > 800 ? 26 : 22,
                                                                                                height: 0,
                                                                                                textOverflow: TextOverflow.ellipsis,
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              width: cx.width * 0.65,
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
                                                                                                text: "${item.leagueName}",
                                                                                                // text: "item.name",
                                                                                                fontWeight: FontWeight.w600,
                                                                                                color: Colors.white,
                                                                                                fontSize: cx.height > 800 ? 26 : 22,
                                                                                                height: 0,
                                                                                                textOverflow: TextOverflow.ellipsis,
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        )),
                                                                                    Positioned(
                                                                                        right: 10,
                                                                                        bottom: cx.height / 13,
                                                                                        child: Container(
                                                                                          height: cx.height / 11.17,
                                                                                          width: cx.width / 5,
                                                                                          decoration: BoxDecoration(
                                                                                            // color: Color(
                                                                                            //     0xFFFFE68A),
                                                                                            image: DecorationImage(
                                                                                              image: AssetImage(
                                                                                                'assets/images/priceTag2.png',
                                                                                              ),
                                                                                              scale: 0.6,
                                                                                            ),
                                                                                            borderRadius: BorderRadius.circular(cx.height / 66.7),
                                                                                          ),
                                                                                          child: Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              Container(
                                                                                                child: SenticText(
                                                                                                  // text: item.price.toStringAsFixed(0).toString(),

                                                                                                  text: "\$" + item.price.toInt().toString(),
                                                                                                  fontWeight: FontWeight.w700,
                                                                                                  textOverflow: TextOverflow.ellipsis,
                                                                                                  color: Color(0xFF444444),
                                                                                                  fontSize: cx.responsive(22, 18, 16),
                                                                                                ),
                                                                                              ),
                                                                                              SenticText(
                                                                                                text: '/Team',
                                                                                                fontSize: cx.height > 800 ? 12 : 10,
                                                                                                fontWeight: FontWeight.w500,
                                                                                                color: Color(0xFF444444),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        )),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Gap(cx.height / 22.23)
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                  ),
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
    );
  }
}
