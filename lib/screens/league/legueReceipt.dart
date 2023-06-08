import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:domez/screens/authPage/signUp.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import '../../commonModule/AppColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ticket_widget/ticket_widget.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/Strings.dart';
import '../../commonModule/widget/common/webView.dart';
import '../../controller/commonController.dart';
import 'package:http/http.dart'as http;
import '../authPage/signIn.dart';
import '../payment/stripePayment.dart';
import 'finalLeagueReceipt.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/mySeperator.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/search/simplecircularIcon.dart';
import '../../commonModule/widget/common/textSentic.dart';


class LeagueReceipt extends StatefulWidget {
  const LeagueReceipt({Key? key}) : super(key: key);

  @override
  State<LeagueReceipt> createState() => _LeagueReceiptState();
}

class _LeagueReceiptState extends State<LeagueReceipt> {
  CommonController cx = Get.put(CommonController());
  bool fav = false;
  bool emailCorrect = false;
  TextEditingController bottomEmailController = TextEditingController();
  TextEditingController searchController =TextEditingController();
  final GlobalKey<FormState> bottomEmailKey = GlobalKey<FormState>();

  TextEditingController controller = TextEditingController(text: "");
  String thisText = "";
  int pinLength = 4;
  bool hasError = false;
  String currentText = "";
  bool isconfirm = true;
  bool isprocessing = false;
  bool isuccessful = false;
  bool isfailed = false;
  bool isPaymentAPICalling = false;
  double serviceCharge = 0.05;
  double serviceFee = 0.05;
  double hst = 45;
  double total = 45;
  Map<String, dynamic>? paymentIntent;
  bool isExpandCancellation = false;
  bool isDataProcesssing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      print("HST Percent");
      print(cx.read(LKeys.hstPercent));

      serviceFee = cx.read(LKeys.price) * serviceCharge;
      cx.write(LKeys.serviceFee, serviceFee);

      print("HST1");
      hst = cx.read(LKeys.price) * cx.read(LKeys.hstPercent);
      cx.write(LKeys.totalHST, hst);

      total = cx.read(LKeys.price) + serviceFee + hst;
      cx.write(LKeys.total, total);

    });
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      top:false,
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: true,
          backgroundColor: AppColor.bg,
          body: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              Container(
                height: cx.read("islogin") ? cx.height * 1.15 : cx.height * 1.35,
                decoration: BoxDecoration(
                  color: AppColor.bg,
                  borderRadius: BorderRadius.only(
                      bottomLeft:
                      Radius.elliptical(cx.height / 16.7, cx.height / 23.82),
                      bottomRight:
                      Radius.elliptical(cx.height / 16.7, cx.height / 23.82)),
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: cx.read("islogin")?
                            isExpandCancellation?cx.height * 2: cx.height * 1.9:
                            isExpandCancellation?cx.height * 2.33: cx.height * 2.23,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  margin:
                                  EdgeInsets.only(left: 8, right: 8, top: 8),
                                  width: MediaQuery.of(context).size.width,
                                  height: cx.height / 4.3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(cx.height / 26.68)),
                                    image: DecorationImage(
                                        image:AssetImage("assets/images/step.png"),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: cx.responsive(60,47, 37),
                          top: cx.responsive(33,25, 20),
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 22,
                              child: SimpleCircularIconButton(
                                iconData: Icons.arrow_back_ios_new,
                                iconColor:
                                fav ? AppColor.darkGreen : Colors.black,
                                radius: cx.responsive(50,42, 37),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: cx.height / 6.06,
                          right: 2,
                          left: 4,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 0,
                                left: cx.width*0.09,
                                right: cx.width*0.09,
                                bottom: 10),
                            child: Container(
                              height: cx.height * 1.6,

                              decoration: BoxDecoration(
                                  color: AppColor.bg,
                                  borderRadius:
                                  BorderRadius.circular(cx.height / 44.47)),
                              child: ListView(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                cx.height / 37.06),
                                            topRight: Radius.circular(
                                                cx.height / 37.06))),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  241, 247, 236, 0.6),
                                              borderRadius: BorderRadius.circular(
                                                  cx.height / 44.47)),
                                          child: ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20,
                                                cx.height / 55.58,
                                                cx.height / 44.47,
                                                0),
                                            title: Container(
                                              width: cx.width*0.78,
                                              child: SenticText(
                                                text: cx.read(LKeys.leagueName),
                                                fontSize: cx.height > 800 ? 25 : 22,
                                                fontWeight: FontWeight.w500,
                                                color:AppColor.darkGreen,
                                                textOverflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                             )
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      color:Colors.white,
                                      padding: const EdgeInsets.only(left:12.0),
                                      child:Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Gap(cx.height / 66.7),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              "assets/images/location.png",
                                              scale: cx.responsive(2.5,1.5, 2),
                                            ),
                                            Container(
                                              width:cx.width*0.6,
                                              child: NunitoText(
                                                textAlign: TextAlign.start,
                                                text: cx.read(LKeys.city)+', '+cx.read(LKeys.state),
                                                fontWeight: FontWeight.w600,
                                                fontSize: cx.height > 800 ? 18 : 14,
                                                color: Color(0xFF6F6B6B),
                                                textOverflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Gap(4),

                                        Container(
                                          width:cx.width*0.7,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left:1.5),
                                            child: InterText(
                                              textAlign: TextAlign.start,
                                              text: cx.read(LKeys.domeName),
                                              fontWeight: FontWeight.w500,
                                              fontSize: cx.height > 800 ? 20 : 17,
                                              color: Colors.black,

                                            ),
                                          ),
                                        ),
                                        Gap(cx.height*0.02),

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
                                                    radius: cx.responsive(28,20, 14),
                                                    child: Icon(
                                                      Icons.add_circle_outline,
                                                      color: Color(0xFF629C86),
                                                      size: cx.responsive(26,20, 16),
                                                    ),
                                                  ),
                                                  Gap(10),
                                                  Container(
                                                    width:cx.width*0.15,
                                                    child: NunitoText(
                                                      textAlign: TextAlign.start,
                                                      text: int.parse(cx.read(LKeys.fieldName))==1?"${cx.read(LKeys.fieldName)} Field":"${cx.read(LKeys.fieldName)} Fields",
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: cx.height > 800 ? 16 : 14,
                                                      color: Color(0xFFA8A8A8),
                                                      textOverflow: TextOverflow.ellipsis,
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
                                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: Color(0xFFF5F7F9),
                                                radius: cx.responsive(28,20, 14),
                                                child: Icon(
                                                  Icons.access_time,
                                                  color: Color(0xFF629C86),
                                                  size: cx.responsive(26,20, 16),
                                                ),
                                              ),
                                              Gap(10),
                                              Container(
                                                width: cx.width*0.6,
                                                child: NunitoText(
                                                  textAlign: TextAlign.start,
                                                  textOverflow: TextOverflow.ellipsis,
                                                  text: cx.read(LKeys.time),

                                                  fontWeight: FontWeight.w500,
                                                  fontSize: cx.height > 800 ? 16 : 14,
                                                  color: Color(0xFF9F9F9F),
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Gap(7),

                                      ],
                                    )
                                  ),
                                  TicketWidget(
                                    color: AppColor.ticketWidget,
                                    width: MediaQuery.of(context).size.width,
                                    isCornerRounded: false,
                                    padding: const EdgeInsets.all(0),
                                    height: cx.height * 0.78,
                                    child: Column(
                                      // shrinkWrap: true,
                                      // physics: ClampingScrollPhysics(),
                                      children: [
                                        Container(
                                          height: cx.height * 0.39,
                                          width:double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left:12.0),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [


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
                                                            radius: cx.responsive(28,20, 14),
                                                            child: Icon(
                                                              Icons.calendar_month,
                                                              color: Color(0xFF629C86),
                                                              size: cx.responsive(26,20, 16),
                                                            ),
                                                          ),
                                                          Gap(10),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                width:cx.width*0.6,
                                                                child: NunitoText(
                                                                  textAlign: TextAlign.start,
                                                                  text: cx.read(LKeys.date),
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: cx.height > 800 ? 16 : 14,
                                                                  color: Color(0xFFA8A8A8),
                                                                  textOverflow: TextOverflow.ellipsis,
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                              Gap(3),
                                                              Container(
                                                                width:cx.width*0.6,
                                                                child: NunitoText(
                                                                  textAlign: TextAlign.start,
                                                                  text: cx.read(LKeys.days),
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: cx.height > 800 ? 16 : 14,
                                                                  color: AppColor.darkGreen,
                                                                  textOverflow: TextOverflow.ellipsis,
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                              Gap(3),

                                                              Container(
                                                                width:cx.width*0.6,
                                                                child: NunitoText(
                                                                  textAlign: TextAlign.start,
                                                                  text: "Total Games : ${cx.read(LKeys.totalGames)}",
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: cx.height > 800 ?16 : 14,
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
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 2),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundColor: Color(0xFFF5F7F9),
                                                            radius: cx.responsive(28,20, 14),
                                                            child: Icon(
                                                              Icons.people_outline,
                                                              color: Color(0xFF629C86),
                                                              size: cx.responsive(26,20, 16),
                                                            ),
                                                          ),
                                                          Gap(10),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              NunitoText(
                                                                textAlign: TextAlign.start,
                                                                text: "Number Of Players",
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: cx.height > 800 ? 16 : 14,
                                                                color: Color(0xFFA8A8A8),
                                                              ),
                                                              NunitoText(
                                                                textAlign: TextAlign.start,
                                                                text: cx.read(LKeys.players).toString(),
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: cx.height > 800 ? 16 : 15,
                                                                color: Colors.black,
                                                                textOverflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
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
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor: Color(0xFFF5F7F9),
                                                      radius: cx.responsive(28,20, 14),
                                                      child: Image.asset(
                                                        "assets/images/location.png",
                                                        scale: cx.responsive(2.5,1.5, 2),
                                                          color:AppColor.darkGreen

                                                      ),
                                                    ),
                                                    Gap(10),

                                                    Padding(
                                                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 2),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                          NunitoText(
                                                              text: "Address",
                                                              fontSize: cx.height > 800
                                                                  ? 16
                                                                  : 14,
                                                              fontWeight:
                                                              FontWeight.w600,
                                                              color: AppColor.grey),

                                                          Container(
                                                            width:cx.width*0.64,
                                                            child: NunitoText(
                                                                text:cx.read(LKeys.address),
                                                                fontSize: cx.height > 800
                                                                    ? 17
                                                                    : 15,
                                                                textOverflow: TextOverflow.ellipsis,
                                                                fontWeight:
                                                                FontWeight.w700,
                                                                maxLines: 4,
                                                                color: Color(0xFF414141)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        MySeparator(
                                          color: Color.fromRGBO(231, 244, 239, 1),
                                        ),
                                        Container(
                                          height: cx.height * 0.33,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    20,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right:20.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: cx.height / 33.5,
                                                          top: 8),
                                                      child: Container(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            NunitoText(
                                                                text: "Sub Total",
                                                              fontSize: cx
                                                                  .responsive(25,20, 17),
                                                              fontWeight:
                                                                FontWeight.w700,
                                                                color:
                                                                AppColor.grey,
                                                              textOverflow: TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                            ),
                                                            Gap(8),
                                                            NunitoText(
                                                                text: "Service Fee",
                                                                fontSize: cx
                                                                    .responsive(25,20, 17),
                                                                fontWeight:
                                                                FontWeight.w700,
                                                                textOverflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                                color:
                                                                AppColor.grey),
                                                            Gap(8),

                                                            Row(
                                                              children: [
                                                                NunitoText(
                                                                    text: "HST",
                                                                    fontSize: cx
                                                                        .responsive(
                                                                        25,20, 17),
                                                                    textOverflow: TextOverflow.ellipsis,
                                                                    maxLines: 1,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                    color: AppColor
                                                                        .grey),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(

                                                        top: 8,
                                                      ),
                                                      child: Container(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                          children: [
                                                            NunitoText(
                                                                textAlign:
                                                                TextAlign.end,
                                                                text: "\$" +
                                                                    cx
                                                                        .read(
                                                                        Keys
                                                                            .price)
                                                                        .toStringAsFixed(
                                                                        2),
                                                              fontSize: cx
                                                                  .responsive(
                                                                  25,20, 17),
                                                              fontWeight:
                                                                FontWeight.w700,
                                                                textOverflow: TextOverflow.ellipsis,

                                                                maxLines: 1,
                                                                color: Color(
                                                                    0xFF757575),

                                                            ),
                                                            Gap(8),
                                                            NunitoText(
                                                                textAlign:
                                                                TextAlign.end,
                                                                text: "+ \$" +
                                                                    serviceFee
                                                                        .toStringAsFixed(
                                                                        2),
                                                                fontSize: cx
                                                                    .responsive(25,20, 17),
                                                                textOverflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                                fontWeight:
                                                                FontWeight.w700,
                                                                color: Color(
                                                                    0xFF757575)),
                                                            Gap(8),

                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                              // crossAxisAlignment:
                                                              // CrossAxisAlignment.end,
                                                              children: [
                                                                NunitoText(
                                                                    textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                    text: "+ \$" +
                                                                        cx
                                                                            .read(
                                                                            LKeys
                                                                                .totalHST)
                                                                            .toStringAsFixed(
                                                                            2),
                                                                    fontSize: cx
                                                                        .responsive(
                                                                        25,20, 17),
                                                                    textOverflow: TextOverflow.ellipsis,
                                                                    maxLines: 1,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                    color: Color(
                                                                        0xFF757575)),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ),
                                              Gap(cx.height*0.015),

                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    20.0, 0, 20, 0),
                                                child: const Divider(
                                                  color: Color(0xFFE7F4EF),
                                                  thickness: 2,
                                                ),
                                              ),
                                              Gap(cx.height*0.015),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    cx.height / 55.58, 8, 18, 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  // crossAxisAlignment:
                                                  // CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      child: NunitoText(
                                                          text: "  Total",
                                                          fontSize:
                                                          cx.responsive(
                                                              27,22, 19),                                                           fontWeight:
                                                          FontWeight.w700,
                                                          textOverflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          color:
                                                          Color(0xFF757575)),
                                                    ),
                                                    SenticText(
                                                        textAlign:
                                                        TextAlign.start,
                                                        text: "\$" +
                                                            total.toStringAsFixed(
                                                                2),
                                                        textOverflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        fontSize:
                                                        cx.responsive(
                                                            29,24, 21),                                                              fontWeight:
                                                        FontWeight.w600,
                                                        color: Color(0xFF07261A)),
                                                  ],
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // height:10,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15))),
                                    child: Gap(10),
                                  ),
                                  Container(
                                    height:25,
                                    color: AppColor.bg,
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 0, 2, 0.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState((){
                                                  isExpandCancellation=!isExpandCancellation;
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  InterText(
                                                    text: "Cancellation Policy",
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                    cx.height > 800 ? 16 : 14,
                                                    color: Color(0xFF444444),
                                                  ),
                                                  Icon(
                                                    isExpandCancellation
                                                        ? Icons
                                                        .arrow_drop_up_rounded
                                                        : Icons
                                                        .arrow_drop_down_rounded,
                                                    color: Color(0xFF444444),
                                                    size: 45,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                child: NunitoText(
                                                  text:
                                                  isExpandCancellation?"You can cancel this booking within two hours. Cancellation charges will be applied. Cancellations less than two hours of deadline are non-refundable":
                                                  "You can cancel this booking within two hours.",
                                                  color: Color(0xFFA8A8A8),
                                                  fontSize: cx.responsive(22,18, 16),
                                                  maxLines: 5,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            Gap(15),
                                            InkWell(
                                              onTap: () {
                                                Get.to(WebViewClass(
                                                    "Cancellation Policy",
                                                    Constant.baseUrl));
                                              },
                                              child: NunitoText(
                                                text:
                                                "Read full cancellation policy",
                                                color: Color(0xFF7C98D0),
                                                textAlign: TextAlign.left,
                                                fontSize: cx.responsive(22,18, 16),
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            Gap(20),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              // MediaQuery.of(context).viewInsets.bottom==0.0
              //     ?Positioned(
              //   bottom: -29,
              //   child: (SvgPicture.asset("assets/svg/leftBottomNavigation.svg",
              //       color: AppColor.darkGreen)),
              // ):Container(),
              // MediaQuery.of(context).viewInsets.bottom==0.0
              //     ?Positioned(
              //   bottom: -29,
              //   right: 0,
              //   child: (SvgPicture.asset("assets/svg/rightBottomNavigation.svg",
              //       color: AppColor.darkGreen)),
              // ):Container()
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

          floatingActionButton: Container(
            width: cx.width,
            child: Form(
              key: bottomEmailKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Container(
                height: cx.read("islogin")?cx.height / 8.5:cx.height / 3.4,
                color: AppColor.darkGreen,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(cx.height / 44.47, cx.height / 44.47,
                      cx.height / 44.47, cx.height / 44.47),
                  child: Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    crossAxisAlignment:CrossAxisAlignment.center,
                    
                    children: [
                      !cx.read("islogin")?Column(
                        children: [
                          TextFormField(
                            controller: bottomEmailController,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: cx.responsive(27,20, 15),
                            ),
                            onTap: () async {},
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            decoration: InputDecoration(
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(cx.height / 6.67),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xFF81B5A1),
                                  )),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(cx.height / 6.67),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xFF81B5A1),
                                  )),
                              fillColor: Color(0xFF29795A),
                              hintText:  "Email Here",
                              hintStyle: TextStyle(
                                fontSize: cx.responsive(27,20, 15),
                                color: Color(0xFFAFCCC1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(cx.height / 6.67),
                                borderSide: BorderSide(
                                  width: 0.5,
                                  color: Color(0xFF24A875),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(cx.height / 6.67),
                                borderSide: BorderSide(
                                  width: 0.5,
                                  color: Color(0xFF24A875),
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(cx.height / 6.67),
                                borderSide: BorderSide(
                                  width: 0.5,
                                  color: Color(0xFF24A875),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(cx.height / 6.67),
                                borderSide: BorderSide(
                                  width: 0.5,
                                  color: Color(0xFF24A875),
                                ),
                              ),
                              filled: true,
                              contentPadding: EdgeInsets.fromLTRB(
                                cx.height / 23,
                                cx.responsive(cx.height / 44.47,cx.height / 44.47, 10),
                                cx.height / 66.67,
                                cx.responsive(cx.height / 44.47,cx.height / 44.47, 10),
                              ),
                            ),
                            validator: (value) {
                              return null;
                            },
                            onChanged: (value) {
                              String pattern =
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                              RegExp regex = RegExp(pattern);
                              if (value.isEmpty ||
                                  !regex.hasMatch(value)) {
                                setState(() {
                                  emailCorrect = false;
                                });
                                print(emailCorrect);
                              } else {
                                setState(() {
                                  emailCorrect = true;
                                });
                                print(emailCorrect);
                              }
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                cx.height / 25.65, 15, cx.height / 25.65, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                NunitoText(
                                  text: "Have An Account?\t",
                                  fontWeight: FontWeight.w500,
                                  fontSize: cx.height / 47.64,
                                  color: Color(0xFF92B8AA),
                                ),
                                InkWell(
                                  onTap: (){
                                    Get.to(SignIn(curIndex: 0));
                                  },
                                  child: NunitoText(
                                    text: "Login",
                                    fontWeight: FontWeight.w700,
                                    fontSize: cx.height / 47.64,
                                    color: Color(0xFF92B8AA),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ):Container(),
                      AbsorbPointer(
                        absorbing: !emailCorrect&&!cx.read("islogin"),
                        child: Container(
                          height: cx.height / 15,
                          width: cx.width / 2.4,
                          child: InkWell(
                            onTap: () {
                              if (cx.read("islogin")) {
                                print("No Verification Required");
                                setState(() {
                                  cx.write(Keys.tempEmail, bottomEmailController.text);
                                });
                                if(!isDataProcesssing){
                                  makePayment();
                                }
                                setState(() {
                                  cx.isSplitAmount.value = false;
                                });
                              } else {
                                cx.write(Keys.tempEmail, bottomEmailController.text);

                                print("No Verification Required");
                                emailOtp();
                                cx.isSplitAmount.value = false;

                                // Get.to(
                                //     SelectPayment(),
                                //     transition: Transition.rightToLeft
                                // );
                                print("Verification Required");
                              }
                            },
                            child: Container(
                              width: cx.width / 4,
                              decoration: BoxDecoration(
                                  color: emailCorrect||cx.read("islogin")
                                      ? Colors.white
                                      : Color(0xFFA2C7B9),
                                  borderRadius: BorderRadius.circular(
                                    cx.height / 13.34,
                                  ),
                                  border: Border.all(
                                      width: 1.3,
                                      color: emailCorrect||cx.read("islogin")
                                          ? Colors.white
                                          : Color(0xFF92B8AA))),
                              padding: EdgeInsets.all(10),
                              child: Center(
                                child: isPaymentAPICalling?
                                Container(
                                  height:25,
                                  width:25,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF265A46),
                                    // strokeWidth: 10,
                                  ),
                                ):
                                NunitoText(
                                  text: "Pay",
                                  fontWeight: emailCorrect||cx.read("islogin")
                                      ? FontWeight.w700
                                      : FontWeight.w800,
                                  fontSize: cx.responsive(26,20, 16),
                                  color: emailCorrect||cx.read("islogin")
                                      ? Colors.black
                                      : Color(0xFF265A46),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }
  Widget emailVerifyDialog()=>StatefulBuilder(
      builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          //this right here
          insetPadding: EdgeInsets.zero,
          child: Container(
            height: cx.height/1.97,
            width: cx.width / 1.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                SenticText(
                    height: 1.2,
                    text:isconfirm?'Please verify your email':isprocessing?"Email Verification":isuccessful?"Email Verification":isfailed?"Email Verification":"Email Verification",
                    fontSize: cx.height > 800 ? 20 : 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
                Gap(cx.height/50),
                Padding(
                  padding: EdgeInsets.only(left:08.0,right:08.0,),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    children: [
                      NunitoText(
                        textAlign: TextAlign.center,
                        text:isconfirm?'An email has been sent to you at ':isprocessing?"Enter The Four Digit Code That You":isuccessful?"Enter The Four Digit Code That You":isfailed?"Enter The Four Digit Code That You":"Enter The Four Digit Code That You",
                        fontWeight: FontWeight.w400,
                        fontSize: cx.height > 800 ? 16 : 14,
                        color: Color(0xFFA8A8A8),
                      ),
                      NunitoText(
                        textAlign: TextAlign.center,
                        text: isconfirm
                            ? cx.read("islogin")?cx.read("useremail"):bottomEmailController.text
                            : "Received On Your Email",
                        fontWeight:  isconfirm?FontWeight.w500:FontWeight.w700,
                        fontSize: cx.height > 800 ? 16 : 14,
                        color: Color(0xFFA8A8A8),
                      ),
                      NunitoText(
                        textAlign: TextAlign.center,
                        text:
                        "with a verification code ",
                        fontWeight: FontWeight.w400,
                        fontSize: cx.height > 800 ? 16 : 14,
                        color: Color(0xFFA8A8A8),
                      ),
                    ],
                  ),
                ),
                Gap(cx.height/25),

                GestureDetector(
                  onLongPress: () async {
                    ClipboardData? data = await Clipboard.getData('text/plain');
                    print(data?.text);
                    if(data!.text!.toString().isNotEmpty){
                      setState((){
                        controller.text=data!.text.toString().substring(0,4);
                      });
                      print("DONE ${controller.text}");
                      print("DONE CONTROLLER ${controller.text}");

                      print(Constant.signUpotp.toString());
                      print("DONE ${controller.text}");

                      if (Constant.signUpotp.toString() == controller.text) {
                        setState(() {
                          isuccessful = true;
                          isprocessing = false;
                          isconfirm = false;
                          isfailed = false;
                        });
                        Duration du = const Duration(seconds: 1);

                        Timer(du, () {
                          Get.back();

                          showDialog(
                              context: context,
                              barrierDismissible:false,

                              builder: (BuildContext context) {
                                return createAcDialog();
                              });
                        });

                      } else {
                        setState(() {
                          isprocessing = false;
                          isconfirm = false;
                          isfailed = true;
                          isuccessful = false;
                        });
                      }
                    }
                  },
                  child: PinCodeTextField(
                    autofocus: true,

                    controller: controller,
                    hideCharacter: false,
                    highlight: true,
                    highlightColor: isfailed?Color(0xFFC46464):AppColor.darkGreen,
                    defaultBorderColor: isfailed?Color(0xFFFFC8C8):AppColor.Green,
                    hasTextBorderColor: isfailed?Color(0xFFFFC8C8):Colors.green,
                    highlightPinBoxColor: isfailed?Color(0xFFFFEBEB):AppColor.bg,
                    maxLength: pinLength,
                    hasError: hasError,

                    onTextChanged: (text) {
                      setState(() {
                        print(text);
                        currentText = text;

                        hasError = false;
                        // isconfirm=true;
                        // isfailed=false;
                      });
                    },
                    onDone: (text) {
                      print("DONE $text");
                      print("DONE CONTROLLER ${controller.text}");

                      print(Constant.signUpotp.toString());
                      print("DONE $text");

                      if (Constant.signUpotp.toString() == text) {
                        setState(() {
                          isuccessful = true;
                          isprocessing = false;
                          isconfirm = false;
                          isfailed = false;
                        });
                        Duration du = const Duration(seconds: 1);

                          Timer(du, () {
                            Get.back();

                            showDialog(
                                context: context,
                                barrierDismissible:false,

                                builder: (BuildContext context) {
                                  return createAcDialog();
                                });
                          });

                      } else {
                        setState(() {
                          isprocessing = false;
                          isconfirm = false;
                          isfailed = true;
                          isuccessful = false;
                        });
                      }

                    },
                    pinBoxWidth: cx.width / 7,
                    pinBoxHeight: cx.height/10.3,
                    hasUnderline: false,
                    wrapAlignment: WrapAlignment.spaceAround,
                    pinBoxDecoration:defaultPinBoxDecoration,
                    pinTextStyle: GoogleFonts.nunito(
                      fontSize: cx.responsive(55,43,33),
                      fontWeight: FontWeight.w800,
                      color: isfailed?Color(0xFF9A5C5C):Color(0xFF628477),
                      decorationStyle: TextDecorationStyle.solid,


                    ),

                    pinTextAnimatedSwitcherTransition:
                    ProvidedPinBoxTextAnimation.scalingTransition,
//                    pinBoxColor: Colors.green[100],
                    pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
//                    highlightAnimation: true,
                    highlightAnimationBeginColor: Colors.black,
                    highlightAnimationEndColor: Colors.white12,
                    keyboardType: TextInputType.number,
                  ),
                ),
                Gap(
                  cx.height/33.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NunitoText(
                      textAlign: TextAlign.center,
                      text:
                      "Didn't recieve the code?",
                      fontWeight: FontWeight.w500,
                      fontSize: cx.height > 800 ? 17 : 15,
                      color: Color(0xFFA8A8A8),
                    ),
                    InkWell(
                      onTap: (){
                        emailOtp();
                      },
                      child: NunitoText(
                        textAlign: TextAlign.center,
                        text:
                        "Resend ",
                        fontWeight: FontWeight.w500,
                        fontSize: cx.height > 800 ? 17 : 15,
                        color: AppColor.darkGreen,
                      ),
                    ),

                  ],
                ),
                Gap(
                  cx.height/28,
                ),
                InkWell(
                  onTap: (){
                    isconfirm?
                    setState((){
                      isconfirm=false;
                      isprocessing=true;
                      isuccessful=false;
                      isfailed=false;
                    }):
                    isprocessing?
                    setState((){
                      isconfirm=false;
                      isprocessing=false;
                      isuccessful=true;
                      isfailed=false;
                    }):
                    isfailed?
                    setState((){
                      isconfirm=false;
                      isprocessing=false;
                      isuccessful=true;
                      isfailed=false;
                    }):
                    isuccessful
                        ?Timer(du, () {
                      Get.back();

                      showDialog(
                          context: context,
                          barrierDismissible:false,

                          builder: (BuildContext context) {
                            return createAcDialog();
                          });
                    }):Get.back();
                  },

                  child: Container(
                    height: cx.responsive(cx.height/11,cx.height/11, cx.height/10),
                    decoration: BoxDecoration(
                        color: isconfirm?Colors.black:isprocessing?Color(0xFF468B8F):isuccessful?Color(0xFF15812D):isfailed?Color(0xFFB01717):Colors.black,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        isconfirm?Icon(
                          Icons.check,
                          color: Colors.white,
                          size: cx.responsive(42,36, 32),

                        ):isprocessing?
                        CupertinoActivityIndicator(
                          color: Colors.white,
                          radius: cx.responsive(15,14, 13),
                        ):
                        isuccessful?
                        SvgPicture.asset(
                          "assets/svg/smile.svg",
                          height: cx.responsive(33,29, 27),
                        ):
                        isfailed?
                        SvgPicture.asset(
                          "assets/svg/sad.svg",
                          height: cx.responsive(33,29, 27),
                        ):
                        Icon(
                          Icons.check,
                          color: Colors.white,
                          size: cx.responsive(42,36, 32),
                        ),
                        NunitoText(
                          textAlign: TextAlign.center,
                          text:isconfirm?"  Confirm":isprocessing?"  Processing":isuccessful?"  Successful":isfailed?"  Failed":"",
                          fontWeight: FontWeight.w700,
                          fontSize: cx.height > 800 ? 25 : 22,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
  void emailOtp() async {
    onAlert(context: context, type: 1, msg: "Loading...");

    setState(() {
      isprocessing = false;
      isconfirm = true;
      isfailed = false;
      isuccessful = false;
    });
    try {
      var request =
      http.MultipartRequest('POST', Uri.parse(Constant.ressendOtp));
      request.fields.addAll({
        'email': bottomEmailController.text,
      });

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonBody = await jsonDecode(respStr);
      if (jsonBody['status'] == 1) {
        print(jsonBody.toString());

        setState(() {
          Constant.signUpotp = jsonBody['otp'];
          print("TTTTTT" + Constant.signUpotp.toString());
        });
        Get.back();
        setState(() {
          controller.text = '';
        });
        showDialog(
            context: context,
            barrierDismissible:false,
            builder: (BuildContext context) => emailVerifyDialog());
        // showDialog(
        //     context: context,
        //     builder: (BuildContext context) =>
        //         createAcDialog());

      } else {
        onAlert(context: context, type: 3, msg: jsonBody['message']);

        print(jsonBody);
      }
    } catch (e) {
      if (e is SocketException) {
        showLongToast("Could not connect to internet");
      }
    }
  }

  Widget createAcDialog()=>StatefulBuilder(
      builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          //this right here
          insetPadding: EdgeInsets.zero,
          child: Container(
            height: cx.height/2.55,
            width: cx.width/1.35,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SenticText(
                    height: 1.2,
                    text: 'Thank You For The\nVerification',
                    textAlign: TextAlign.center,
                    fontSize: cx.height > 800 ? 20 : 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF222222)),
                Gap(cx.height/45),
                Padding(
                    padding: EdgeInsets.fromLTRB(8.0,0,8,0),
                    child: InkWell(
                      onTap: (){
                        Get.to(
                            SignUp(),
                            transition: Transition.rightToLeft
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: cx.height / 14,
                          width: cx.width*0.7,
                          decoration: BoxDecoration(
                              color: Color(0xFF222222),
                              borderRadius: BorderRadius.circular(50)
                          ),
                          child: Center(
                            child: NunitoText(
                              text: "Create Account",
                              fontWeight: FontWeight.w700,
                              fontSize: cx.responsive(25,19, 17),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(8.0,0,8,cx.height/19.06),
                    child: InkWell(
                      onTap: (){
                        Get.back();
                        if (!isDataProcesssing) {
                          makePayment();
                        }
                        },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          height: cx.height / 14,
                          width: cx.width*0.7,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color: Colors.black
                              )
                          ),
                          child: Center(
                            child: NunitoText(
                              text: "Continue as a Guest",
                              fontWeight: FontWeight.w800,
                              fontSize: cx.responsive(25,19, 17),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    )
                ),


              ],
            ),
          ),
        );
      });
  //Details to show on payment sheet
  final billingDetails = BillingDetails(
    name: 'Flutter Stripe',
    email: 'email@stripe.com',
    phone: '+1',
    address: Address(
      city: 'Houston',
      country: 'CA',
      line1: '1459  Circle Drive',
      line2: '',
      state: 'Texas',
      postalCode: '',
    ),
  );
  Future<void> makePayment() async {
    setState(() {
      isDataProcesssing = true;
    });
    paymentIntent = await createPaymentIntent(cx.read(LKeys.total).toStringAsFixed(2), 'CAD');
    // paymentIntent = await createPaymentIntent("85.12", 'CAD');
    debugPrint("After payment intent");
    print(paymentIntent);

    if (paymentIntent != null) {

      try {

        await Stripe.merchantIdentifier;
      //Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent!['client_secret'],
            appearance: PaymentSheetAppearance(
              colors: PaymentSheetAppearanceColors(
                background:AppColor.bg,
                primary: AppColor.darkGreen,
                componentBorder: Colors.grey,
              ),

              shapes: PaymentSheetShape(
                borderWidth: 1,
                shadow: PaymentSheetShadowParams(color: Colors.grey),
              ),

              primaryButton: PaymentSheetPrimaryButtonAppearance(
                shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
                colors: PaymentSheetPrimaryButtonTheme(
                  light: PaymentSheetPrimaryButtonThemeColors(
                    background: AppColor.darkGreen,
                    text:Colors.white,
                    border:Colors.white,
                  ),
                ),
              ),
            ),
            billingDetails: billingDetails,
            allowsDelayedPaymentMethods:  true,
            applePay: PaymentSheetApplePay(
              merchantCountryCode: 'CA',
            ),
            googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "CAD", merchantCountryCode: "CA",),
            style: ThemeMode.light,
            merchantDisplayName: 'Ahmed Ibrahim'),

      ).then((value){
      });


      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
    }
  }
  displayPaymentSheet() async {

    try {
      await Stripe.instance.presentPaymentSheet(
      ).then((value){
        setState((){
          isPaymentAPICalling=true;
        });
      debugPrint("After payment intent2");
      print(paymentIntent);
      confirmPayment();

      StripeService.paymentSuccessfulAPI(
          booking_type: "2",
          customerEmail: cx.read("islogin")
              ? ""
              : cx.read(Keys.tempEmail,),
          league_id: cx.read(LKeys.leagueId).toString(),
          payment_method: "1",
          payment_type: "1",
          players: cx.read(LKeys.players).toString(),
          team_name: cx.read(LKeys.teamName).toString(),
          customerName: cx.read(LKeys.customerfullName),
          customerPhone: cx.read(LKeys.customerphone).toString(),
          total_amount: cx.read(LKeys.total).toStringAsFixed(2),
          transaction_id: paymentIntent!['id'],
          user_id: cx.read("islogin")
              ? cx.read("id").toString()
              : "",
          context: context,
        minSplitAmount: "",

        hst: cx.read(LKeys.totalHST).toString(),
        service_fee: cx.read(LKeys.serviceFee).toString(),
        sub_total: cx.read(LKeys.price).toString(),

        start_time:"",
        sport_id: "",
        slots: "",
        paid_amount: cx.read(LKeys.total).toStringAsFixed(2),
        field_id: "",
        end_time: "",
        dome_id:  "",
        date:  "",
        due_amount: "0.0",
        createdAt: DateTime.now().toString()
      ).then((value) {
        setState((){
          isPaymentAPICalling=false;
        });
        print(value?.bookingId.toString());
        _onAlertWithCustomContentPressed(context);
        Timer(du, () {
          Get.to(FinalLeagueReceipt(
            email: cx.read("islogin")
                ? cx.read('useremail')
                : cx.read(Keys.tempEmail,),
            image: cx.read("image"),
            bookingId: value!.bookingId.toString(),
            paymentLink: value.paymentLink.toString(),
          ),
              transition: Transition.rightToLeft);
        });
        setState(() {
          paymentIntent = null;
        });
      });
      }).onError((error, stackTrace){
        setState(() {
          isDataProcesssing = false;
        });
        print('Error is:--->$error $stackTrace');
      });


    } on StripeException catch (e) {
      setState(() {
        isDataProcesssing = false;
      });
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      setState(() {
        isDataProcesssing = false;
      });
      print('$e');
    }
  }


  void confirmPayment() async {
    try {
      print("data.toString()");

      var data = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: paymentIntent!['client_secret'],
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
        options: PaymentMethodOptions(
          setupFutureUsage: PaymentIntentsFutureUsage.OnSession,
        ),
      );
      print("data.toString()");
      print(data.toString());

      // PaymentIntentResult paymentIntentResult =
      // await Stripe.instance.confirmPaymentIntent(PaymentIntent(
      //   clientSecret: _clientSecret,
      //   paymentMethodId: _paymentMethodId,
      // ));
      //
      // if (paymentIntentResult.status == PaymentStatus.succeeded) {
      //   // Payment completed successfully
      // } else {
      //   // Payment failed
      // }
    } catch (e) {
      // Error occurred during payment processing
    }
  }
  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
          'Bearer ${Constant.stripeSecretKey}',
              // '${cx.read(Constant.stripeSecretKey)}',
          // 'Bearer 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',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }
  calculateAmount(String amount) {

    String convertAmount=(double.parse(amount)*100).toInt().toString();
    print("amount");
    print(convertAmount);

    final calculatedAmout = (int.parse(convertAmount.toString())) ;
    return calculatedAmout.toString();
  }
  _onAlertWithCustomContentPressed(context) {
    showDialog(
      context: context,
      barrierDismissible:false,

      builder: (BuildContext context)
      =>reserveSuccessful(),

    );
    Timer(du, () {
      Get.back();
    });
  }
  Widget reserveSuccessful()=>StatefulBuilder(
      builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          //this right here
          insetPadding: EdgeInsets.zero,
          child: Container(
            height: cx.height/2.55,
            width: cx.width / 1.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                SvgPicture.asset("assets/svg/rsuccess.svg"),
                Gap(cx.height/30),
                InterText(
                  text: cx.isSplitAmount.value?"Payment":"Reservation",
                  fontWeight: FontWeight.w500,
                  fontSize: cx.height > 800 ? 26 : 24,
                  color: Color(0xFF70A792),
                ),
                SenticText(
                  height: 1.4,
                  text: "Successful",
                  fontWeight: FontWeight.w500,
                  fontSize: cx.height > 800 ? 34 : 30,
                  color: Colors.black,
                ),
                Gap(cx.height/100),
              ],
            ),
          ),
        );

      });



  static PinBoxDecoration defaultPinBoxDecoration = (
      Color borderColor,
      Color pinBoxColor, {
        double borderWidth = 1.0,
        double radius = 25.0,
      }) {
    return BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 0.4,
        ),
        color: pinBoxColor,
        borderRadius: BorderRadius.circular(10));
  };
}


