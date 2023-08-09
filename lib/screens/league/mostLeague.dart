import 'package:domez/controller/commonController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/Strings.dart';
import '../../controller/leagueDetailsController.dart';
import '../../controller/leaguesListController.dart';
import '../../model/leagueListModel.dart';
import '../authPage/signIn.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/common/textSentic.dart';
import 'leaguePageDetails.dart';
import '../../commonModule/utils.dart';

class MostPopularLeague extends StatefulWidget {
  const MostPopularLeague({Key? key}) : super(key: key);

  @override
  State<MostPopularLeague> createState() => _MostPopularLeagueState();
}

class _MostPopularLeagueState extends State<MostPopularLeague> {
  CommonController cx = Get.put(CommonController());
  final mycontroller = Get.put(LeagueListController());
  final lx = Get.put(LeagueDetailsController());
  List<int> errorImagesMostPopular = [];

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);

    return WillPopScope(
      onWillPop: () async {
        mycontroller.page.value=1;

        return true;

      },
      child: Scaffold(
          body: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              controller: mycontroller.scrollController2,
              children: [
            Gap(cx.height / 40),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: cx.height / 33.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gap(cx.height / 50),

                          InkWell(
                            onTap: () {
                              Get.back();
                              mycontroller.page.value=1;
                            },
                            child: Container(
                              width: cx.width * 0.09,
                              height: cx.width * 0.09,
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
                                  )),
                              child: Padding(
                                padding: EdgeInsets.only(left: cx.width * 0.02),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Gap(cx.height / 30),

                          SenticText(
                            height: 1.2,
                            text: 'Most\nPopular League',
                            fontSize: cx.height > 800 ? 30 : 26,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(cx.height / 33.5),
                Obx(
                  () => Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: mycontroller.myList2.length,
                        //controller: mycontroller.scrollController2,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(left: 10, right: 10),

                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 1.0,
                          mainAxisSpacing: 4.0,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          LeagueListModel item = mycontroller.myList2[index];
                          return InkWell(
                            onTap: () {
                              cx.write(Keys.image, item.image);
                              Get.to(LeaguePageDetails(
                                isFav: item.isFav,
                                leagueId: item.id.toString(),
                              ));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(cx.width / 12),
                              ),
                              color: Colors.transparent,
                              elevation: 4,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Container(
                                height: cx.height / 2.78,
                                width: cx.width / 2.2,
                                // color: Colors.white,
                                decoration: errorImagesMostPopular
                                        .contains(item.id)
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
                                          onError:
                                              (Object e, StackTrace? stackTrace) {
                                            setState(() {
                                              errorImagesMostPopular.add(item.id);
                                            });
                                          },
                                        ),
                                        color: Colors.transparent,
                                      ),
                                child: Container(
                                  height: cx.height / 2.78,
                                  width: cx.width / 2.2,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                        Colors.black.withOpacity(.0),
                                        Colors.black.withOpacity(.7),
                                      ])),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: cx.width / 9.5,
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      cx.height / 41.69,
                                                      10,
                                                      0,
                                                      0),
                                                  child: Image.network(
                                                    item.sportData[0].image,
                                                    scale: cx.height > 800
                                                        ? 1.2
                                                        : 1.4,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Gap(3),
                                              Container(
                                                width: cx.width / 3,
                                                child: NunitoText(
                                                  height:
                                                      cx.responsive(4, 3.2, 2.8),
                                                  text: item.leagueName,
                                                  color: Colors.white,
                                                  fontSize:
                                                      cx.responsive(25, 19, 16),
                                                  fontWeight: FontWeight.bold,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  shadow: <Shadow>[
                                                    Shadow(
                                                      offset: Offset(1.0, 1.0),
                                                      blurRadius: 3.0,
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                    ),
                                                    Shadow(
                                                      offset: Offset(1.0, 1.0),
                                                      blurRadius: 8.0,
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: cx.height / 20,
                                                width: cx.height / 5,
                                                decoration: BoxDecoration(
                                                    // color: Color(0xFFFFE68A),
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                          'assets/images/priceTag.png',
                                                        ),
                                                        scale: 2,
                                                        alignment: Alignment
                                                            .centerLeft)),
                                                child: Row(
                                                  children: [
                                                    InterText(
                                                      text: ' \$${item.price} ',
                                                      fontWeight: FontWeight.w700,
                                                      color: Color(0xFF444444),
                                                      fontSize: cx.responsive(
                                                          20, 17, 15),
                                                    ),
                                                    InterText(
                                                      text: '/Team',
                                                      fontWeight: FontWeight.w400,
                                                      color: Color(0xFF444444),
                                                      fontSize: cx.responsive(
                                                          14, 11, 9),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            cx.width / 44.47,
                                            cx.height / 150,
                                            cx.width / 44.47,
                                            cx.height / 83.375),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: cx.width / 3.3,
                                                  child: InterText(
                                                    shadow: <Shadow>[
                                                      Shadow(
                                                        offset: Offset(1.0, 1.0),
                                                        blurRadius: 3.0,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                      ),
                                                      Shadow(
                                                        offset: Offset(1.0, 1.0),
                                                        blurRadius: 8.0,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                      ),
                                                    ],
                                                    text: item.domeName,
                                                    // text: "item.name",
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                    fontSize:
                                                        cx.height > 800 ? 20 : 17,
                                                    height: 1,
                                                  ),
                                                ),
                                                Gap(3),
                                                Container(
                                                  width: cx.width / 3.3,
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/location.png",
                                                        scale: cx.responsive(
                                                            2.5, 1.5, 2),
                                                        color: Colors.white,
                                                      ),
                                                      Container(
                                                        width: cx.width * 0.25,
                                                        child: NunitoText(
                                                          shadow: <Shadow>[
                                                            Shadow(
                                                              offset: Offset(
                                                                  1.0, 1.0),
                                                              blurRadius: 3.0,
                                                              color:
                                                                  Color.fromARGB(
                                                                      255,
                                                                      0,
                                                                      0,
                                                                      0),
                                                            ),
                                                            Shadow(
                                                              offset: Offset(
                                                                  1.0, 1.0),
                                                              blurRadius: 8.0,
                                                              color:
                                                                  Color.fromARGB(
                                                                      255,
                                                                      0,
                                                                      0,
                                                                      0),
                                                            ),
                                                          ],
                                                          textAlign:
                                                              TextAlign.start,
                                                          text:
                                                              "${item.city}, ${item.state}",
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize:
                                                              cx.height > 800
                                                                  ? 16
                                                                  : 14,
                                                          color: Colors.white,
                                                          height: 1.6,
                                                          textOverflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Gap(3),
                                                Container(
                                                  width: cx.width / 3.3,
                                                  child: InterText(
                                                    shadow: <Shadow>[
                                                      Shadow(
                                                        offset: Offset(1.0, 1.0),
                                                        blurRadius: 3.0,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                      ),
                                                      Shadow(
                                                        offset: Offset(1.0, 1.0),
                                                        blurRadius: 8.0,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                      ),
                                                    ],
                                                    text: item.date,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                    fontSize:
                                                        cx.height > 800 ? 15 : 13,
                                                    height: 1.25,
                                                  ),
                                                ),
                                                Gap(7)
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  child: Icon(
                                                    item.isFav
                                                        ? Icons.favorite
                                                        : Icons
                                                            .favorite_border_rounded,
                                                    color: Colors.white,
                                                    size: 25,
                                                  ),
                                                  onTap: () {
                                                    if (cx.read("islogin")) {
                                                      setState(() {
                                                        // fav=!fav;
                                                        // print(mostPopular);
                                                        // mostPopular[index] =!mostPopular[index];
                                                        item.isFav = !item.isFav;
                                                      });
                                                      cx.favourite(
                                                          uid: cx.id.value
                                                              .toString(),
                                                          type: "2",
                                                          lid:
                                                              item.id.toString());
                                                    } else {
                                                      Get.to(SignIn(curIndex: 2));
                                                      onAlertSignIn(
                                                          context: context,
                                                          currentIndex: 2,
                                                          noOfPopTimes: 1);
                                                    }
                                                  },
                                                ),
                                                SizedBox(
                                                    height: cx.height / 44.47),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 2.0),
                                                  child: Image.asset(
                                                    Image1.calendar,
                                                    scale: 2.4,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: cx.height / 44.47),
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
                          );
                        },
                      ),
                      mycontroller.reLoadingDataProcessing2.value == true
                          ? Column(
                            children: [
                              Gap(cx.height / 30),
                              CircularProgressIndicator(),
                              Gap(cx.height / 30),

                            ],
                          )
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          ])),
    );
  }
}
