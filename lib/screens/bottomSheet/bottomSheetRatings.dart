
import 'package:domez/model/ratingListModel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../commonModule/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../controller/commonController.dart';
import '../../controller/domesDetailsController.dart';
import '../../controller/ratingListController.dart';
import '../../model/domesDetailsModel.dart';

class BottomSheetRatings extends StatefulWidget {
  const BottomSheetRatings({Key? key}) : super(key: key);

  @override
  State<BottomSheetRatings> createState() => _BottomSheetRatingsState();
}

class _BottomSheetRatingsState extends State<BottomSheetRatings> {

  int domeId = 0;
  CommonController cx = Get.put(CommonController());
  DomesDetailsController mycontroller = Get.put(DomesDetailsController());
  RatingListController ratingListController = Get.put(RatingListController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      domeId = mycontroller.myList[0].id;
    });
  }

  @override
  Widget build(BuildContext context) {

    DomesDetailsModel item = mycontroller.myList[0];

    return Column(
      children: [
        Container(
          height: cx.height / 2.7,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(cx.height / 13.34),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                left: cx.height / 33.5, right: cx.height / 44.47),
            child: Obx(
              () => mycontroller.myList.length <= 0
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/images/location.png",
                                scale: cx.responsive(1,1.5, 2),
                              ),
                              NunitoText(
                                textAlign: TextAlign.start,
                                text: " ${item.city}, ${item.state}",
                                fontWeight: FontWeight.w600,
                                fontSize: cx.height > 800 ? 18 : 15,
                                color: Color(0xFF6F6B6B),
                              ),
                            ],
                          ),
                        ),
                        SenticText(
                          text: item.name,
                          fontSize: cx.height > 800 ? 28 : 25,
                          fontWeight: FontWeight.w700,
                        ),
                        Gap(cx.height / 60),
                        Container(
                          height: cx.height / 10,
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F7F9),
                            borderRadius:
                                BorderRadius.circular(cx.height / 9.53),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: cx.responsive(16,12, 10),
                              right: cx.responsive(16,12, 10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: cx.responsive(16,12, 10)),
                                      child: Icon(
                                        Icons.star,
                                        color: Color(0xFFFFC439),
                                        size: cx.responsive(39,30, 25),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        NunitoText(
                                          textAlign: TextAlign.start,
                                          text: double.parse(item.
                                              rattingData.avgRating).toStringAsFixed(2),
                                          fontWeight: FontWeight.w700,
                                          fontSize: cx.height > 800 ? 21 : 19,
                                          color: Color(0xFF6F6B6B),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                NunitoText(
                                  textAlign: TextAlign.start,
                                  text:
                                      // item.totalReview
                                      item.rattingData.totalReview.toStringAsFixed(0) + " Reviews",
                                  fontWeight: FontWeight.w600,
                                  fontSize: cx.height > 800 ? 17 : 15,
                                  color: Color(0xFF9F9F9F),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gap(cx.height / 37.06),
                        InkWell(
                          onTap: () {
                            // showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) =>
                            //         onRatingsPopUp());
                          },
                          child:  Obx(()=>ratingListController.isDataProcessing.value
                                ? Container(
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.darkGreen,
                                ),
                              ),
                            )
                                : ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: ratingListController.myList.length,
                              itemBuilder: (context, index) {
                                RatingListModel item = ratingListController.myList[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey, width: 0.6),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      children: [
                                        Gap(10),
                                        ListTile(
                                          dense: true,

                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              item.userImage,
                                            ),
                                            radius: 20,
                                          ),
                                          // title:const Text("Dome Stadium",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                                          title: InterText(
                                              text: item.userName,
                                              fontSize: cx.height > 800 ? 20 : 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Gap(5),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 12, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: RatingStars(
                                                  value: item.ratting.toDouble(),
                                                  // onValueChanged: (v) {
                                                  //   //
                                                  //   setState(() {
                                                  //     value = v;
                                                  //   });
                                                  // },
                                                  starBuilder: (index, color) =>
                                                      Icon(
                                                    Icons.star,
                                                    color: color,
                                                    size: 18,
                                                  ),
                                                  starCount: 5,
                                                  starSize: 18,
                                                  maxValue: 5,
                                                  starSpacing: 0,
                                                  maxValueVisibility: true,
                                                  valueLabelVisibility: false,
                                                  animationDuration: Duration(
                                                      milliseconds: 1000),
                                                  starOffColor:
                                                      const Color(0xffe7e8ea),
                                                  starColor: Color(0xFFFFC439),
                                                ),
                                              ),
                                              Container(
                                                width: cx.width * 0.5,
                                                child: NunitoText(
                                                  text: item.createdAt,
                                                  color: Color(0xFFA8A8A8),
                                                  fontWeight: FontWeight.w600,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.end,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Gap(10),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: cx.width*0.85,

                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 0, 12, 0),
                                                child: NunitoText(
                                                  text: item.comment,
                                                  textOverflow:
                                                      TextOverflow.clip,
                                                  maxLines: 4,
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Gap(10),
                                        item.replyMessage.isNotEmpty
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFF5F7F9),
                                                      border: Border.all(
                                                          color: Colors.grey,
                                                          width: 0.6),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                  child: Column(
                                                    children: [
                                                      Gap(15),

                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                15, 0, 10, 0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            InterText(
                                                                text:
                                                                    item.domeOwnerName,
                                                                fontSize:
                                                                    cx.height >
                                                                            800
                                                                        ? 20
                                                                        : 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            NunitoText(
                                                              text:
                                                                  item.repliedAt,
                                                              color: Color(
                                                                  0xFFA8A8A8),
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Gap(7),

                                                      Container(
                                                        width: cx.width*0.8,

                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets.fromLTRB(
                                                                      15, 0, 10, 0),
                                                              child: NunitoText(
                                                                text: item.replyMessage,
                                                                textOverflow:
                                                                    TextOverflow
                                                                        .clip,
                                                                maxLines: 4,
                                                                textAlign:
                                                                    TextAlign.start,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Gap(10),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Gap(cx.height / 37.06),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  openMap(String lat, String Lng) async {
    String googleURL =
        "https://www.google.com/maps/search/?api=1&query=$lat,$Lng";

    await canLaunchUrlString(googleURL)
        ? await launchUrlString(googleURL)
        : throw 'Could not launch $googleURL';
  }


}
