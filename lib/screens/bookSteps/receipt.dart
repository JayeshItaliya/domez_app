import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:domez/commonModule/widget/common/webView.dart';
import 'package:domez/screens/authPage/signIn.dart';
import 'package:domez/screens/authPage/signUp.dart';
import 'package:domez/screens/bookSteps/reviewAndConfirm.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../commonModule/AppColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ticket_widget/ticket_widget.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/Strings.dart';
import 'package:gap/gap.dart';
import '../../commonModule/deepLinkRoute.dart';
import '../../commonModule/widget/common/mySeperator.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../commonModule/widget/search/simplecircularIcon.dart';
import '../../controller/commonController.dart';
import '../payment/PayInFull/bookingReceipt.dart';
import 'package:http/http.dart' as http;
import '../payment/SplitAmount/bookingReceiptSplit.dart';
import '../payment/stripePayment.dart';
import 'dart:math' as math;

class Receipt extends StatefulWidget {
  const Receipt({Key? key}) : super(key: key);

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  CommonController cx = Get.put(CommonController());
  bool fav = false;
  bool emailCorrect = false;
  TextEditingController bottomEmailController = TextEditingController();
  TextEditingController initialDepositController = TextEditingController();
  final GlobalKey<FormState> bottomEmailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> initialDepositKey = GlobalKey<FormState>();
  final ScrollController _scroller = ScrollController();

  TextEditingController controller = TextEditingController(text: "");
  String currentText = "";
  int pinLength = 4;
  bool hasError = false;
  bool isconfirm = true;
  bool isFullPaymentAPICalling = false;
  bool isSplitPaymentAPICalling = false;
  bool isprocessing = false;
  bool isuccessful = false;
  bool isfailed = false;
  Map<String, dynamic>? paymentIntent;
  double serviceCharge = 0.05;
  double serviceFee = 0.05;
  double hst = 45;
  double total = 45;

  double totalAmount = 0.0;
  double defaultAmount = 0.0;
  String initialDeposit = '';

  double remainingAmount = 0.0;
  bool isDataProcesssing = false;
  String startTime = '';
  String timeRemaining = '';
  bool isDecimal = false;
  bool isExpandCancellation = false;
  DateTime startBookingTime = DateTime.now();
  String? _linkMessage;
  bool _isCreatingLink = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      startTime = cx.read(Keys.startTime).substring(0, 2);
      if (cx.read(Keys.startTime).substring(3, 5) == "PM") {
        print("startTime1");
        if (cx.read(Keys.startTime).substring(0, 2) != "12") {
          startTime = (int.parse(startTime) + 12).toString();
        }
      } else {
        if (cx.read(Keys.startTime).substring(0, 2) == "12") {
          startTime = "00";
        }
      }
      print(startTime);
      print(cx.read(Keys.startTime));
      print("item.startDate.toString()");
      timeRemaining = cx.read(Keys.fullDate) + ' ' + startTime + ":00:00";

      print(timeRemaining);
      startBookingTime = DateTime.parse(timeRemaining);
      print(startBookingTime);

      print("HST Percent");
      print(cx.read(Keys.hstPercent));

      serviceFee = cx.read(Keys.price) * serviceCharge;
      cx.write(Keys.serviceFee, serviceFee);

      print("HST1");
      hst = cx.read(Keys.price) * cx.read(Keys.hstPercent);
      cx.write(Keys.totalHST, hst);

      total = cx.read(Keys.price) + serviceFee + hst;
      cx.write(Keys.total, total);

      totalAmount = cx.read(Keys.total);
      defaultAmount = totalAmount / cx.read(Keys.players);
      cx.write(Keys.initialDeposit,defaultAmount);
      initialDeposit = '';

      remainingAmount = totalAmount - defaultAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom:true,
      top:false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: false,
        backgroundColor: AppColor.bg,

        extendBody: false,
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
                          isExpandCancellation?cx.height * 1.72: cx.height * 1.62:
                          isExpandCancellation?cx.height * 2.05: cx.height * 1.95,
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
                                      image: AssetImage("assets/images/step.png"),
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
                            radius: cx.responsive(30,25, 22),
                            child: SimpleCircularIconButton(
                              iconData: Icons.arrow_back_ios_new,
                              iconColor: fav ? AppColor.darkGreen : Colors.black,
                              radius: cx.responsive(60,47, 37),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: cx.height / 6.06,
                        right: 4,
                        left: 4,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 0,
                              left: cx.width * 0.09,
                              right: cx.width * 0.09,
                              bottom: 10),
                          child: SingleChildScrollView(
                            controller: _scroller,
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
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 0,
                                        left:0,
                                        right:0,
                                        bottom: 10),
                                        child: Column(
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
                                                  title: SenticText(
                                                    text: cx.read(Keys.domeName),
                                                    fontSize: cx.height > 800 ? 24 : 21,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF222222),
                                                  ),
                                                  trailing: InkWell(
                                                    onTap: () {
                                                      Get.to(ReviewConfirm());
                                                    },
                                                    child: SenticText(
                                                      text: "Change",
                                                      fontSize:
                                                          cx.height > 800 ? 17 : 14,
                                                      fontWeight: FontWeight.w600,
                                                      color: AppColor.darkGreen,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        TicketWidget(
                                          color: AppColor.ticketWidget,
                                          width: MediaQuery.of(context).size.width,
                                          isCornerRounded: false,
                                          padding: const EdgeInsets.all(0),
                                          height: cx.height * 0.7,
                                          child: Column(
                                            // shrinkWrap: true,
                                            // physics: ClampingScrollPhysics(),
                                            children: [
                                              Container(
                                                height: cx.height * 0.345,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20,
                                                          top: cx.height / 44.47),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: cx.width * 0.23,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                NunitoText(
                                                                    text: "Field",
                                                                    fontSize:
                                                                        cx.height > 800
                                                                            ? 18
                                                                            : 16,
                                                                    fontWeight:
                                                                        FontWeight.w600,
                                                                    color:
                                                                        AppColor.grey),
                                                                Container(
                                                                  width:
                                                                      cx.width * 0.345,
                                                                  child: NunitoText(
                                                                    text: cx.read(
                                                                        Keys.fieldName),
                                                                    fontSize:
                                                                        cx.height > 800
                                                                            ? 17
                                                                            : 15,
                                                                    fontWeight:
                                                                        FontWeight.w700,
                                                                    color: Color(
                                                                        0xFF414141),
                                                                    textOverflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 1,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 40,
                                                                ),
                                                                NunitoText(
                                                                    text: "Players",
                                                                    fontSize:
                                                                        cx.height > 800
                                                                            ? 18
                                                                            : 16,
                                                                    fontWeight:
                                                                        FontWeight.w600,
                                                                    color:
                                                                        AppColor.grey),
                                                                NunitoText(
                                                                    text: cx
                                                                        .read(Keys
                                                                            .players)
                                                                        .toString(),
                                                                    fontSize:
                                                                        cx.height > 800
                                                                            ? 17
                                                                            : 15,
                                                                    fontWeight:
                                                                        FontWeight.w700,
                                                                    color: Color(
                                                                        0xFF414141)),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                NunitoText(
                                                                    text: "Date",
                                                                    fontSize:
                                                                        cx.height > 800
                                                                            ? 18
                                                                            : 16,
                                                                    fontWeight:
                                                                        FontWeight.w600,
                                                                    color:
                                                                        AppColor.grey),
                                                                NunitoText(
                                                                    text: cx.selMonth
                                                                            .value +
                                                                        ' ' +
                                                                        cx.selDate
                                                                            .value +
                                                                        ', ' +
                                                                        cx.selYear
                                                                            .value,
                                                                    fontSize:
                                                                        cx.height > 800
                                                                            ? 17
                                                                            : 15,
                                                                    fontWeight:
                                                                        FontWeight.w700,
                                                                    color: Color(
                                                                        0xFF414141)),
                                                                const SizedBox(
                                                                  width: 40,
                                                                ),
                                                                NunitoText(
                                                                    text: "Time",
                                                                    fontSize:
                                                                        cx.height > 800
                                                                            ? 18
                                                                            : 16,
                                                                    fontWeight:
                                                                        FontWeight.w600,
                                                                    color:
                                                                        AppColor.grey),
                                                                NunitoText(
                                                                    text: cx
                                                                            .read(Keys
                                                                                .startTime)
                                                                            .toString()
                                                                            .substring(
                                                                                0, 8) +
                                                                        " To " +
                                                                        cx
                                                                            .read(Keys
                                                                                .endTime)
                                                                            .toString()
                                                                            .substring(
                                                                                11, 19),
                                                                    fontSize:
                                                                        cx.height > 800
                                                                            ? 17
                                                                            : 15,
                                                                    fontWeight:
                                                                        FontWeight.w700,
                                                                    color: Color(
                                                                        0xFF414141)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20,
                                                          top: cx.height / 44.47),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          NunitoText(
                                                              text: "Address",
                                                              fontSize: cx.height > 800
                                                                  ? 18
                                                                  : 16,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              color: AppColor.grey),
                                                          Container(
                                                            width: cx.width * 0.7,
                                                            child: NunitoText(
                                                                text: cx
                                                                    .read(Keys.address),
                                                                fontSize:
                                                                    cx.height > 800
                                                                        ? 17
                                                                        : 15,
                                                                maxLines: cx.height > 800?3:2,
                                                                textOverflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontWeight:
                                                                    FontWeight.w700,
                                                                color:
                                                                    Color(0xFF414141)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
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
                                                      padding: const EdgeInsets.only(
                                                          right: 20.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                left: cx.height / 33.5,
                                                                top: cx.height / 66.7),
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
                                                                      fontSize:
                                                                          cx.responsive(
                                                                              25,20, 17),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: AppColor
                                                                          .grey),
                                                                  Gap(6),
                                                                  NunitoText(
                                                                      text:
                                                                          "Service Fee",
                                                                      fontSize:
                                                                          cx.responsive(
                                                                              25,20, 17),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: AppColor
                                                                          .grey),
                                                                  Gap(6),
                                                                  Row(
                                                                    children: [
                                                                      NunitoText(
                                                                          text: "HST  ",
                                                                          fontSize:
                                                                          cx.responsive(
                                                                              25,20, 17),                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w600,
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
                                                              left: cx.responsive(4,3, 2),
                                                              top: cx.responsive(15,10, 7),
                                                            ),
                                                            child: Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
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
                                                                      fontSize:
                                                                          cx.responsive(
                                                                              25,20, 17),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: Color(
                                                                          0xFF757575)),
                                                                  Gap(4),
                                                                  NunitoText(
                                                                      textAlign:
                                                                          TextAlign.end,
                                                                      text: "+ \$" +
                                                                          serviceFee
                                                                              .toStringAsFixed(
                                                                                  2),
                                                                      fontSize:
                                                                          cx.responsive(
                                                                              25,20, 17),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: Color(
                                                                          0xFF757575)),
                                                                  Gap(4),
                                                                  NunitoText(
                                                                      textAlign:
                                                                          TextAlign.end,
                                                                      text: "+ \$" +
                                                                          cx
                                                                              .read(
                                                                                  Keys
                                                                                      .totalHST)
                                                                              .toStringAsFixed(
                                                                                  2),
                                                                      fontSize:
                                                                          cx.responsive(
                                                                              25,20, 17),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: Color(
                                                                          0xFF757575)),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Gap(6),
                                                    Padding(
                                                      padding: EdgeInsets.fromLTRB(
                                                          20.0, 0, 20, 0),
                                                      child: const Divider(
                                                        color: Color(0xFFE7F4EF),
                                                        thickness: 2,
                                                      ),
                                                    ),
                                                    Gap(7),
                                                    Padding(
                                                      padding: EdgeInsets.fromLTRB(
                                                          cx.height / 55.58, 4, 15, 8),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        // crossAxisAlignment:
                                                        // CrossAxisAlignment.center,
                                                        children: [
                                                          NunitoText(
                                                              text: "  Total",
                                                              fontSize:
                                                              cx.responsive(
                                                                  27,22, 19),                                                                 fontWeight:
                                                                  FontWeight.w700,
                                                              color: Color(0xFF757575)),
                                                          SenticText(
                                                              textAlign:
                                                                  TextAlign.start,
                                                              text: "\$" +
                                                                  total.toStringAsFixed(
                                                                      2),
                                                              fontSize:
                                                              cx.responsive(
                                                                  29,24, 21),                                                                   fontWeight:
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
                                          height: 10,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                      cx.height / 37.06),
                                                  bottomRight: Radius.circular(
                                                      cx.height / 37.06))),
                                          child: ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20,
                                                cx.height / 55.58,
                                                cx.height / 44.47,
                                                0),
                                          ),
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
                                                        fontSize: cx.responsive(25,19, 16),
                                                        maxLines: 5,
                                                        fontWeight: FontWeight.w400,
                                                      )),
                                                  Gap(15),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(WebViewClass(
                                                          "Cancellation Policy",
                                                          Constant.cancelUrl));
                                                    },
                                                    child: NunitoText(
                                                      text:
                                                      "Read full cancellation policy",
                                                      color: Color(0xFF7C98D0),
                                                      textAlign: TextAlign.left,
                                                      fontSize: cx.responsive(25,19, 16),
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

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Positioned(
                      //     bottom: cx.read("islogin")?56:180,
                      //
                      //   child: Container(
                      //     width:cx.width,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         SvgPicture.asset("assets/svg/leftBottomNavigation.svg",
                      //             color: AppColor.darkGreen),
                      //         SvgPicture.asset("assets/svg/rightBottomNavigation.svg",
                      //             color: AppColor.darkGreen),
                      //
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
              
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //
        floatingActionButton: Container(
          width: cx.width,
          child: Form(
            key: bottomEmailKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              width: cx.width,
              height: cx.read("islogin") ? cx.height / 8 : cx.height / 3.4,
              color: AppColor.darkGreen,
              child: Padding(
                padding: EdgeInsets.fromLTRB(cx.height / 44.47, cx.height / 44.47,
                    cx.height / 44.47, cx.height / 44.47),
                child: Container(
                  height: cx.height * 0.45,
                  width: cx.width,
                  child: Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      !cx.read("islogin")
                          ? Column(
                        children: [
                          TextFormField(
                            controller: bottomEmailController,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: cx.responsive(25,20, 15),
                            ),
                            onTap: () async {},
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            decoration: InputDecoration(
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      cx.height / 6.67),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xFF81B5A1),
                                  )),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      cx.height / 6.67),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xFF81B5A1),
                                  )),
                              fillColor: Color(0xFF29795A),
                              hintText: "Email Here",
                              hintStyle: TextStyle(
                                fontSize: cx.responsive(25,20, 15),
                                color: Color(0xFFAFCCC1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                                borderSide: BorderSide(
                                  width: 0.5,
                                  color: Color(0xFF24A875),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                                borderSide: BorderSide(
                                  width: 0.5,
                                  color: Color(0xFF24A875),
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                                borderSide: BorderSide(
                                  width: 0.5,
                                  color: Color(0xFF24A875),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                                borderSide: BorderSide(
                                  width: 0.5,
                                  color: Color(0xFF24A875),
                                ),
                              ),
                              filled: true,
                              contentPadding: EdgeInsets.fromLTRB(
                                cx.height / 23,
                                cx.responsive(23,15, 10),
                                cx.height / 66.67,
                                cx.responsive(23,15, 10),
                              ),
                            ),
                            onChanged: (value) {
                              String pattern =
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                              RegExp regex = RegExp(pattern);
                              if (value.isEmpty || !regex.hasMatch(value)) {
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
                            padding: EdgeInsets.fromLTRB(cx.height / 25.65,
                                15, cx.height / 25.65, 15),
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
                                  onTap: () {
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
                      )
                          : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AbsorbPointer(
                            absorbing: !emailCorrect && !cx.read("islogin"),
                            child: Container(
                              height: cx.height / 15,
                              width: cx.width / 2.4,
                              child: InkWell(
                                onTap: () {
                                  if (cx.read("islogin")) {
                                    print("No Verification Required");
                                    setState(() {
                                      cx.write(Keys.tempEmail,
                                          bottomEmailController.text);
                                    });
                                    cx.isSplitAmount.value = true;
                                    initialDepositController.text =
                                        defaultAmount.toStringAsFixed(2);
                                    initialDeposit =
                                        initialDepositController.text;
                                    remainingAmount = totalAmount - defaultAmount;

                                    showDialog(
                                        barrierDismissible:false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return splitDialog();
                                        });
                                  } else {
                                    emailOtp();
                                    cx.isSplitAmount.value = true;
                                  }
                                },
                                child: Container(
                                  width: cx.width / 3.5,
                                  decoration: BoxDecoration(
                                      color: emailCorrect || cx.read("islogin")
                                          ? Color(0xFF8AB8A7)
                                          : Color(0xFF4E9479),
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                          width: 1.3,
                                          color:
                                          emailCorrect || cx.read("islogin")
                                              ? Colors.white
                                              : Color(0xFF92B8AA))),
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                    child: isSplitPaymentAPICalling?
                                    Container(
                                      height:25,
                                      width:25,
                                      child: CircularProgressIndicator(
                                        color: AppColor.darkGreen,
                                        // strokeWidth: 10,
                                      ),
                                    ):NunitoText(
                                      text: "Split Amount",
                                      fontWeight: FontWeight.w700,
                                      fontSize: cx.responsive(26,20, 16),
                                      color: emailCorrect || cx.read("islogin")
                                          ? Colors.white
                                          : Color(0xFFA2C7B9),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: !emailCorrect && !cx.read("islogin"),
                            child: Container(
                              height: cx.height / 15,
                              width: cx.width / 2.4,
                              child: InkWell(
                                onTap: () {
                                  if (mounted) {
                                    if (cx.read("islogin")) {
                                      print("No Verification Required");
                                      setState(() {
                                        cx.write(Keys.tempEmail,
                                            bottomEmailController.text);
                                        print("Pay in Full");
                                      });
                                      cx.isSplitAmount.value = false;

                                      print(startBookingTime
                                          .subtract(Duration(hours: 4)));
                                      print(DateTime.now());
                                      print(startBookingTime
                                          .subtract(Duration(hours: 4))
                                          .millisecondsSinceEpoch);
                                      print(
                                          DateTime.now().millisecondsSinceEpoch);
                                      if (!isDataProcesssing) {
                                        makePayment();
                                      }

                                      // bookingAlert(
                                      //     context: context,
                                      //     type: (startBookingTime.subtract(Duration(hours:4)).millisecondsSinceEpoch<=DateTime.now().millisecondsSinceEpoch)?2:1);

                                    } else {
                                      setState(() {
                                        cx.write(Keys.tempEmail,
                                            bottomEmailController.text);
                                      });

                                      print("No Verification Required");
                                      emailOtp();
                                      cx.isSplitAmount.value = false;

                                      print("Verification Required");
                                    }
                                  }
                                },
                                child: Container(
                                  width: cx.width / 3.5,
                                  decoration: BoxDecoration(
                                      color: emailCorrect || cx.read("islogin")
                                          ? Colors.white
                                          : Color(0xFFA2C7B9),
                                      borderRadius: BorderRadius.circular(
                                        cx.height / 13.34,
                                      ),
                                      border: Border.all(
                                          width: 1.3,
                                          color:
                                          emailCorrect || cx.read("islogin")
                                              ? Colors.white
                                              : Color(0xFF92B8AA))),
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                    child:isFullPaymentAPICalling?
                                    Container(
                                      height:25,
                                      width:25,
                                      child: CircularProgressIndicator(
                                        color: AppColor.darkGreen,
                                        // strokeWidth: 10,
                                      ),
                                    ): NunitoText(
                                      text: "Pay in Full",
                                      fontWeight:
                                      emailCorrect || cx.read("islogin")
                                          ? FontWeight.w700
                                          : FontWeight.w800,
                                      fontSize: cx.responsive(26,20, 16),
                                      color: emailCorrect || cx.read("islogin")
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget emailVerifyDialog() => StatefulBuilder(builder: (BuildContext context,
          StateSetter setState /*You can rename this!*/) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          //this right here
          insetPadding: EdgeInsets.zero,

          child: Container(
            height: cx.height / 1.97,
            width: cx.width / 1.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SenticText(
                    height: 1.2,
                    text: isconfirm
                        ? 'Please verify your email'
                        : isprocessing
                            ? "Email Verification"
                            : isuccessful
                                ? "Email Verification"
                                : isfailed
                                    ? "Email Verification"
                                    : "Email Verification",
                    fontSize: cx.height > 800 ? 20 : 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
                Gap(cx.height / 50),
                Padding(
                  padding: EdgeInsets.only(
                    left: 08.0,
                    right: 08.0,
                  ),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    children: [
                      NunitoText(
                        textAlign: TextAlign.center,
                        text: isconfirm
                            ? 'An email has been sent to you at '
                            : isprocessing
                                ? "Enter The Four Digit Code That You"
                                : isuccessful
                                    ? "Enter The Four Digit Code That You"
                                    : isfailed
                                        ? "Enter The Four Digit Code That You"
                                        : "Enter The Four Digit Code That You",
                        fontWeight: FontWeight.w400,
                        fontSize: cx.height > 800 ? 16 : 14,
                        color: Color(0xFFA8A8A8),
                      ),
                      NunitoText(
                        textAlign: TextAlign.center,
                        text: isconfirm
                            ? cx.read("islogin")
                                ? cx.read("useremail")
                                : bottomEmailController.text
                            : "Received On Your Email",
                        fontWeight:  isconfirm?FontWeight.w500:FontWeight.w700,
                        fontSize: cx.height > 800 ? 16 : 14,
                        color: Color(0xFFA8A8A8),
                      ),
                      NunitoText(
                        textAlign: TextAlign.center,
                        text: "with a verification code ",
                        fontWeight: FontWeight.w400,
                        fontSize: cx.height > 800 ? 16 : 14,
                        color: Color(0xFFA8A8A8),
                      ),
                    ],
                  ),
                ),
                Gap(cx.height / 25),
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

                        if (cx.isSplitAmount.value) {
                          Timer(du, () {
                            Get.back();
                            initialDepositController.text =
                                defaultAmount.toStringAsFixed(2);
                            initialDeposit = initialDepositController.text;

                            remainingAmount = totalAmount - defaultAmount;

                            showDialog(
                                context: context,
                                barrierDismissible:false,

                                builder: (BuildContext context) {
                                  return splitDialog();
                                });
                          });
                        } else {
                          Timer(du, () {
                            Get.back();

                            showDialog(
                                context: context,
                                barrierDismissible:false,

                                builder: (BuildContext context) {
                                  return createAcDialog();
                                });
                          });
                        }
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

                    highlightColor:
                        isfailed ? Color(0xFFC46464) : AppColor.darkGreen,
                    defaultBorderColor:
                        isfailed ? Color(0xFFFFC8C8) : AppColor.Green,
                    hasTextBorderColor:
                        isfailed ? Color(0xFFFFC8C8) : Colors.green,
                    highlightPinBoxColor:
                        isfailed ? Color(0xFFFFEBEB) : AppColor.bg,
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
                    onDone: (text) async {
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

                        if (cx.isSplitAmount.value) {
                          Timer(du, () {
                            Get.back();
                            initialDepositController.text =
                                defaultAmount.toStringAsFixed(2);
                            initialDeposit = initialDepositController.text;

                            remainingAmount = totalAmount - defaultAmount;

                            showDialog(
                                context: context,
                                barrierDismissible:false,

                                builder: (BuildContext context) {
                                  return splitDialog();
                                });
                          });
                        } else {
                          Timer(du, () {
                            Get.back();

                            showDialog(
                                context: context,
                                barrierDismissible:false,

                                builder: (BuildContext context) {
                                  return createAcDialog();
                                });
                          });
                        }
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
                    pinBoxHeight: cx.height / 10.3,
                    hasUnderline: false,
                    wrapAlignment: WrapAlignment.spaceAround,
                    pinBoxDecoration: defaultPinBoxDecoration,
                    pinTextStyle: GoogleFonts.nunito(
                      fontSize: cx.responsive(55,43, 33),
                      fontWeight: FontWeight.w800,
                      color: isfailed ? Color(0xFF9A5C5C) : Color(0xFF628477),
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
                  cx.height / 33.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NunitoText(
                      textAlign: TextAlign.center,
                      text: "Didn't recieve the code?",
                      fontWeight: FontWeight.w500,
                      fontSize: cx.height > 800 ? 17 : 15,
                      color: Color(0xFFA8A8A8),
                    ),
                    InkWell(
                      onTap: () {
                        emailOtp();
                      },
                      child: NunitoText(
                        textAlign: TextAlign.center,
                        text: "Resend ",
                        fontWeight: FontWeight.w500,
                        fontSize: cx.height > 800 ? 17 : 15,
                        color: AppColor.darkGreen,
                      ),
                    ),
                  ],
                ),
                Gap(
                  cx.height / 28,
                ),
                InkWell(
                  onTap: () {
                    if (isconfirm && currentText.length != 4) {
                      setState(() {
                        isconfirm = false;
                        isprocessing = false;
                        isuccessful = false;
                        isfailed = true;
                      });
                    }

                    // isprocessing?
                    // setState((){
                    //   isconfirm=false;
                    //   isprocessing=false;
                    //   isuccessful=true;
                    //   isfailed=false;
                    // }):
                    // isfailed?
                    // setState((){
                    //   isconfirm=false;
                    //   isprocessing=false;
                    //   isuccessful=true;
                    //   isfailed=false;
                    // }):
                    // isuccessful
                    // ?Timer(du, () {
                    //   Get.back();
                    //   showDialog(
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         return createAcDialog();
                    //       });
                    // }):Get.back();
                  },
                  child: Container(
                    height: cx.responsive(cx.height / 11,cx.height / 11, cx.height / 10),
                    decoration: BoxDecoration(
                        color: isconfirm
                            ? Colors.black
                            : isprocessing
                                ? Color(0xFF468B8F)
                                : isuccessful
                                    ? Color(0xFF15812D)
                                    : isfailed
                                        ? Color(0xFFB01717)
                                        : Colors.black,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        isconfirm
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: cx.responsive(40,36, 32),
                              )
                            : isprocessing
                                ? CupertinoActivityIndicator(
                                    color: Colors.white,
                                    radius: cx.responsive(15,14, 13),
                                  )
                                : isuccessful
                                    ? SvgPicture.asset(
                                        "assets/svg/smile.svg",
                                        height: cx.responsive(35,29, 27),
                                      )
                                    : isfailed
                                        ? SvgPicture.asset(
                                            "assets/svg/sad.svg",
                                            height: cx.responsive(35,29, 27),
                                          )
                                        : Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: cx.responsive(43,36, 32),
                                          ),
                        NunitoText(
                          textAlign: TextAlign.center,
                          text: isconfirm
                              ? "  Confirm"
                              : isprocessing
                                  ? "  Processing"
                                  : isuccessful
                                      ? "  Successful"
                                      : isfailed
                                          ? "  Failed"
                                          : "",
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

  Widget splitDialog() => StatefulBuilder(builder: (BuildContext context,
          StateSetter setState /*You can rename this!*/) {
        return Dialog(

          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          //this right here
          insetPadding: EdgeInsets.zero,

          child: Form(
            key: initialDepositKey,
            child: SingleChildScrollView(
              child: Container(
                // height: cx.height / 1.4,
                width: cx.width / 1.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Gap(cx.height / 30),
                    SenticText(
                        height: 1.2,
                        text: 'Enter Initial Deposit',
                        fontSize: cx.height > 800 ? 20 : 18,
                        fontWeight: FontWeight.w500,
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                        color: Colors.black),
                    Gap(cx.height / 50),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 08.0,
                        right: 08.0,
                      ),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.center,
                        children: [
                          NunitoText(
                            textAlign: TextAlign.center,
                            text:
                                "Enter the initial amount that\n you want to pay",
                            fontWeight: FontWeight.w400,
                            fontSize: cx.height > 800 ? 17 : 15,
                            color: Color(0xFFA8A8A8),
                          ),
                        ],
                      ),
                    ),
                    Gap(cx.height / 25),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.0, 0, 12, 0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // maxLength: totalAmount.toStringAsFixed(0).length+3,
                        // maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              initialDeposit = defaultAmount.toStringAsFixed(2);
                              remainingAmount = totalAmount - defaultAmount;
                            });
                          } else {
                            setState(() {
                              remainingAmount =
                                  totalAmount - double.parse(value);
                              print(remainingAmount);
                              initialDeposit = value;
                            });
                          }
                        },
                        controller: initialDepositController,

                        // autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [
                          DecimalTextInputFormatter(decimalRange: 2),
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                          // FilteringTextInputFormatter.digitsOnly,
                          DecimalTextInputFormatter(decimalRange: 2),
                          FilteringTextInputFormatter.singleLineFormatter,
                          LengthLimitingTextInputFormatter(isDecimal == true
                              ? totalAmount.toStringAsFixed(0).length + 3
                              : totalAmount.toStringAsFixed(0).length + 1),





                          // NumericalRangeFormatter(min: 0, max: totalAmount),
                        ],
                        style: GoogleFonts.nunito(
                          fontSize: cx.responsive(27,21, 18),
                          fontWeight: FontWeight.w800,
                          color: AppColor.darkGreen,
                        ),
                        cursorColor: AppColor.darkGreen,
                        cursorHeight: 20,
                        keyboardType: Platform.isIOS?TextInputType.numberWithOptions(decimal: true):TextInputType.number,
                        autofocus: false,
                        // textInputAction: TextInputAction.number,
                        decoration: InputDecoration(
                          fillColor: AppColor.bg,
                          // hintText: "Enter Initial Deposit",
                          // hintStyle: GoogleFonts.nunito(
                          //   fontSize: cx.responsive(25,21, 18),
                          //   fontWeight: FontWeight.w700,
                          //   color: AppColor.darkGreen,
                          // ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFF9BD9C1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFF9BD9C1),
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFF9BD9C1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(cx.height / 6.67),
                            borderSide: BorderSide(
                              width: 3,
                              color: Color(0xFF9BD9C1),
                            ),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(18.0, 8, 8, 8),
                            child: InkWell(
                                onTap: () async {},
                                child: SvgPicture.asset(
                                  "assets/svg/dollar.svg",
                                  // color: AppColor.darkGreen
                                )),
                          ),
                          filled: true,

                          contentPadding: EdgeInsets.fromLTRB(
                            cx.responsive(30,24, 20),
                            cx.responsive(17,13, 10),
                            cx.responsive(33,25, 20),
                            cx.responsive(13,8, 6),
                          ),
                        ),
                        validator: (value) {
                          if (value != null) {
                            if (value.contains('.')) {
                              isDecimal = true;
                            } else {
                              isDecimal = false;
                            }
                          }

                          if (value == null || value.isEmpty) {
                            return "Please Enter Initial Deposit";
                          } else if (double.parse(value) >
                              cx.read(Keys.total)) {
                            print(value);
                            print(initialDepositController.text);
                            return "Please Enter Valid Amount";
                          } else if (double.parse(value) <
                              double.parse(defaultAmount.toStringAsFixed(2))) {
                            print(value);
                            print(defaultAmount);
                            return "Not Less Than Min Initial Deposit";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Gap(
                      cx.height / 33.5,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            cx.responsive(43,35, 30),
                            cx.responsive(7,5, 3),
                            cx.responsive(43,35, 30),
                            cx.responsive(11,8, 6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              NunitoText(
                                textAlign: TextAlign.center,
                                text: "Total Amount",
                                fontWeight: FontWeight.w700,
                                fontSize: cx.height > 800 ? 18 : 16,
                                color: Color(0xFFA8A8A8),
                              ),
                              NunitoText(
                                textAlign: TextAlign.center,
                                text: "\$" +
                                    cx.read(Keys.total).toStringAsFixed(2),
                                fontWeight: FontWeight.w700,
                                fontSize: cx.height > 800 ? 20 : 18,
                                color: Color(0xFF757575),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            cx.responsive(43,35, 30),
                            cx.responsive(7,5, 3),
                            cx.responsive(43,35, 30),
                            cx.responsive(11,8, 6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              NunitoText(
                                textAlign: TextAlign.center,
                                text: "Entered Amount",
                                fontWeight: FontWeight.w700,
                                fontSize: cx.height > 800 ? 18 : 16,
                                color: Color(0xFFA8A8A8),
                                textOverflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              NunitoText(
                                textAlign: TextAlign.center,
                                text: initialDepositController.text.isEmpty
                                    ? "\$" + defaultAmount.toStringAsFixed(2)
                                    : "\$" + initialDepositController.text,
                                fontWeight: FontWeight.w700,
                                fontSize: cx.height > 800 ? 20 : 18,
                                color: Color(0xFF757575),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            cx.responsive(43,35, 30),
                            cx.responsive(7,5, 3),
                            cx.responsive(43,35, 30),
                            cx.responsive(11,8, 6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              NunitoText(
                                textAlign: TextAlign.center,
                                text: "Min Initial Deposit",
                                fontWeight: FontWeight.w700,
                                fontSize: cx.height > 800 ? 18 : 16,
                                color: Color(0xFFA8A8A8),
                                textOverflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              NunitoText(
                                textAlign: TextAlign.center,
                                text: "\$" + defaultAmount.toStringAsFixed(2),
                                fontWeight: FontWeight.w700,
                                fontSize: cx.height > 800 ? 20 : 18,
                                color: Color(0xFF757575),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Color(0xFFE7F4EF),
                          thickness: 1.7,
                          indent: 20,
                          endIndent: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            cx.responsive(43,35, 30),
                            cx.responsive(7,5, 3),
                            cx.responsive(43,35, 30),
                            cx.responsive(11,8, 6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              NunitoText(
                                textAlign: TextAlign.start,
                                text: "Remaining\nAmount",
                                fontWeight: FontWeight.w700,
                                fontSize: cx.height > 800 ? 22 : 20,
                                color: Color(0xFF757575),
                                height: 1.1,
                              ),
                              NunitoText(
                                textAlign: TextAlign.center,
                                text:
                                    // initialDepositController.text.isEmpty?defRemainingAmount.toStringAsFixed(2):
                                    "\$" + remainingAmount.toStringAsFixed(2),
                                fontWeight: FontWeight.w700,
                                fontSize: cx.height > 800 ? 24 : 22,
                                color: Color(0xFF07261A),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Gap(
                      cx.height / 28,
                    ),
                    InkWell(
                      onTap: () {
                        if (initialDepositKey.currentState!.validate()) {
                          print(initialDeposit);
                          cx.write(
                            Keys.splitPaidAmount,
                            double.parse(initialDeposit),
                          );
                          cx.write(Keys.splitRemainingAmount, remainingAmount);
                          setState(() {
                            cx.isSplitAmount.value = true;
                          });
                          Get.back();
                          if (cx.read("islogin")) {
                            if (!isDataProcesssing) {
                              makePayment();
                            }
                          } else {
                            showDialog(
                                context: context,
                                barrierDismissible:false,

                                builder: (BuildContext context) {
                                  return createAcDialog();
                                });
                          }

                          // bookingAlert(
                          //     context: context,
                          //     type: (startBookingTime.subtract(Duration(hours:4)).millisecondsSinceEpoch>=DateTime.now().millisecondsSinceEpoch)?2:1);
                        }
                      },
                      child: Container(
                        height: cx.responsive(cx.height / 11,cx.height / 11, cx.height / 10),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            NunitoText(
                              textAlign: TextAlign.center,
                              text: "Confirm",
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

  Widget createAcDialog() => StatefulBuilder(builder: (BuildContext context,
          StateSetter setState /*You can rename this!*/) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          //this right here
          insetPadding: EdgeInsets.zero,
          child: Container(
            height: cx.height / 2.55,
            width: cx.width / 1.35,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SenticText(
                    height: 1.2,
                    text: 'Thank You For The\nVerification',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    fontSize: cx.height > 800 ? 20 : 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF222222)),
                Gap(cx.height / 45),
                Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                    child: InkWell(
                      onTap: () {
                        Get.to(SignUp(), transition: Transition.rightToLeft);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: cx.height / 14,
                          width: cx.width * 0.7,
                          decoration: BoxDecoration(
                              color: Color(0xFF222222),
                              borderRadius: BorderRadius.circular(50)),
                          child: Center(
                            child: NunitoText(
                              text: "Create Account",
                              fontWeight: FontWeight.w700,
                              fontSize: cx.responsive(23,19, 17),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 0, 8, cx.height / 19.06),
                    child: InkWell(
                      onTap: () {
                        Get.back();

                        if (!isDataProcesssing) {
                          makePayment();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          height: cx.height / 14,
                          width: cx.width * 0.7,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.black)),
                          child: Center(
                            child: NunitoText(
                              text: "Continue as a Guest",
                              fontWeight: FontWeight.w800,
                              fontSize: cx.responsive(23,19, 17),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    )),
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
    debugPrint("Start Payment");

    print(cx.read(Keys.splitPaidAmount).toString());
    print(cx.read(Keys.total).toString());

    double finalAmount = cx.isSplitAmount.value
        ? cx.read(Keys.splitPaidAmount)
        : cx.read(Keys.total);

    print(finalAmount);
    print(cx.isSplitAmount.value);

    paymentIntent =
        await createPaymentIntent(finalAmount.toStringAsFixed(2), 'CAD');
    print(finalAmount.toStringAsFixed(2));

    // createPaymentIntent(
    //     cx.isSplitAmount.value?
    //     double.parse(cx.read(Keys.splitPaidAmount)).toStringAsFixed(2):
    //     double.parse(cx.read(Keys.total)).toStringAsFixed(2), 'CAD');

    debugPrint("After payment intent");
    print(paymentIntent);
    // Get.to(PaymentSheetScreenWithCustomFlow());

    if (paymentIntent != null) {
      try {
        await Stripe.merchantIdentifier;

        //Payment Sheet
        await Stripe.instance
            .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              // customFlow: true,

              paymentIntentClientSecret: paymentIntent!['client_secret'],
              appearance: PaymentSheetAppearance(
                colors: PaymentSheetAppearanceColors(
                  background: AppColor.bg,
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
                      text: Colors.white,
                      border: Colors.white,
                    ),
                  ),
                ),
              ),
              billingDetails: billingDetails,
              customerId: paymentIntent!['customer'],
              allowsDelayedPaymentMethods: true,

              applePay: PaymentSheetApplePay(
                merchantCountryCode: 'CA',
                buttonType: PlatformButtonType.pay,

                // paymentSummaryItems: [
                //   ApplePayCartSummaryItem.immediate(label: '', amount: '100')
                // ],
              ),
              googlePay: const PaymentSheetGooglePay(
                testEnv: false,
                currencyCode: "CAD",
                merchantCountryCode: "CA",
              ),
              style: ThemeMode.light,
              merchantDisplayName: 'DOMEZ'),
        )
            .then((value) {
          displayPaymentSheet();
        });

        ///now finally display payment sheeet

      } catch (e, s) {
        print('exception:$e$s');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        rethrow;
      }
    }
  }

  displayPaymentSheet({
    int? paymentMethod,
  }) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        if(!cx.isSplitAmount.value){
          setState((){
            isFullPaymentAPICalling=true;
          });
        }
        else{
          setState((){
            isSplitPaymentAPICalling=true;
          });
        }


        debugPrint("After payment intent2");
        debugPrint(DateTime.now().toString());
        print(paymentIntent);
        confirmPayment();

        //---Convert Start Time in UTC
        // String timeRemainingBookingCreatedTimeAPI =
        //     cx.read(Keys.fullDate).toString() + ' ' + cx.read(Keys.startTime).substring(0,5)+":00";
        // DateTime bookingStartTime = DateTime.parse(timeRemainingBookingCreatedTimeAPI);
        // print(bookingStartTime.toString()+"bookingStartTime");
        // print(bookingStartTime.toUtc().toString()+"bookingStartTime");

        StripeService.paymentSuccessfulAPI(
                booking_type: "1",
                // card_cvv: '365',
                // card_exp_month: '11',
                // card_exp_year: '29',
                // card_number: '4242424242424242',
                customerEmail: cx.read("islogin")
                    ? ""
                    : cx.read(
                        Keys.tempEmail,),
                date: cx.read(Keys.fullDate).toString(),
                dome_id: cx.read(Keys.domeId).toString(),
                end_time: cx.read(Keys.endTime).substring(11, 19),
                field_id: cx.read(Keys.fieldId).toString(),
                league_id: "",
                paid_amount: cx.isSplitAmount.value
                    ? cx.read(Keys.splitPaidAmount).toString()
                    : cx.read(Keys.total).toString(),
                payment_method: "1",
                payment_type: cx.isSplitAmount.value ? "2" : "1",
                players: cx.read(Keys.players).toString(),
                slots: cx.read(Keys.slotsList),
                sport_id: cx.read(Keys.sportId).toString(),
                // start_time: cx.read(Keys.startTime).substring(0,8),
                start_time: cx.read(Keys.startTime).substring(0, 8),
                team_name: "",
                total_amount: cx.read(Keys.total).toString(),
                transaction_id: paymentIntent!['id'],
                user_id: cx.read("id").toString(),
                context: context,
                customerName: "",
                customerPhone: "",
                due_amount: cx.isSplitAmount.value
                    ? cx.read(Keys.splitRemainingAmount).toString()
                    : "0.0",
                hst: cx.read(Keys.totalHST).toString(),
                service_fee: cx.read(Keys.serviceFee).toString(),
                sub_total: cx.read(Keys.price).toString(),
                createdAt: DateTime.now().toString(),
                minSplitAmount: cx.isSplitAmount.value
                    ? (cx.read(Keys.splitRemainingAmount)/(cx.read(Keys.players)-1)).toString()
                    : "",
        )
            .then((value) {


          if(!cx.isSplitAmount.value){
            setState((){
              isFullPaymentAPICalling=false;
            });
          }
          else{
            setState((){
              isSplitPaymentAPICalling=false;
            });
          }


          print(value?.bookingId.toString());
          _createDynamicLink(true,"/domeBooking",value?.bookingId.toString()??"");

          print("payment Link");
          print(value!.paymentLink.toString());

          print("email");
          print(cx.read("useremail"));
          cx.read("islogin")
              ? cx.read('useremail')
              : cx.read(
                  Keys.tempEmail,
                );
          _onAlertWithCustomContentPressed(context);

          print(cx.read("islogin"));
          print(cx.read('useremail'));
          print(cx.read(
            Keys.tempEmail,
          ));
          Timer(du, () {
            Get.offAll(
                cx.isSplitAmount.value
                    ? SplitReceipt(
                        email: cx.read("islogin")
                            ? cx.read('useremail')
                            : cx.read(
                                Keys.tempEmail,
                              ),
                        image: cx.image.value,
                        paymentLink: _linkMessage.toString(),
                        // paymentLink: value.paymentLink.toString(),
                        bookingId: value.bookingId.toString(),
                      )
                    : BookingReceipt(
                        email: cx.read("islogin")
                            ? cx.read('useremail')
                            : cx.read(
                                Keys.tempEmail,
                              ),
                        image: cx.image.value,
                        bookingId: value.bookingId.toString(),
                        paymentLink: value.paymentLink.toString(),
                      ),
                transition: Transition.rightToLeft);
          });

          setState(() {
            paymentIntent = null;
          });
        });
      }).onError((error, stackTrace) {
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

  _onAlertWithCustomContentPressed(context) {
    showDialog(
      context: context,
      barrierDismissible:false,

      builder: (BuildContext context) =>
          AbsorbPointer(absorbing: true, child: reserveSuccessful()),
    );
    Timer(du, () {
      if(!_isCreatingLink){
        Get.back();
      }
    });
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
    // print(double.parse(amount)*100.ceilToDouble());
    // print((double.parse(amount)).toInt());
    // print((double.parse(amount)).toInt()*100);
    double convertToDouble = double.parse(amount);
    print(convertToDouble);

    int convertToInt = (convertToDouble * 100).ceil();
    print(convertToInt);

    String convertAmount = convertToInt.toString();
    // String convertAmount=(double.parse(amount)*100).toInt().toString();
    print("amount");
    print(convertAmount);
    print(amount);

    final calculatedAmout = int.parse(convertAmount);

    return calculatedAmout.toString();
  }

  bookingAlert({required BuildContext context, required int type}) {
    Alert(
      style: AlertStyle(
          buttonsDirection: ButtonsDirection.column,
          alertBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
              color: Color(0xFF9BD9C1),
              width: 2.5,
            ),
          ),
          alertElevation: 100,
          isButtonVisible: false),
      onWillPopActive: false,
      context: context,
      content: Column(
        children: <Widget>[
          // Gap(cx.height / 60),
          Text(
            "Booking Alert",
            style: TextStyle(
                color: Colors.black,
                fontSize: cx.responsive(25,21, 18),
                fontWeight: FontWeight.w700),
          ),
          Gap(cx.height / 60),
          Text(
            type == 1
                ? "You can cancel this booking within two hours.Cancellation charges will be applied"
                : "You can cancel this booking before 2 hours of your playing time",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: cx.responsive(23,19, 16),
                fontWeight: FontWeight.w400,
                color: Color(0xFFA8A8A8)),
          ),
          Gap(cx.height / 20),
          InkWell(
            onTap: () {
              if (cx.read("islogin")) {
                Get.back();
                if (!isDataProcesssing) {
                  makePayment();
                }
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return createAcDialog();
                    });
              }
            },
            child: Container(
              // width: widget.width,
              decoration: BoxDecoration(
                  color: AppColor.lightGreen,
                  borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.all(cx.height / 66.7),
              child: Center(
                child: NunitoText(
                  text: "Continue Booking",
                  fontWeight: FontWeight.w700,
                  fontSize: cx.responsive(25,21, 18),
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Gap(cx.height / 45),
          InkWell(
            onTap: () {
              Get.back();
              Get.to(WebViewClass("Cancellation Policy", Constant.baseUrl));
            },
            child: Text(
              "Read Cancellation Policy",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: cx.responsive(23,18, 15),
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF7C98D0)),
            ),
          ),
        ],
      ),
      closeIcon: Container(
        height: cx.height / 44.47,
      ),
      // onWillPopActive:true ,
    ).show();
  }

  Widget reserveSuccessful() => StatefulBuilder(builder: (BuildContext context,
          StateSetter setState /*You can rename this!*/) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          //this right here
          insetPadding: EdgeInsets.zero,
          child: Container(
            height: cx.height / 2.55,
            width: cx.width / 1.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset("assets/svg/rsuccess.svg"),
                Gap(cx.height / 30),
                InterText(
                  text: cx.isSplitAmount.value ? "Payment" : "Reservation",
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
                Gap(cx.height / 100),
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


  Future<void> _createDynamicLink(bool short, String link,String bookingId) async {
    setState(() {
      _isCreatingLink = true;
    });
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: Constant.kUriPrefix,
      // link: Uri.parse(Constant.kUriPrefix + link+'?bookingId=45'),
      link: Uri.parse("https://www.domez.io/domeBooking?bookingId=${bookingId}"),
      // link: Uri.parse(Constant.kUriPrefix + link),
      // longDynamicLink: Uri.parse(
      //   'https://flutterfiretests.page.link?efr=0&ibi=io.flutter.plugins.firebase.dynamiclinksexample&apn=io.flutter.plugins.firebase.dynamiclinksexample&imv=0&amv=0&link=https%3A%2F%2Fexample%2Fhelloworld&ofl=https://ofl-example.com',
      // ),
      androidParameters: const AndroidParameters(
        packageName: 'domez.io',
        minimumVersion: 0,
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
      await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
    print("Hey NORA"+_linkMessage.toString());

  }
}

class NumericalRangeFormatter extends TextInputFormatter {
  final double min;
  final double max;

  NumericalRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') {
      return newValue;
    } else if (int.parse(newValue.text) < min) {
      return TextEditingValue().copyWith(text: min.toStringAsFixed(2));
    } else {
      return int.parse(newValue.text) > max ? oldValue : newValue;
    }
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }

}
