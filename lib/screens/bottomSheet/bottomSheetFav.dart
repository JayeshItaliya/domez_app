import 'package:domez/commonModule/Strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../commonModule/AppColor.dart';
import '../../commonModule/Constant.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../controller/commonController.dart';
import '../../controller/domesDetailsController.dart';
import '../../controller/favListController.dart';
import '../../controller/leagueDetailsController.dart';
import '../../model/favouriteModel.dart';
import '../authPage/signIn.dart';
import '../bookSteps/DomePage.dart';
import '../league/leaguePageDetails.dart';

class BottomSheetFav extends StatefulWidget {
  BottomSheetFav({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomSheetFav> createState() => _BottomSheetFavState();
}

class _BottomSheetFavState extends State<BottomSheetFav> {
  CommonController cx = Get.put(CommonController());
  bool League = false;
  bool isFav = true;
  FavListController mycontroller = Get.put(FavListController());
  final dx = Get.put(DomesDetailsController());
  final lx = Get.put(LeagueDetailsController());
  List errorFav=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // height: 2000,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Padding(
            padding: EdgeInsets.only(left: cx.height / 44.47),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Gap(25),
                League
                    ? Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Container(
                          height: cx.height / 13.34,
                          decoration: BoxDecoration(
                            color: AppColor.bg,
                            borderRadius: BorderRadius.circular(
                              cx.height / 13.34,
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: TextButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            cx.height / 13.34,
                                          ),
                                        )),
                                        splashFactory: NoSplash.splashFactory,
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColor.bg)),

                                    child: NunitoText(
                                      text: "Dome",
                                      fontSize: cx.responsive(28,22, 18),
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF17563E),
                                    ),
                                    onPressed: () {
                                      mycontroller.type.value = 1;
                                      mycontroller.getTask(
                                          mycontroller.type.value.toString());

                                      setState(() {
                                        League = false;
                                        // getData();
                                      });
                                    },
                                    // color: Colors.pink,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: cx.height / 12.13,
                                  child: TextButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            cx.height / 13.34,
                                          ),

                                          // side: BorderSide(color: Colors.red)
                                        )),
                                        splashFactory: NoSplash.splashFactory,
                                        side: MaterialStateProperty.all(
                                          BorderSide(
                                            color: AppColor.lightGreen,
                                            width: 2,
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white)),
                                    child: NunitoText(
                                      text: "League",
                                      fontSize: cx.responsive(28,22, 18),
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF17563E),
                                    ),
                                    onPressed: () {
                                      mycontroller.type.value = 2;
                                      mycontroller.getTask(
                                          mycontroller.type.value.toString());
                                      setState(() {
                                        // League=value;
                                        League = true;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Container(
                          height: cx.height / 13.34,
                          decoration: BoxDecoration(
                            color: AppColor.bg,
                            borderRadius: BorderRadius.circular(
                              cx.height / 13.34,
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 250,
                                  child: TextButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            cx.height / 13.34,
                                          ),
                                        )),
                                        splashFactory: NoSplash.splashFactory,
                                        side: MaterialStateProperty.all(
                                          BorderSide(
                                            color: AppColor.lightGreen,
                                            width: 2,
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white)),
                                    child: NunitoText(
                                      text: "Dome",
                                      fontSize: cx.responsive(28,22, 18),
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF17563E),
                                    ),
                                    onPressed: () {
                                      mycontroller.type.value = 1;
                                      mycontroller.getTask(
                                          mycontroller.type.value.toString());

                                      setState(() {
                                        // League=value;
                                        League = false;
                                        // getData();
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: cx.height / 12.13,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          cx.height / 13.34,
                                        ),
                                        // side: BorderSide(color: Colors.red)
                                      )),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColor.bg),
                                      splashFactory: NoSplash.splashFactory,
                                    ),

                                    child: NunitoText(
                                      text: "League",
                                      fontSize: cx.responsive(28,22, 18),
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF17563E),
                                    ),
                                    onPressed: () {
                                      mycontroller.type.value = 2;
                                      mycontroller.getTask(
                                          mycontroller.type.value.toString());
                                      setState(() {
                                        League = true;
                                      });
                                    },
                                    // color: Colors.pink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                Gap(15),
                Obx(
                  () => Padding(
                    padding: EdgeInsets.only(left: 3.0, right: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SenticText(
                          height: 1.2,
                          text:
                              '${mycontroller.myList.length} Total Favourites',
                          fontSize: cx.height > 800 ? 16 : 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => mycontroller.isoffline.value
                      ? noInternetLottie()
                      : mycontroller.isDataProcessing.value
                          ? Container(
                              height: cx.height * 0.7,
                              // height: 200,
                              color: Colors.white,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.darkGreen,
                                ),
                              ),
                            )
                          : mycontroller.myList.length == 0
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: cx.height * 0.65,
                                      // height: 200,
                                      color: Colors.white,
                                      alignment: Alignment.center,
                                      child: NunitoText(
                                          text:
                                              'Oops! You don\'t have any\nfavourite data yet.',
                                          textAlign: TextAlign.center,
                                          fontSize: cx.responsive(35,27, 23),
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                )
                              : Obx(()=>ListView.builder(
                                    shrinkWrap: true,

                                    physics: BouncingScrollPhysics(),
                                    // scrollDirection: Axis.horizontal,
                                    itemCount: mycontroller.myList.length,
                                    itemBuilder: (context, index) {
                                      FavouriteModel item =
                                          mycontroller.myList[index];
                                      return InkWell(
                                        onTap: () {
                                          if (!League) {
                                            Get.to(
                                              DomePage(
                                                isFav: item.isFav,
                                                domeId: item.id.toString(),
                                              ),);
                                          } else {
                                            Get.to(
                                                LeaguePageDetails(
                                                  isFav: item.isFav,
                                                  leagueId: item.id.toString(),));
                                          }
                                        },
                                        child: Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            // mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    height: cx.responsive(
                                                        cx.height / 4.2,cx.height / 4.2,
                                                        cx.height / 3.51),
                                                    width: cx.width*0.88,
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(4.0,8,0,8),
                                                          child: Container(
                                                            width: cx.responsive(
                                                                160,135, 120),
                                                            height: cx.responsive(
                                                                160,135, 120),
                                                            decoration:
                                                            errorFav.contains(item.id)?BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                                  Radius
                                                                      .circular(
                                                                      20),
                                                                ),
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                      Image1.domesAround,
                                                                    ),
                                                                    
                                                                    fit: BoxFit.cover)):BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius
                                                                          .circular(
                                                                              20),
                                                                    ),
                                                                    image: DecorationImage(
                                                                        image: NetworkImage(
                                                                          item.image,
                                                                        ),
                                                                        onError: (Object e, StackTrace? stackTrace) {
                                                                          setState(() {
                                                                            errorFav.add(item.id);
                                                                          });
                                                                        },
                                                                        fit: BoxFit.cover)),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.fromLTRB(
                                                                  cx.height /
                                                                      41.69,
                                                                  0,
                                                                  0,
                                                                  0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                                children: [
                                                                  Container(

                                                                    height: cx
                                                                        .responsive(
                                                                            35,29, 25),
                                                                    child: ListView
                                                                        .builder(
                                                                            shrinkWrap:
                                                                                true,
                                                                            physics:
                                                                                NeverScrollableScrollPhysics(),
                                                                            scrollDirection: Axis
                                                                                .horizontal,
                                                                            itemCount: mycontroller
                                                                                .myList[
                                                                                    index]
                                                                                .sportsList
                                                                                .length,
                                                                            itemBuilder:
                                                                                (context, i) {
                                                                              if (i <=
                                                                                  2) {
                                                                                return Image.network(
                                                                                  item.sportsList[i].image,
                                                                                  scale: cx.height > 800 ? 1.2 : 1.4,
                                                                                );
                                                                              } else {
                                                                                return Container();
                                                                              }
                                                                            }),
                                                                  ),
                                                                  League
                                                                      ? Container(
                                                                          width: cx.width *
                                                                              0.32,
                                                                          alignment: Alignment.centerLeft,
                                                                          child:
                                                                              InterText(
                                                                            text:
                                                                                " ${item.leagueName}",
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize: cx.height > 800
                                                                                ? 20
                                                                                : 19,
                                                                            color:
                                                                                Colors.black,
                                                                                textAlign: TextAlign.start,
                                                                          ),
                                                                        )
                                                                      : Container()
                                                                ],
                                                              ),
                                                              Container(
                                                                width: cx.width *
                                                                    0.4,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          0,
                                                                          4,
                                                                          0,
                                                                          0),
                                                                  child:
                                                                      InterText(
                                                                    text: item
                                                                        .domeName,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        cx.height >
                                                                                800
                                                                            ? 22
                                                                            : 19,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        0,
                                                                        4,
                                                                        0,
                                                                        4),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .location_on_outlined,
                                                                      color: AppColor
                                                                          .lightGreen,
                                                                      size: cx
                                                                          .responsive(
                                                                              30,24,20),
                                                                    ),
                                                                    Container(
                                                                      width:
                                                                          cx.width *
                                                                              0.28,
                                                                      child:
                                                                          NunitoText(
                                                                        textAlign:
                                                                            TextAlign
                                                                                .start,
                                                                        text:
                                                                            "${item.city}, ${item.state}",
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontSize: cx.height >
                                                                                800
                                                                            ? 19
                                                                            : 15,
                                                                        color: AppColor
                                                                            .lightGreen,
                                                                        textOverflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 1,
                                                              ),
                                                              Container(
                                                                width: cx.width *
                                                                    0.3,
                                                                child: RichText(
                                                                  text: TextSpan(
                                                                    text: '',
                                                                    style: DefaultTextStyle.of(
                                                                            context)
                                                                        .style,
                                                                    children: <
                                                                        TextSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            '\$35',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          fontSize: cx.height >
                                                                                  800
                                                                              ? 26
                                                                              : 22,
                                                                        ),
                                                                      ),
                                                                      TextSpan(
                                                                        text: League
                                                                            ? ' / Team'
                                                                            : ' / Hour',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          fontSize: cx.height >
                                                                                  800
                                                                              ? 15
                                                                              : 12,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: cx.responsive(
                                                        cx.height / 14,cx.height / 14,
                                                        cx.height / 16),
                                                    right: 10,
                                                    child: InkWell(
                                                      child: Icon(
                                                        Icons.favorite_rounded,
                                                        color: AppColor.darkGreen,
                                                        size: cx.height / 23.82,
                                                      ),
                                                      onTap: () {
                                                        mycontroller.myList
                                                            .removeAt(index);

                                                        if (cx.read("islogin")) {
                                                          if (League) {
                                                            cx.favourite(
                                                                uid: cx.read("id")
                                                                    .toString(),
                                                                type: "2",
                                                                lid: item.id
                                                                    .toString());
                                                          } else {
                                                            cx.favourite(
                                                                uid: cx.read("id")
                                                                    .toString(),
                                                                type: "1",
                                                                did: item.id
                                                                    .toString());
                                                          }
                                                        } else {
                                                          print(index);
                                                          Get.to(SignIn(
                                                              curIndex: 4));
                                                          onAlertSignIn(
                                                              context: context);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  index ==
                                                          mycontroller
                                                                  .myList.length -
                                                              1
                                                      ? Container()
                                                      : Positioned(
                                                          bottom: 0,
                                                          child: Column(
                                                            children: [
                                                              Gap(cx.height /
                                                                  22.23),
                                                              Container(
                                                                color: Color(
                                                                    0xFFD6D6D6),
                                                                height: 1,
                                                                width: cx.width,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                              ),
                ),
                SizedBox(
                  height: cx.height / 10,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
