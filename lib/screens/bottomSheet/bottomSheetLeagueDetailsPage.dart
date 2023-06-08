import 'package:auto_size_text/auto_size_text.dart';
import 'package:domez/commonModule/Strings.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../commonModule/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../controller/commonController.dart';
import '../../controller/leagueDetailsController.dart';
import '../../model/LeagueDetailsModel.dart';

class BottomSheetLeaguesDetailsPage extends StatefulWidget {
  const BottomSheetLeaguesDetailsPage({Key? key}) : super(key: key);

  @override
  State<BottomSheetLeaguesDetailsPage> createState() =>
      _BottomSheetLeaguesDetailsPageState();
}

class _BottomSheetLeaguesDetailsPageState
    extends State<BottomSheetLeaguesDetailsPage> {
  bool expansion1 = false;
  bool expansion2 = false;
  bool expansion3 = false;
  CommonController cx = Get.put(CommonController());
  LeagueDetailsController mycontroller = Get.put(LeagueDetailsController());

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    final size = MediaQuery.of(context).size;
    LeagueDetailsModel item = mycontroller.myList[0];

    return Column(
      children: [
        Container(
          height: size.height / 2.7,
        ),
        Container(
          // height: size.height*2.2,
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
                      padding: EdgeInsets.fromLTRB(0, cx.height*0.04, 0, 0),
                      children: [

                        SenticText(
                          text: item.leagueName,
                          fontSize: cx.height > 800 ? 25 : 23,
                          fontWeight: FontWeight.w700,
                        ),
                        Gap(12),
                        Padding(
                          padding: const EdgeInsets.only(right:4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/images/location.png",
                                    scale: cx.responsive(2.5,1.5, 2),
                                  ),
                                  Container(
                                    width: cx.width*0.45,
                                    child: NunitoText(
                                      textAlign: TextAlign.start,
                                      text: " ${item.city}, ${item.state}",
                                      fontWeight: FontWeight.w600,
                                      fontSize: cx.height > 800 ? 18 : 14,
                                      color: Color(0xFF6F6B6B),
                                      textOverflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              NunitoText(
                                text: "Registration Deadline",
                                color: Color(0xFF6F6B6B),
                                fontSize: cx.responsive(16,13, 11),
                                fontWeight: FontWeight.w500,
                              )
                            ],
                          ),
                        ),
                        Gap(1),

                        Padding(
                          padding: const EdgeInsets.only(right:4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: cx.width*0.55,
                                child: Padding(
                                  padding: const EdgeInsets.only(left:1.5),
                                  child: NunitoText(
                                    textAlign: TextAlign.start,
                                    text: item.domeName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: cx.height > 800 ? 20 : 18,
                                    color: Color(0xFF757575),
                                    textOverflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              Container(
                                width: cx.width*0.25,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF5C5C),
                                  borderRadius: BorderRadius.circular(4)
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(0),
                                child: NunitoText(
                                  text: DateFormat.yMMMd().format(item.bookingDeadline),
                                  fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  textAlign: TextAlign.center,
                                  fontSize: cx.responsive(18,14, 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Color(0xFFF5F7F9),
                                    radius: cx.width / 25,
                                    child: Icon(
                                      Icons.add_circle_outline,
                                      color: Color(0xFF629C86),
                                      size: cx.responsive(30,24,20),
                                    ),
                                  ),
                                  Gap(5),
                                  Container(
                                    width: cx.width*0.17,
                                    child: NunitoText(
                                      textAlign: TextAlign.start,
                                      text: int.parse(item.fields)==1?item.fields+" Field":item.fields+" Fields",
                                      fontWeight: FontWeight.w500,
                                      fontSize: cx.height > 800 ? 17 : 15,
                                      color: Color(0xFFA8A8A8),
                                      textOverflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gap(3),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Color(0xFFF5F7F9),
                                    radius: cx.width / 25,
                                    child: Icon(
                                      Icons.access_time,
                                      color: Color(0xFF629C86),
                                      size: cx.responsive(30,24,20),
                                    ),
                                  ),
                                  Gap(5),
                                  Container(
                                    width: cx.width*0.45,
                                    child: NunitoText(
                                      textAlign: TextAlign.start,
                                      textOverflow: TextOverflow.ellipsis,
                                      text:item.time,
                                      fontWeight: FontWeight.w500,
                                      fontSize: cx.height > 800 ? 17 : 15,
                                      color: Color(0xFF9F9F9F),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Gap(7),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Color(0xFFF5F7F9),
                                    radius: cx.width / 25,
                                    child: Icon(
                                      Icons.calendar_month,
                                      color: Color(0xFF629C86),
                                      size: cx.responsive(30,24,20),
                                    ),
                                  ),
                                  Gap(5),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:cx.width*0.7,
                                        child: NunitoText(
                                          textAlign: TextAlign.start,
                                          text: item.date,
                                          fontWeight: FontWeight.w500,
                                          fontSize: cx.height > 800 ? 17 : 15,
                                          color: Color(0xFFA8A8A8),
                                          textOverflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Gap(4),
                                      Container(
                                        width:cx.width*0.72,

                                        child: NunitoText(
                                          textAlign: TextAlign.start,
                                          text: item.days,
                                          fontWeight: FontWeight.w700,
                                          fontSize: cx.height > 800 ? 17 : 15,
                                          color: AppColor.darkGreen,
                                          textOverflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Gap(4),

                                      Container(
                                        width:cx.width*0.7,

                                        child: NunitoText(
                                          textAlign: TextAlign.start,
                                          text: "Total Games : ${item.totalGames}",
                                          fontWeight: FontWeight.w600,
                                          fontSize: cx.height > 800 ? 17 : 15,
                                          color: Color(0xFF757575),
                                          textOverflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Gap(cx.height / 70),
                          ],
                        ),
                        Gap(7),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Color(0xFFF5F7F9),
                                    radius: cx.width / 25,
                                    child: Icon(
                                      Icons.female_sharp,
                                      color: Color(0xFF629C86),
                                      size: cx.responsive(30,24,20),
                                    ),
                                  ),
                                  Gap(5),
                                  NunitoText(
                                    textAlign: TextAlign.start,
                                    text: item.gender,
                                    fontWeight: FontWeight.w500,
                                    fontSize: cx.height > 800 ? 17 : 15,
                                    color: Color(0xFFA8A8A8),
                                    textOverflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            Gap(15),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Color(0xFFF5F7F9),
                                    radius: cx.width / 25,
                                    child: Icon(
                                      Icons.people_outline,
                                      color: Color(0xFF629C86),
                                      size: cx.responsive(30,24,20),
                                    ),
                                  ),
                                  Gap(5),
                                  Container(
                                    width: cx.width*0.4,
                                    child: NunitoText(
                                      textAlign: TextAlign.start,
                                      textOverflow: TextOverflow.ellipsis,
                                      text:
                                          item.age,
                                      fontWeight: FontWeight.w500,
                                      fontSize: cx.height > 800 ? 17 : 15,
                                      color: Color(0xFF9F9F9F),
                                      maxLines: 1,
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                        Gap(7),

                        Padding(
                          padding: const EdgeInsets.only(left:4.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: cx.width*0.28,
                                    child: NunitoText(
                                      textAlign: TextAlign.start,
                                      text: "Sport",
                                      fontWeight: FontWeight.w700,
                                      fontSize: cx.height > 800 ? 20 : 17,
                                      color: Color(0xFF757575),
                                    ),
                                  ),
                                  Container(
                                    width: cx.width*0.06,
                                    child: NunitoText(
                                      textAlign: TextAlign.start,
                                      text: ":",
                                      fontWeight: FontWeight.w500,
                                      fontSize: cx.height > 800 ? 20 : 17,
                                      color: Color(0xFF757575),
                                    ),
                                  ),
                                  Container(
                                    width: cx.width*0.5,
                                    child: NunitoText(
                                      textAlign: TextAlign.start,
                                      text: item.sport,
                                      fontWeight: FontWeight.w500,
                                      fontSize: cx.height > 800 ? 20 : 17,
                                      color: AppColor.darkGreen,
                                      textOverflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              Gap(6),

                              Row(
                                children: [
                                  Container(
                                    width: cx.width*0.28,
                                    child: NunitoText(
                                      textAlign: TextAlign.start,
                                      text: "Team Limit",
                                      fontWeight: FontWeight.w700,
                                      fontSize: cx.height > 800 ? 20 : 17,
                                      color: Color(0xFF757575),
                                    ),
                                  ),
                                  Container(
                                    width: cx.width*0.06,
                                    child: NunitoText(
                                      textAlign: TextAlign.start,
                                      text: ":",
                                      fontWeight: FontWeight.w500,
                                      fontSize: cx.height > 800 ? 20 : 17,
                                      color: Color(0xFF757575),
                                    ),
                                  ),
                                  Container(
                                    width: cx.width*0.5,
                                    child: NunitoText(
                                      textAlign: TextAlign.start,
                                      text: item.teamLimit,
                                      fontWeight: FontWeight.w500,
                                      fontSize: cx.height > 800 ? 20 : 17,
                                      color: AppColor.darkGreen,
                                      textOverflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              Gap(6),

                              Row(
                                children: [
                                  Container(
                                    width: cx.width*0.28,
                                    child: NunitoText(
                                      textAlign: TextAlign.start,
                                      text: "Min Players",
                                      fontWeight: FontWeight.w700,
                                      fontSize: cx.height > 800 ? 20 : 17,
                                      color: Color(0xFF757575),
                                    ),
                                  ),
                                  Container(
                                    width: cx.width*0.06,
                                    child: NunitoText(
                                      textAlign: TextAlign.start,
                                      text: ":",
                                      fontWeight: FontWeight.w500,
                                      fontSize: cx.height > 800 ? 20 : 17,
                                      color: Color(0xFF757575),
                                    ),
                                  ),
                                  Container(
                                    width: cx.width*0.5,
                                    child: NunitoText(
                                      textAlign: TextAlign.start,
                                      text: item.minPlayer,
                                      fontWeight: FontWeight.w500,
                                      fontSize: cx.height > 800 ? 20 : 17,
                                      color: AppColor.darkGreen,
                                      textOverflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              Gap(6),

                              Row(
                                children: [
                                  Container(
                                    width: cx.width*0.28,
                                    child: NunitoText(
                                      textAlign: TextAlign.start,
                                      text: "Max Players",
                                      fontWeight: FontWeight.w700,
                                      fontSize: cx.height > 800 ? 20 : 17,
                                      color: Color(0xFF757575),
                                    ),
                                  ),
                                  Container(
                                    width: cx.width*0.06,
                                    child: NunitoText(
                                      textAlign: TextAlign.start,
                                      text: ":",
                                      fontWeight: FontWeight.w500,
                                      fontSize: cx.height > 800 ? 20 : 17,
                                      color: Color(0xFF757575),
                                    ),
                                  ),
                                  Container(
                                    width: cx.width*0.5,
                                    child: NunitoText(
                                      textAlign: TextAlign.start,
                                      text: item.maxPlayer,
                                      fontWeight: FontWeight.w500,
                                      fontSize: cx.height > 800 ? 20 : 17,
                                      color: AppColor.darkGreen,
                                      textOverflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Gap(25),
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.5, color: Color(0xFFD8EAF1)),
                              borderRadius: BorderRadius.circular(7)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SenticText(
                                height: 1.2,
                                text: 'Location',
                                fontSize: cx.height > 800 ? 20 : 18,
                                fontWeight: FontWeight.w500,
                              ),
                              Gap(cx.height / 44.47),
                              InkWell(
                                onTap: () {
                                  openMap(item.lat, item.lng);
                                },
                                child: Image.asset(
                                  Image1.img,
                                  scale: cx.height > 800 ? 1.65 : 1.9,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(cx.height / 44.47),
                        SenticText(
                          height: 1.2,
                          text: 'Amenities',
                          fontSize: cx.height > 800 ? 20 : 18,
                          fontWeight: FontWeight.w500,
                        ),
                        Gap(8),
                        NunitoText(
                          textAlign: TextAlign.start,
                          text: item.amenitiesDescription,
                          fontWeight: FontWeight.w400,
                          fontSize: cx.height > 800 ? 17 : 14,
                          color: Color(0xFF444444),
                          textOverflow: TextOverflow.ellipsis,
                        ),
                        Gap(cx.height / 33.5),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          direction: Axis.horizontal,
                          children: List.generate(
                            item.amenities.length,
                                (index) {
                              return InkWell(
                                child: Container(
                                  width: cx.width / 2.4,
                                  padding: EdgeInsets.fromLTRB(
                                    cx.height / 66.7,
                                    cx.height / 51.31,
                                    8,
                                    cx.height / 51.31,
                                  ),
                                  decoration: BoxDecoration(
                                      border:
                                      Border.all(color: Color(0xFFD4D4D4)),
                                      borderRadius: BorderRadius.circular(
                                          cx.height / 41.7)),
                                  child: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundImage: AssetImage(
                                          item.amenities[index].benefit=="Changing Room"?
                                          "assets/images/changingroom.png":item.amenities[index].benefit=="Free Wifi"?
                                          "assets/images/freeWifi.png":item.amenities[index].benefit=="Pool"?
                                          "assets/images/pool.png":item.amenities[index].benefit=="Parking"?
                                          "assets/images/parking.png":item.amenities[index].benefit=="Others"?
                                          "assets/images/others.png":"assets/images/changingroom.png",

                                        ),
                                      ),
                                      SizedBox(width: cx.width / 50),
                                      Container(
                                        width: (cx.width / 2.4)*0.5,
                                        child: AutoSizeText(
                                          item.amenities[index].benefit,
                                          // softWrap: false,
                                          maxLines: 2,

                                          style: TextStyle(
                                            fontSize:
                                            cx.height > 800 ? 18 : 15,
                                            overflow: TextOverflow.clip,
                                            // softWrap: false,
                                            // maxLines: 2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Gap(cx.height / 9.53)
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
