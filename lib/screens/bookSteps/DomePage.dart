import 'package:cached_network_image/cached_network_image.dart';
import 'package:domez/controller/domesListController.dart';
import 'package:intl/intl.dart';
import '../../../commonModule/AppColor.dart';
import 'package:domez/commonModule/Strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:page_indicator/page_indicator.dart';
import '../../commonModule/Constant.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/search/customButton.dart';
import '../../commonModule/widget/search/simplecircularIcon.dart';
import '../../controller/commonController.dart';
import '../../controller/domesDetailsController.dart';
import '../../controller/favListController.dart';
import '../../model/domesDetailsModel.dart';
import '../bottomSheet/bottomSheetDomesPage.dart';
import 'bookSlot.dart';

class DomePage extends StatefulWidget {
  bool isFav;
  String domeId;

  DomePage({Key? key, required this.isFav,required this.domeId})
      : super(key: key);

  @override
  State<DomePage> createState() => _DomePageState();
}

class _DomePageState extends State<DomePage> {
  bool initfav = false;
  int selectedIndex = -1;
  int sportId = 6;

  CommonController cx = Get.put(CommonController());
  final mycontroller = Get.put(DomesDetailsController());
  final domesListController = Get.put(DomesListController());
  FavListController favListController = Get.put(FavListController());
  late final DomesDetailsModel item;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData().then((value) {
      item = mycontroller.myList[0];

    });
    setState(() {
      initfav = widget.isFav;
    });
  }

  Future<void> getData() async {
    await mycontroller.setDid(
        widget.domeId,
        widget.isFav);
  }


  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);

    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (initfav != widget.isFav) {
          if (cx.curIndex.value!=-1) {
            domesListController
                .getTask1(domesListController.sportid.value)
                .then((value) {
              domesListController.getTask2(domesListController.sportid.value);
              domesListController.getTask3(domesListController.sportid.value);
              Get.back();
            });
            return true;
          } else {
            favListController.getTask("1");
            Get.back();
            return true;
          }
        }

        return true;
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
                                          child: PageIndicatorContainer(
                                              padding: EdgeInsets.only(
                                                bottom: cx.responsive(
                                                    cx.height / 6.5,
                                                    cx.height / 6.5,
                                                    cx.height / 7),
                                              ),
                                              align: IndicatorAlign.bottom,
                                              length: item.domeImages.length,
                                              indicatorColor: AppColor.bg,
                                              indicatorSelectorColor:
                                                  AppColor.darkGreen,
                                              // size: 10.0,
                                              indicatorSpace: 8.0,
                                              child: PageView.builder(
                                                  itemCount:
                                                      item.domeImages.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int i) {
                                                    return CachedNetworkImage(
                                                      imageUrl: item
                                                          .domeImages[i].image
                                                          .toString(),
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Image.network(
                                                        item.domeImages[i].image
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

                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                        scale: cx.responsive(
                                                            0.8, 0.8, 0.5),
                                                        fit: BoxFit.cover,
                                                        Image1.domesAround,
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
                                            if (initfav != widget.isFav) {
                                              print("Hey update1");
                                              if (cx.curIndex.value!=4) {
                                                domesListController
                                                    .getTask1(
                                                    domesListController
                                                        .sportid.value)
                                                    .then((value) {
                                                  domesListController.getTask2(
                                                      domesListController
                                                          .sportid.value);
                                                  domesListController.getTask3(
                                                      domesListController
                                                          .sportid.value);
                                                  Get.back();
                                                });
                                              }


                                              if (cx.curIndex.value==4) {
                                                domesListController
                                                    .getTask1(
                                                        domesListController
                                                            .sportid.value)
                                                    .then((value) {
                                                  domesListController.getTask2(
                                                      domesListController
                                                          .sportid.value);
                                                  domesListController.getTask3(
                                                      domesListController
                                                          .sportid.value);
                                                  Get.back();
                                                });
                                              } else {
                                                favListController.getTask("1");
                                                Get.back();
                                              }
                                            } else {
                                              Get.back();
                                            }
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: cx.responsive(30, 24, 17),
                                            child: SimpleCircularIconButton(
                                              iconData:
                                                  Icons.arrow_back_ios_new,
                                              fillColor: Colors.red,
                                              radius: cx.responsive(60, 45, 35),
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
                                                widget.isFav = !widget.isFav;
                                                debugPrint(
                                                    widget.isFav.toString());

                                                var id = domesListController
                                                    .myList2
                                                    .indexWhere((element) =>
                                                        element.id == item.id);
                                                domesListController.myList2[id]
                                                    .isFav = widget.isFav;
                                                domesListController.update();
                                              });
                                              cx.favourite(
                                                  uid: cx.read("id").toString(),
                                                  did: item.id.toString(),
                                                  type: "1");
                                            } else {
                                              // Get.to(SignIn());
                                              onAlertSignIn(context: context);
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
                                              radius: cx.responsive(65, 50, 35),
                                            ),
                                          ),
                                        ),
                                      ),
                                      BottomSheetDomesPage(),
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
                            cx.width / 8,
                            cx.height / 40,
                            cx.width / 8,
                            cx.height / 40,
                          ),
                          child: InkWell(
                            onTap: () {
                              Get.bottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                  ),
                                  backgroundColor: Colors.white,
                                  isDismissible: true,
                                  isScrollControlled: true,
                                  enableDrag: true,
                                  StatefulBuilder(builder: (BuildContext
                                          context,
                                      StateSetter
                                          setState /*You can rename this!*/) {
                                return ListView(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          cx.width / 12,
                                          030,
                                          cx.width / 12,
                                          30),
                                      child: Container(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InterText(
                                            text: "Select Sport",
                                            fontSize: cx.responsive(30, 24, 20),
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          Gap(10),
                                          Container(
                                            child: Wrap(
                                              spacing: 10,
                                              runSpacing: 10,
                                              direction: Axis.horizontal,
                                              children: List.generate(
                                                item.sportsList.length,
                                                (index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        if (selectedIndex ==
                                                            index) {
                                                          selectedIndex = -1;
                                                        } else {
                                                          selectedIndex = index;
                                                          sportId = item
                                                              .sportsList[index]
                                                              .sportId;
                                                          print(sportId);
                                                        }
                                                      });
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: cx.width / 2.5,
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                            cx.height / 66.7,
                                                            cx.height / 51.31,
                                                            10,
                                                            cx.height / 51.31,
                                                          ),
                                                          decoration: BoxDecoration(
                                                              color: index ==
                                                                      selectedIndex
                                                                  ? AppColor.bg
                                                                  : Colors
                                                                      .transparent,
                                                              border: Border.all(
                                                                  color: Color(
                                                                      0xFFD4D4D4)),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      cx.height /
                                                                          41.7)),
                                                          child: Row(
                                                            children: <Widget>[
                                                              CircleAvatar(
                                                                backgroundColor:
                                                                    AppColor
                                                                        .darkGreen,
                                                                radius: cx
                                                                    .responsive(
                                                                        26,
                                                                        20,
                                                                        18),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Image
                                                                      .network(
                                                                    item
                                                                        .sportsList[
                                                                            index]
                                                                        .sportImage,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width:
                                                                      cx.height /
                                                                          66.7),
                                                              Flexible(
                                                                child: Text(
                                                                  item
                                                                      .sportsList[
                                                                          index]
                                                                      .sportName,
                                                                  style: TextStyle(
                                                                      fontSize: cx.height >
                                                                              800
                                                                          ? 19
                                                                          : 16),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                  softWrap:
                                                                      false,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                    ),
                                    selectedIndex >= 0
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CustomButton(
                                                color: Colors.black,
                                                text: "Proceed",
                                                fun: () {
                                                  cx.write(
                                                      Keys.sportId, sportId);
                                                  setState(() {
                                                    selectedIndex = -1;
                                                    cx.selDate.value =
                                                        DateFormat.d().format(
                                                            DateTime.now());
                                                    cx.selMonth.value =
                                                        DateFormat.MMM().format(
                                                            DateTime.now());
                                                    cx.selYear.value =
                                                        DateFormat.y().format(
                                                            DateTime.now());
                                                    cx.fullDate.value =
                                                        DateFormat("yyyy-MM-dd")
                                                            .format(
                                                                DateTime.now());
                                                    cx.currentDate.value =
                                                        DateTime.now();

                                                    cx.write(Keys.fullDate,
                                                        cx.fullDate.value);
                                                    cx.write(Keys.selDate,
                                                        cx.selDate.value);
                                                    cx.write(Keys.selMonth,
                                                        cx.selMonth.value);
                                                    cx.write(Keys.selYear,
                                                        cx.selYear.value);

                                                    cx.globalSelectedIndex = [];
                                                    cx.globalPrice.value = 0.0;

                                                    Get.back();
                                                    Get.to(BookSlot(
                                                      isEditing: false,
                                                    ));
                                                  });
                                                },
                                                radius: cx.height / 13.34,
                                                width: cx.width / 1.2,
                                                size: cx.responsive(25, 22, 15),
                                                textColor: Colors.white,
                                                padding: cx.height / 66.7,
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    Gap(20),
                                  ],
                                );
                              }));
                            },
                            child: Container(
                              width: cx.width / 1.1,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(cx.width / 13.34)),
                              padding: EdgeInsets.all(cx.height / 66.7),
                              child: Center(
                                child: NunitoText(
                                  text: "Select a Sport to Proceed",
                                  fontWeight: FontWeight.w700,
                                  fontSize: cx.responsive(24, 20, 18),
                                  color: Colors.black,
                                  textOverflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
