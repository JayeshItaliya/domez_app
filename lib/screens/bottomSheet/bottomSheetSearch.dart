import '../../../commonModule/AppColor.dart';
import 'package:domez/commonModule/Strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../commonModule/Constant.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../controller/commonController.dart';
import '../../controller/domesDetailsController.dart';
import '../../controller/filterListController.dart';
import '../../model/FilterModel.dart';
import '../authPage/signIn.dart';
import '../bookSteps/DomePage.dart';
import '../league/leaguePageDetails.dart';
import '../menuPage/filters.dart';

class BottomSheetSearch extends StatefulWidget {
  BottomSheetSearch({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomSheetSearch> createState() => _BottomSheetSearchState();
}

class _BottomSheetSearchState extends State<BottomSheetSearch> {
  CommonController cx = Get.put(CommonController());

  FilterListController mycontroller = Get.put(FilterListController());
  final dx = Get.put(DomesDetailsController());
  List<int> errorSearch = [];

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Gap(cx.height / 44.47),
            Center(child: buildHandle()),
            Gap(20),
            Padding(
              padding: EdgeInsets.only(left: 3.0, right: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => SenticText(
                      height: 1.2,
                      text: '${mycontroller.myList.length} Results Found',
                      fontSize: cx.height > 800 ? 16 : 14,
                      fontWeight: FontWeight.w500,
                      color: AppColor.grey,
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Get.to(Filters());
                    },
                    child: Container(
                      height:30,
                      alignment: Alignment.center,
                      width: cx.width / 5,
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColor.darkGreen),
                          borderRadius: BorderRadius.circular(cx.width / 10)),
                      child: InterText(
                          text: "Filter",
                          color: AppColor.lightGreen,
                          fontSize: cx.responsive(20,17, 14),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Gap(cx.height / 33.5),
            Obx(
              () => mycontroller.isoffline.value
                  ? noInternetLottie()
                  : mycontroller.isDataProcessing.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColor.darkGreen,
                          ),
                        )
                      : mycontroller.myList.length == 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: cx.height * 0.15,
                                ),
                                Container(
                                  height: cx.height * 0.5,
                                  // height: 200,
                                  color: Colors.white,
                                  alignment: Alignment.topCenter,
                                  child: NunitoText(
                                      text: 'No Data Found!',
                                      textAlign: TextAlign.center,
                                      fontSize: cx.responsive(35,27, 23),
                                      color: Colors.grey.shade600),
                                ),
                              ],
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              controller: mycontroller.scrollController,
// scrollDirection: Axis.horizontal,
                              itemCount: mycontroller.myList.length,
                              itemBuilder: (context, index) {
                                FilterModel item = mycontroller.myList[index];

                                return InkWell(
                                  onTap: () {
                                    if (item.type == 1) {
                                      Get.to(
                                        DomePage(
                                          isFav: item.isFav,
                                          domeId: item.id.toString(),
                                        ),);
                                    } else {
                                      Get.to(
                                          LeaguePageDetails(
                                            isFav: item.isFav,
                                            leagueId: item.id.toString(),));                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                height: cx.responsive(
                                                    cx.height / 4.2,
                                                    cx.height / 4.2,
                                                    cx.height / 3.51),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    50,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: cx.responsive(
                                                          160,135, 120),
                                                      height: cx.responsive(
                                                          160,135, 120),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(20),
                                                          ),
                                                          image:
                                                          errorSearch.contains(item.id)?
                                                          DecorationImage(
                                                              image:
                                                              AssetImage(
                                                                Image1.domesAround,
                                                              ),
                                                              fit: BoxFit
                                                                  .cover):
                                                            DecorationImage(
                                                                  image:
                                                                      NetworkImage(
                                                                    item.image,
                                                                  ),
                                                                onError: (Object e, StackTrace? stackTrace) {
                                                                  setState(() {
                                                                    errorSearch.add(item.id);
                                                                  });
                                                                },
                                                                  fit: BoxFit
                                                                      .cover)
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              cx.height / 41.69,
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
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width:
                                                                    cx.width /
                                                                        4,
                                                                height: cx
                                                                    .responsive(
                                                                        35,29, 25),
                                                                child: ListView
                                                                    .builder(
                                                                        shrinkWrap:
                                                                            true,
                                                                        physics:
                                                                            NeverScrollableScrollPhysics(),
                                                                        scrollDirection:
                                                                            Axis
                                                                                .horizontal,
                                                                        itemCount: mycontroller
                                                                            .myList[
                                                                                index]
                                                                            .sportsList
                                                                            .length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                i) {
                                                                          if (i <=
                                                                              2) {
                                                                            return Image.network(
                                                                              item.sportsList[i].image,
                                                                              scale: cx.height > 800
                                                                                  ? 1.2
                                                                                  : 1.4,
                                                                            color: AppColor.darkGreen,);
                                                                          } else {
                                                                            return Container();
                                                                          }
                                                                        }),
                                                              ),
                                                              item.type != 1
                                                                  ? Container(
                                                                      width: cx
                                                                              .width *
                                                                          0.25,
                                                                      child:
                                                                          InterText(
                                                                        text: item
                                                                            .leagueName,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontSize: cx.height >
                                                                                800
                                                                            ? 20
                                                                            : 19,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    )
                                                                  : Container()
                                                            ],
                                                          ),
                                                          Container(
                                                            width:
                                                                cx.width * 0.42,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          4,
                                                                          0,
                                                                          0),
                                                              child: InterText(
                                                                text: item
                                                                    .domeName,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize:
                                                                    cx.height >
                                                                            800
                                                                        ? 21
                                                                        : 19,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0, 4, 0, 4),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Image.asset(
                                                                    "assets/images/location.png",
                                                                    scale: cx
                                                                        .responsive(1,
                                                                            1.5,
                                                                            2),
                                                                    color: AppColor
                                                                        .darkGreen),
                                                                Container(
                                                                  width:
                                                                      cx.width *
                                                                          0.36,
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
                                                                    fontSize:
                                                                        cx.height >
                                                                                800
                                                                            ? 19
                                                                            : 15,
                                                                    color: AppColor
                                                                        .lightGreen,
                                                                    maxLines: 1,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 1,
                                                          ),
                                                          Container(
                                                            width:
                                                                cx.width * 0.35,
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
                                                                          FontWeight
                                                                              .w700,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize: cx.height >
                                                                              800
                                                                          ? 26
                                                                          : 22,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: item.type !=
                                                                            1
                                                                        ? ' / Team'
                                                                        : ' / Hour',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
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
                                                    cx.height / 19,
                                                    cx.height / 19,
                                                    cx.height / 17),
                                                right: 10,
                                                child: InkWell(
                                                  child: Icon(
                                                    item.isFav
                                                        ? Icons.favorite
                                                        : Icons
                                                            .favorite_border_rounded,
                                                    color: AppColor.darkGreen,
                                                    size: cx.height > 800
                                                        ? 33
                                                        : 28,
                                                  ),
                                                  onTap: () {
                                                    if (cx.read("islogin")) {
                                                      setState(() {
                                                        item.isFav =
                                                            !item.isFav;
                                                      });
                                                      if (item.type != 1) {
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
                                                      Get.to(
                                                          SignIn(curIndex: 3));
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
                                    ],
                                  ),
                                );
                              },
                            ),
            ),
            SizedBox(
              height: cx.height / 5,
            ),
          ],
        ),
      ),
    );
  }

  Container buildHandle() {
    return Container(
      width: cx.width / 9,
      height: 6,
      decoration: BoxDecoration(
          color: Color(0xFFE7F4EF), borderRadius: BorderRadius.circular(99)),
    );
  }
}
