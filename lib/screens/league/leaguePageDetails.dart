import 'package:cached_network_image/cached_network_image.dart';
import 'package:domez/controller/categoryController.dart';
import 'package:intl/intl.dart';
import '../../../commonModule/AppColor.dart';
import 'package:domez/commonModule/Strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:page_indicator/page_indicator.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../commonModule/widget/search/customButton.dart';
import '../../commonModule/widget/search/simplecircularIcon.dart';
import '../../controller/commonController.dart';
import '../../controller/leagueDetailsController.dart';
import '../../controller/leaguesListController.dart';
import '../../model/LeagueDetailsModel.dart';
import 'addYourDetails.dart';
import '../../commonModule/utils.dart';

import '../bottomSheet/bottomSheetLeagueDetailsPage.dart';

class LeaguePageDetails extends StatefulWidget {
  bool isFav;
  String leagueId;

  LeaguePageDetails({
    Key? key,
    required this.isFav,
    required this.leagueId,
  }) : super(key: key);

  @override
  State<LeaguePageDetails> createState() => _LeaguePageDetailsState();
}

class _LeaguePageDetailsState extends State<LeaguePageDetails> {
  bool fav = false;
  int selectedIndex = -1;
  CommonController cx = Get.put(CommonController());
  CategoryController categoryController = Get.put(CategoryController());
  final mycontroller = Get.put(LeagueDetailsController());
  final LeagueList = Get.put(LeagueListController());
  late final LeagueDetailsModel item;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData().then((value) {
      item = mycontroller.myList[0];
      print("item.leagueImages.length");
      print(item.leagueImages.length);
    });

  }

  Future<void> getData() async {
    await mycontroller.setLid(widget.leagueId, widget.isFav);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          print("backkkk");
          LeagueList.getTask2(categoryController.sportid.value).then((value) {
            LeagueList.getTask3(categoryController.sportid.value);
            Get.back();
          });
          return false;
        },
        child: Container(
          color: AppColor.bg,
          child: Obx(
            () => mycontroller.isoffline.value
                ? noInternetLottie()
                : mycontroller.isDataProcessing.value
                    ? Container(
                        color: AppColor.bg,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColor.darkGreen,
                          ),
                        ),
                      )
                    : Scaffold(
                        backgroundColor: AppColor.bg,
                        extendBody: true,
                        // resizeToAvoidBottomInset: true,
                        // key: _scaffoldkey,
                        body: SafeArea(
                          top: false,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                height: size.height,
                                decoration: BoxDecoration(
                                  color: AppColor.bg,
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [
                                        0.5,
                                        0.6
                                      ],
                                      colors: [
                                        AppColor.bg,
                                        Colors.white,
                                      ]),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.elliptical(
                                          cx.height / 16.7, cx.height / 23.82),
                                      bottomRight: Radius.elliptical(
                                          cx.height / 16.7, cx.height / 23.82)),
                                ),
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: size.height / 2.1,
                                          child: Container(
                                            height:
                                                size.height + cx.height / 13.34,
                                            // color: AppColor.bg,
                                            child: item.leagueImages.length ==
                                                        0 ||
                                                    item.leagueImages.length ==
                                                        1
                                                ? CachedNetworkImage(
                                                    imageUrl: item
                                                        .leagueImages[0].image
                                                        .toString(),
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Image.network(
                                                      item.leagueImages[0].image
                                                          .toString(),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    placeholder:
                                                        (context, url) =>
                                                            Image.asset(
                                                      scale: cx.responsive(
                                                          0.8, 0.8, 0.5),
                                                      fit: BoxFit.cover,
                                                      Image1.domesAround,
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Image.asset(
                                                      scale: cx.responsive(
                                                          0.8, 0.8, 0.5),
                                                      fit: BoxFit.cover,
                                                      Image1.domesAround,
                                                    ),
                                                  )
                                                : PageIndicatorContainer(
                                                    padding: EdgeInsets.only(
                                                      bottom: cx.responsive(
                                                          cx.height / 6.5,
                                                          cx.height / 6.5,
                                                          cx.height / 7),
                                                    ),
                                                    align:
                                                        IndicatorAlign.bottom,
                                                    length: item
                                                        .leagueImages.length,
                                                    indicatorColor: AppColor.bg,
                                                    indicatorSelectorColor:
                                                        AppColor.darkGreen,
                                                    indicatorSpace: 8.0,
                                                    child: PageView.builder(
                                                        itemCount: item
                                                            .leagueImages
                                                            .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int i) {
                                                          return CachedNetworkImage(
                                                            imageUrl: item
                                                                .leagueImages[i]
                                                                .image
                                                                .toString(),
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Image.network(
                                                              item
                                                                  .leagueImages[
                                                                      i]
                                                                  .image
                                                                  .toString(),
                                                              fit: BoxFit.cover,
                                                            ),
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Image.asset(
                                                              scale:
                                                                  cx.responsive(
                                                                      0.8,
                                                                      0.8,
                                                                      0.5),
                                                              fit: BoxFit.cover,
                                                              Image1
                                                                  .domesAround,
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Image.asset(
                                                              scale:
                                                                  cx.responsive(
                                                                      0.8,
                                                                      0.8,
                                                                      0.5),
                                                              fit: BoxFit.cover,
                                                              Image1
                                                                  .domesAround,
                                                            ),
                                                          );
                                                        })),
                                          ),
                                        ),
                                        Positioned(
                                          left: cx.height > 800 ? 25 : 20,
                                          top: cx.responsive(80, 55, 38),
                                          child: InkWell(
                                            onTap: () {
                                              // Get.back();
                                              LeagueList.getTask2(
                                                      categoryController
                                                          .sportid.value)
                                                  .then((value) {
                                                LeagueList.getTask3(
                                                    categoryController
                                                        .sportid.value);
                                                Get.back();
                                              });
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: cx.responsive(30, 24, 17),
                                              child: SimpleCircularIconButton(
                                                iconData:
                                                    Icons.arrow_back_ios_new,
                                                fillColor: Colors.red,
                                                radius:
                                                    cx.responsive(60, 45, 35),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: cx.height > 800 ? 25 : 20,
                                          top: cx.responsive(80, 55, 38),
                                          child: InkWell(
                                            onTap: () {
                                              if (cx.read("islogin")) {
                                                setState(() {
                                                  // fav=!fav;
                                                  // print(mostPopular);
                                                  // mostPopular[index] =!mostPopular[index];
                                                  widget.isFav = !widget.isFav;
                                                });
                                                cx.favourite(
                                                    uid: cx
                                                        .read("id")
                                                        .toString(),
                                                    type: "2",
                                                    lid: item.id.toString());
                                              } else {
                                                // Get.to(SignIn());
                                                onAlertSignIn(
                                                    context: context,
                                                    currentIndex: 2,
                                                    noOfPopTimes: 1);
                                              }
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: cx.responsive(30, 24, 17),
                                              child: SimpleCircularIconButton(
                                                iconData: widget.isFav
                                                    ? Icons.favorite_rounded
                                                    : Icons
                                                        .favorite_outline_rounded,
                                                iconColor: widget.isFav
                                                    ? AppColor.darkGreen
                                                    : Colors.black,
                                                radius:
                                                    cx.responsive(65, 50, 35),
                                              ),
                                            ),
                                          ),
                                        ),
                                        BottomSheetLeaguesDetailsPage(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              MediaQuery.of(context).viewInsets.bottom == 0.0
                                  ? Positioned(
                                      bottom: -29,
                                      child: (SvgPicture.asset(
                                          "assets/svg/leftBottomNavigation.svg",
                                          color: AppColor.darkGreen)),
                                    )
                                  : Container(),
                              MediaQuery.of(context).viewInsets.bottom == 0.0
                                  ? Positioned(
                                      bottom: -29,
                                      right: 0,
                                      child: (SvgPicture.asset(
                                          "assets/svg/rightBottomNavigation.svg",
                                          color: AppColor.darkGreen)),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        bottomNavigationBar: Container(
                          height: cx.height / 8.9,
                          color: AppColor.darkGreen,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                cx.responsive(40, 25, 15),
                                cx.height * 0.025,
                                20,
                                0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: cx.height / 8.9,
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: cx.responsive(35, 25, 13),
                                    ),
                                    child: Row(
                                      children: [
                                        SenticText(
                                          text: "\$" + item.price.toString(),
                                          fontSize: cx.height > 800 ? 28 : 25,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 6.0),
                                          child: SenticText(
                                            text: "/Team",
                                            fontSize: cx.height > 800 ? 16 : 13,
                                            fontWeight: FontWeight.w100,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                !isDeadlineGone()
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            bottom: cx.responsive(
                                                cx.height / 25,
                                                cx.height / 35,
                                                cx.height / 50)),
                                        child: Container(
                                          child: CustomButton(
                                            text: "Book Now",
                                            fun: () async {
                                              Get.to(
                                                AddYourDetails(
                                                  isFav: widget.isFav,
                                                ),
                                              )?.then((value) {
                                                setState(() {
                                                  widget.isFav = value;
                                                });
                                              });
                                            },
                                            radius: cx.height / 13.34,
                                            width: cx.width * 0.32,
                                            size: cx.responsive(24, 20, 18),
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        )),
          ),
        ));
  }

  bool isDeadlineGone() {
    String todayDate = DateFormat('yyyy-MM-dd').format(item.currentTime);
    String deadlineDate = DateFormat('yyyy-MM-dd').format(item.bookingDeadline);
    if (todayDate == deadlineDate) {
      return false;
    }
    if (item.currentTime.microsecondsSinceEpoch >=
        item.bookingDeadline.microsecondsSinceEpoch) {
      return true;
    }

    return false;
  }
}
