
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
import 'availableFields.dart';
class SelectPlayers extends StatefulWidget {
  bool isEditing;
  SelectPlayers({Key? key,required this.isEditing}) : super(key: key);
  @override
  State<SelectPlayers> createState() => _SelectPlayersState();
}

class _SelectPlayersState extends State<SelectPlayers> {
  CommonController cx = Get.put(CommonController());
  int playerCount=12;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isEditing){
      playerCount=cx.read(Keys.players);
    }
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
                                      height: cx.height / 8.4,
                                      decoration: BoxDecoration(
                                          color: Color(0xFFFFFFFF),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  cx.height / 66.7))),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          ListTile(
                                            // title:const Text("Dome Stadium",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                                            title: SenticText(
                                                text: cx.read(Keys.domeName),
                                                fontSize:
                                                cx.height > 800 ? 25 : 21,
                                                fontWeight: FontWeight.w600),
                                            subtitle: Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(
                                                  0, 4, 0, 4),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Image.asset(
                                                    "assets/images/location.png",
                                                    scale: cx.responsive(2.5,1.5, 2),
                                                      color:AppColor.darkGreen

                                                  ),
                                                  Container(
                                                    width:cx.width*0.65,
                                                    child: NunitoText(
                                                      textAlign: TextAlign.start,
                                                      text: "${cx.read(Keys.city)}, ${cx.read(Keys.state)}",
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: cx.height > 800
                                                          ? 18
                                                          : 15,
                                                      color: AppColor.lightGreen,
                                                      textOverflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
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
                                      topRight:
                                      Radius.circular(cx.height / 16.7),
                                      topLeft:
                                      Radius.circular(cx.height / 16.7),
                                    )),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      cx.height / 26.68,
                                      8,
                                      cx.height / 26.68,
                                      cx.height / 83.375),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [

                                      Gap(cx.height / 40),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: InterText(
                                          text: "Number Of Players",
                                          fontSize: cx.responsive(33,27, 25),
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Gap(cx.height / 30),
                                      NunitoText(
                                        text: "Select Number Of Players",
                                        fontSize: cx.responsive(24,20, 18),
                                        color: AppColor.darkGreen,
                                        fontWeight: FontWeight.w500,
                                        textAlign: TextAlign.center,
                                      ),
                                      Gap(cx.height / 50),

                                      Container(
                                        height: cx.width/2.7,
                                        width: cx.width/2.7,
                                        decoration: BoxDecoration(
                                            color: AppColor.bg,
                                            border: Border.all(
                                              color: Color(0xFF9BD9C1)
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topRight:
                                              Radius.circular(cx.width / 14),
                                              topLeft:
                                              Radius.circular(cx.width / 14),
                                              bottomRight:
                                              Radius.circular(cx.width / 14),
                                              bottomLeft:
                                              Radius.circular(cx.width / 14),
                                            )),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Gap(13),
                                            Image.asset(
                                                "assets/images/prof.png",
                                              scale:1.7,

                                            ),
                                            NunitoText(
                                              text: playerCount.toString(),
                                              color:Color(0xFF628477),
                                              fontWeight: FontWeight.bold,
                                              fontSize: cx.responsive(80,65, 55),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Gap(cx.height / 45),
                                      Container(
                                        height: cx.width/2.7,
                                        width: cx.width/2.7,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap:
                                                  () {
                                                setState(
                                                        () {
                                                      if (playerCount >= 2) {
                                                        playerCount--;
                                                      }
                                                    });
                                              },
                                              child:
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    0,
                                                    0,
                                                    9,
                                                    0),
                                                child:
                                                CircleAvatar(
                                                  backgroundColor:
                                                  const Color(0xFF88C8AF),
                                                  radius:
                                                  cx.height / 40,
                                                  child: CircleAvatar(
                                                      backgroundColor: Colors.white,
                                                      radius: cx.height /42,
                                                      child: const Icon(
                                                        Icons.remove,
                                                        color: Color(0xFF88C8AF),
                                                      )),
                                                ),
                                              ),
                                            ),
                                            Gap(cx.width/40),
                                            InkWell(
                                              onTap:
                                                  () {
                                                setState(
                                                        () {
                                                      if (playerCount <= 29) {
                                                        playerCount++;
                                                      }
                                                    });
                                              },
                                              child:
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    0,
                                                    0,
                                                    0,
                                                    0),
                                                child:
                                                CircleAvatar(
                                                  backgroundColor:
                                                  const Color(0xFF88C8AF),
                                                  radius:
                                                  cx.height / 40,
                                                  child: CircleAvatar(
                                                      backgroundColor: Colors.white,
                                                      radius: cx.height / 42,
                                                      child: const Icon(
                                                        Icons.add,
                                                        color: Color(0xFF88C8AF),
                                                      )),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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
                MediaQuery.of(context).viewInsets.bottom==0.0
                    ?Positioned(
                  bottom: -29,
                  child: (SvgPicture.asset(
                      "assets/svg/leftBottomNavigation.svg",
                      color: AppColor.darkGreen)),
                ):Container(),
                MediaQuery.of(context).viewInsets.bottom==0.0
                    ?Positioned(
                  bottom: -29,
                  right: 0,
                  child: (SvgPicture.asset(
                      "assets/svg/rightBottomNavigation.svg",
                      color: AppColor.darkGreen)),
                ):Container(),
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
                              text: "\$" +
                                  cx.read(Keys.price).toString() +
                                  " ",
                              fontSize: cx.height > 800 ? 23 : 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            SenticText(
                              text:
                              "(${cx.read(Keys.slots)} Slots Selected)",
                              fontSize: cx.height > 800 ? 12 : 10,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        Gap(3),
                        SenticText(
                          text: cx
                              .read(Keys.startTime)
                              .toString()
                              .substring(0, 8) +
                              " - " +
                              cx
                                  .read(Keys.endTime)
                                  .toString()
                                  .substring(11, 19),
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
                          text: widget.isEditing?"Confirm":"Proceed",
                          fun: () {
                            if(!widget.isEditing){
                              cx.globalAvailableFieldIndex.clear();
                              cx.globalAvailableFieldName.clear();
                            }

                            cx.write(Keys.players,playerCount);
                            widget.isEditing?Get.back(result: playerCount):Get.to(AvailableFields(isEditing: false),)?.then((value) => refreshData());
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
            )

        ),
      );
  }
  refreshData() {
    print("heyplayer");
    cx.write(Keys.price,cx.globalPrice.value);

      setState((){
        playerCount=cx.read(Keys.players);
      });
  }
}
