import 'package:domez/model/domesDetailsModel.dart';
import '../../../commonModule/AppColor.dart';
import '../../commonModule/widget/common/textNunito.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:page_indicator/page_indicator.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/widget/search/simplecircularIcon.dart';
import '../../controller/commonController.dart';
import '../../controller/domesDetailsController.dart';
import '../bottomSheet/bottomSheetRatings.dart';
import '../../commonModule/utils.dart';


class Ratings extends StatefulWidget {
  // bool isFav;
  // bool did;
  Ratings({
    Key? key,
    // required this.isFav,
    // required this.did
  }) : super(key: key);

  @override
  State<Ratings> createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> {
  bool fav = false;
  CommonController cx = Get.put(CommonController());
  final mycontroller = Get.put(DomesDetailsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DomesDetailsModel item = mycontroller.myList[0];
    // FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: AppColor.darkGreen,
        extendBody: true,
        // resizeToAvoidBottomInset: true,
        // key: _scaffoldkey,
        body: SafeArea(
          top: false,
          bottom:false,
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
                ),
                child: mycontroller.isoffline.value
                    ? noInternetLottie()
                    : mycontroller.isDataProcessing.value
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColor.darkGreen,
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
                                            'Oops!No ratings available for this dome',
                                        textAlign: TextAlign.center,
                                        fontSize: cx.responsive(35,27, 23),
                                        color: Colors.grey.shade600),
                                  ),
                                ],
                              )
                            : ListView(
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
                                                    return Container(
                                                        child: Image.network(
                                                      item.domeImages[i].image
                                                          .toString(),
                                                      fit: BoxFit.cover,
                                                      // color: AppColor.bg,
                                                    ));
                                                  })),
                                        ),
                                      ),
                                      Positioned(
                                        left: cx.height > 800 ? 25 : 20,
                                        top: cx.responsive(80,55, 38),
                                        child: InkWell(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: cx.responsive(30,24, 17),
                                            child: SimpleCircularIconButton(
                                              iconData:
                                                  Icons.arrow_back_ios_new,
                                              fillColor: Colors.red,
                                              radius: cx.responsive(60,45, 35),
                                            ),
                                          ),
                                        ),
                                      ),
                                      BottomSheetRatings(),
                                    ],
                                  ),
                                ],
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
