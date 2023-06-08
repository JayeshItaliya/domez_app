import 'package:domez/screens/bookSteps/availableFields.dart';
import 'package:domez/screens/bookSteps/bookSlot.dart';
import 'package:domez/screens/bookSteps/receipt.dart';
import 'package:domez/screens/bookSteps/selectPlayers.dart';
import 'package:domez/screens/bookSteps/verticalDivider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:domez/commonModule/Strings.dart';

import 'package:flutter/material.dart';
import '../../../commonModule/AppColor.dart';
import '../../../controller/commonController.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../commonModule/widget/search/customButton.dart';
import '../../commonModule/widget/search/simplecircularIcon.dart';

class ReviewConfirm extends StatefulWidget {
  const ReviewConfirm({Key? key}) : super(key: key);

  @override
  State<ReviewConfirm> createState() => _ReviewConfirmState();
}

class _ReviewConfirmState extends State<ReviewConfirm> {
  CommonController cx = Get.put(CommonController());
  int playerCount = 12;
  int curfieldindex = 0;
  String startTime = '';
  String endTime = '';
  String fieldName='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTime = cx.read(Keys.startTime);
    endTime = cx.read(Keys.endTime);
    playerCount = cx.read(Keys.players);
    fieldName=cx.read(Keys.fieldName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          body: Stack(
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
                        ])),
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: cx.height / 4.09,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 8, right: 8, top: 8),
                                  width: MediaQuery.of(context).size.width,
                                  height: cx.height / 4.3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(cx.height / 26.68)),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/step.png"),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Positioned(
                                  // top: cx.responsive(200,167, 130),
                                  top: cx.height / 6.06,
                                  right: 20,
                                  left: 20,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: cx.height / 8.5,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFFFFFFF),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(cx.height / 66.7))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ListTile(
                                          // title:const Text("Dome Stadium",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                                          title: SenticText(
                                              text: "Dome Stadium",
                                              fontSize:
                                                  cx.height > 800 ? 25 : 21,
                                              fontWeight: FontWeight.w600),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 4, 0, 4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                    "assets/images/location.png",
                                                    scale:
                                                        cx.responsive(2.5,1.5, 2),
                                                    color: AppColor.darkGreen),
                                                NunitoText(
                                                  textAlign: TextAlign.start,
                                                  text: "Austin, Texas",
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      cx.height > 800 ? 18 : 15,
                                                  color: AppColor.lightGreen,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: cx.height > 800 ? 47 : 37,
                          top: cx.height / 33.5,
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: cx.responsive(30,25, 22),
                              child: SimpleCircularIconButton(
                                iconData: Icons.arrow_back_ios_new,
                                iconColor: Colors.black,
                                radius: cx.responsive(60,47, 37),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: size.height / 2.9,
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(cx.height / 16.7),
                                    topLeft: Radius.circular(cx.height / 16.7),
                                  )),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(cx.height / 26.68,
                                    8, cx.height / 26.68, cx.height / 83.375),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Gap(cx.height / 40),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: InterText(
                                        text: "Review & Confirm",
                                        fontSize: cx.responsive(33,27, 25),
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Gap(cx.height / 30),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            var result = await Get.to(
                                              BookSlot(isEditing: true),
                                            );
                                            if (result != null) {
                                              print("update");
                                              print(result);
                                              cx.write(
                                                  Keys.startTime, result[0]);
                                              cx.write(Keys.endTime, result[1]);
                                              setState(() {
                                                startTime =
                                                    cx.read(Keys.startTime);
                                                endTime = cx.read(Keys.endTime);
                                              });

                                              cx.update();
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xFFE7F4EF),
                                                border: Border.all(
                                                    color: Color(0xFF9BD9C1)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50))),
                                            child: ListTile(
                                              minLeadingWidth: 0,
                                              contentPadding: EdgeInsets.zero,
                                              leading: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: Icon(
                                                  Icons.check_circle_rounded,
                                                  color: Colors.black,
                                                  size: cx.responsive(40,34, 30),
                                                ),
                                              ),
                                              title: Row(
                                                children: [
                                                  NunitoText(
                                                    text: "Date:  ",
                                                    fontSize:
                                                        cx.responsive(22,17, 15),
                                                    color: AppColor.darkGreen,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  Obx(
                                                    () => Padding(
                                                      padding: const EdgeInsets.only(top:1.0),
                                                      child: NunitoText(
                                                        text: cx.selDate.value +
                                                            " " +
                                                            cx.selMonth.value,
                                                        color: Color(0xFF628477),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                        cx.responsive(25,19, 17),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              trailing: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                  0,
                                                  0,
                                                  12,
                                                  3,
                                                ),
                                                child: SvgPicture.asset(
                                                  "assets/svg/edit.svg",
                                                  color: AppColor.darkGreen,
                                                  height: cx.responsive(24,21, 19),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        VerticDivider(true),
                                        InkWell(
                                          onTap: () async {
                                            var result = await Get.to(
                                              BookSlot(isEditing: true),
                                            );
                                            if (result != null) {
                                              print("update");
                                              print(result);
                                              cx.write(
                                                  Keys.startTime, result[0]);
                                              cx.write(Keys.endTime, result[1]);
                                              setState(() {
                                                startTime =
                                                    cx.read(Keys.startTime);
                                                endTime = cx.read(Keys.endTime);
                                              });

                                              cx.update();
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xFFE7F4EF),
                                                border: Border.all(
                                                    color: Color(0xFF9BD9C1)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50))),
                                            child: ListTile(
                                              minLeadingWidth: 0,
                                              contentPadding: EdgeInsets.zero,
                                              leading: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: Icon(
                                                  Icons.check_circle_rounded,
                                                  color: Colors.black,
                                                  size: cx.responsive(40,34, 30),
                                                ),
                                              ),
                                              title: Row(
                                                children: [
                                                  NunitoText(
                                                    text: "Time: ",
                                                    fontSize:
                                                        cx.responsive(18,15, 13),
                                                    color: AppColor.darkGreen,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  Container(
                                                    width: cx.width * 0.43,
                                                    child: NunitoText(
                                                      text: startTime
                                                              .toString()
                                                              .substring(0, 5) +
                                                          startTime
                                                              .toString()
                                                              .substring(6, 8) +
                                                          " - " +
                                                          endTime
                                                              .toString()
                                                              .substring(
                                                                  11, 16) +
                                                          endTime
                                                              .toString()
                                                              .substring(
                                                                  17, 19),
                                                      color: Color(0xFF628477),
                                                      fontWeight:
                                                          FontWeight.bold,

                                                      fontSize:
                                                          cx.responsive(22,18, 16),
                                                      textOverflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              trailing: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                  0,
                                                  0,
                                                  12,
                                                  3,
                                                ),
                                                child: SvgPicture.asset(
                                                  "assets/svg/edit.svg",
                                                  color: AppColor.darkGreen,
                                                  height: cx.responsive(24,21, 19),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        VerticDivider(true),
                                        InkWell(
                                          onTap: () async {
                                            var result = await Get.to(
                                              SelectPlayers(isEditing: true),
                                            );
                                            if (result != null) {
                                              print("update");
                                              print(result);
                                              cx.write(
                                                  Keys.players, result);
                                              setState(() {
                                                playerCount =
                                                    cx.read(Keys.players);
                                              });

                                              cx.update();
                                            }

                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xFFE7F4EF),
                                                border: Border.all(
                                                    color: Color(0xFF9BD9C1)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50))),
                                            child: ListTile(
                                              minLeadingWidth: 0,
                                              contentPadding: EdgeInsets.zero,
                                              leading: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: Icon(
                                                  Icons.check_circle_rounded,
                                                  color: Colors.black,
                                                  size: cx.responsive(40,34, 30),
                                                ),
                                              ),
                                              title: Row(
                                                children: [
                                                  NunitoText(
                                                    text: "Players Selected:  ",
                                                    fontSize:
                                                        cx.responsive(22,17, 15),
                                                    color: AppColor.darkGreen,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  NunitoText(
                                                    text: cx
                                                        .read(Keys.players)
                                                        .toString(),
                                                    color: Color(0xFF628477),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                    cx.responsive(25,19, 17),
                                                  ),
                                                ],
                                              ),
                                              trailing: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                  0,
                                                  0,
                                                  12,
                                                  3,
                                                ),
                                                child: SvgPicture.asset(
                                                  "assets/svg/edit.svg",
                                                  color: AppColor.darkGreen,
                                                  height: cx.responsive(24,21, 19),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        VerticDivider(true),
                                        InkWell(
                                          onTap: () async {
                                            var result = await Get.to(
                                              AvailableFields(isEditing: true),
                                            );
                                            if (result != null) {
                                              print("update");
                                              print(result);
                                              cx.write(
                                                  Keys.fieldName, result);
                                              setState(() {
                                                fieldName =
                                                    cx.read(Keys.fieldName);
                                              });

                                              cx.update();
                                            }

                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xFFE7F4EF),
                                                border: Border.all(
                                                    color: Color(0xFF9BD9C1)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50))),
                                            child: ListTile(
                                              minLeadingWidth: 0,
                                              contentPadding: EdgeInsets.zero,
                                              leading: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: Icon(
                                                  Icons.check_circle_rounded,
                                                  color: Colors.black,
                                                  size: cx.responsive(40,34, 30),
                                                ),
                                              ),
                                              title: Row(
                                                children: [
                                                  NunitoText(
                                                    text: "Field:  ",
                                                    fontSize:
                                                        cx.responsive(22,17, 15),
                                                    color: AppColor.darkGreen,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  Container(
                                                    child: NunitoText(
                                                      text: fieldName,
                                                      color: Color(0xFF628477),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                      cx.responsive(25,19, 17),
                                                      textOverflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                    width: cx.width * 0.25,
                                                  ),
                                                ],
                                              ),
                                              trailing: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                  0,
                                                  0,
                                                  12,
                                                  3,
                                                ),
                                                child: SvgPicture.asset(
                                                  "assets/svg/edit.svg",
                                                  color: AppColor.darkGreen,
                                                  height: cx.responsive(24,21, 19),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Gap(cx.height / 40),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
          bottomNavigationBar: Container(
            height: cx.height / 8.9,
            color: AppColor.darkGreen,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SenticText(
                            text: "\$" + cx.read(Keys.price).toString() + " ",
                            fontSize: cx.height > 800 ? 23 : 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          SenticText(
                            text: "(${cx.read(Keys.slots)} Slots Selected)",
                            fontSize: cx.height > 800 ? 12 : 10,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      Gap(3),
                      SenticText(
                        text:
                            cx.read(Keys.startTime).toString().substring(0,8) +
                            " - " +
                            cx.read(Keys.endTime).toString().substring(11, 19),
                        fontSize: cx.height > 800 ? 17 : 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9AE3C7),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom:  cx.responsive(cx.height / 25, cx.height / 35, cx.height / 50)),
                    child: Container(
                      child: CustomButton(
                        text: "Proceed",
                        fun: () {
                          Get.to(
                            Receipt(),
                          );
                        },
                        radius: cx.height / 13.34,
                        width: cx.width *0.32,
                        size: cx.responsive(24,20, 18),
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
