import '../../../commonModule/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/Strings.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../controller/bookListController.dart';
import '../../controller/bookingDetailsController.dart';
import '../../controller/commonController.dart';
import '../../model/bookingListModel.dart';

class BottomSheetBooking extends StatefulWidget {
  BottomSheetBooking({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomSheetBooking> createState() => _BottomSheetBookingState();
}

class _BottomSheetBookingState extends State<BottomSheetBooking> {
  CommonController cx = Get.put(CommonController());
  BookListController mycontroller = Get.put(BookListController());
  BookingDetailsController bx = Get.put(BookingDetailsController());
  List<int> errorBooking = [];
  bool Previous = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      children: [
        Container(
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
                Gap(25),
                Previous
                    ? Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Container(
                          height: cx.height / 13.34,
                          decoration: BoxDecoration(
                            color: AppColor.bg,
                            borderRadius: BorderRadius.circular(
                              cx.height / 13.34,
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: TextButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            cx.height / 13.34,
                                          ),
                                        )),
                                        splashFactory: NoSplash.splashFactory,
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColor.bg)),

                                    child: NunitoText(
                                      text: "Active",
                                      fontSize: cx.responsive(28,22, 18),
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF17563E),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        Previous = false;
                                        mycontroller.type.value = 1;
                                        mycontroller.getTask(
                                            mycontroller.type.value.toString());
                                        // getData();
                                      });
                                    },
                                    // color: Colors.pink,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: cx.height / 12.13,
                                  child: TextButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            cx.height / 13.34,
                                          ),

                                          // side: BorderSide(color: Colors.red)
                                        )),
                                        splashFactory: NoSplash.splashFactory,
                                        side: MaterialStateProperty.all(
                                          BorderSide(
                                            color: AppColor.lightGreen,
                                            width: 2,
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white)),
                                    child: NunitoText(
                                      text: "Previous",
                                      fontSize: cx.responsive(28,22, 18),
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF17563E),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        // Previous=value;
                                        Previous = true;
                                        mycontroller.type.value = 2;
                                        mycontroller.getTask(
                                            mycontroller.type.value.toString());
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Container(
                          height: cx.height / 13.34,
                          decoration: BoxDecoration(
                            color: AppColor.bg,
                            borderRadius: BorderRadius.circular(
                              cx.height / 13.34,
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 250,
                                  child: TextButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            cx.height / 13.34,
                                          ),
                                        )),
                                        splashFactory: NoSplash.splashFactory,
                                        side: MaterialStateProperty.all(
                                          BorderSide(
                                            color: AppColor.lightGreen,
                                            width: 2,
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white)),
                                    child: NunitoText(
                                      text: "Active",
                                      fontSize: cx.responsive(28,22, 18),
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF17563E),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        // Previous=value;
                                        Previous = false;
                                        mycontroller.type.value = 1;
                                        mycontroller.getTask(
                                            mycontroller.type.value.toString());
                                        // getData();
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: cx.height / 12.13,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          cx.height / 13.34,
                                        ),
                                        // side: BorderSide(color: Colors.red)
                                      )),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColor.bg),
                                      splashFactory: NoSplash.splashFactory,
                                    ),

                                    child: NunitoText(
                                      text: "Previous",
                                      fontSize: cx.responsive(28,22, 18),
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF17563E),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        Previous = true;
                                        mycontroller.type.value = 2;
                                        mycontroller.getTask(
                                            mycontroller.type.value.toString());
                                      });
                                    },
                                    // color: Colors.pink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                Gap(5),
                Obx(
                  () => mycontroller.isoffline.value
                      ? noInternetLottie(backbutton: true)
                      : mycontroller.isDataProcessing.value
                          ? Container(
                              height: cx.height * 0.7,
                              alignment: Alignment.topCenter,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: CircularProgressIndicator(
                                      color: AppColor.darkGreen,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : mycontroller.myList.length == 0
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: cx.height * 0.45,
                                      // height: 200,
                                      color: Colors.white,
                                      alignment: Alignment.center,
                                      child: NunitoText(
                                          text: Previous
                                              ? 'Oops! You have not done any previous bookings yet'
                                              : 'Oops! You don\'t have any active bookings',
                                          textAlign: TextAlign.center,
                                          fontSize: cx.responsive(35,27, 23),
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  // scrollDirection: Axis.horizontal,
                                  itemCount: mycontroller.myList.length,
                                  itemBuilder: (context, index) {
                                    BookingListModel item =
                                        mycontroller.myList[index];
                                    return InkWell(
                                      onTap: () {

                                        if(item.type==1){
                                          bx.setBid(item.bookingId.toString(),item.paymentType,!Previous,true);

                                        }
                                        else{
                                          bx.setBid(item.bookingId.toString(),3,!Previous,true);

                                        }


                                      },
                                      child: Row(
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
                                                        .width *0.83,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .fromLTRB(4.0,8,0,8),
                                                      child: Container(
                                                        width: cx.responsive(
                                                            160,135, 120),
                                                        height: cx.responsive(
                                                            160,135, 120),
                                                        decoration:
                                                        errorBooking.contains(item.bookingId)?BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .all(
                                                              Radius
                                                                  .circular(
                                                                  20),
                                                            ),
                                                            image:
                                                            DecorationImage(
                                                                image:
                                                                AssetImage(
                                                                  Image1.domesAround,
                                                                ),
                                                                fit: BoxFit
                                                                    .cover)):
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                                image:
                                                                    DecorationImage(
                                                                        image:
                                                                            NetworkImage(
                                                                          item.image,
                                                                        ),
                                                                        fit: BoxFit.cover,
                                                                      onError: (Object e, StackTrace? stackTrace) {
                                                                        setState(() {
                                                                          errorBooking.add(item.bookingId);
                                                                        });
                                                                      },
                                                                    )),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              cx.height / 41.69,
                                                              3,
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
                                                          Container(
                                                            width:
                                                                cx.width * 0.38,
                                                            child: NunitoText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              text: item.type ==
                                                                      1
                                                                  ? "Field - "+item.field
                                                                  : item
                                                                      .leagueName,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize:
                                                                  cx.height >
                                                                          800
                                                                      ? 18
                                                                      : 16,
                                                              color:
                                                                  AppColor.grey,
                                                              textOverflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0, 2, 0, 3),
                                                            child: Container(
                                                              width: cx.width *
                                                                  0.4,
                                                              child: InterText(
                                                                text: item
                                                                    .domeName,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize:
                                                                    cx.height >
                                                                            800
                                                                        ? 20
                                                                        : 19,

                                                                // color: Color(0xFF6E6B6B),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0, 0, 0, 4),
                                                            child: Container(
                                                              width: cx.width *
                                                                  0.4,
                                                              child: NunitoText(
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                text: item.date,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize:
                                                                    cx.height >
                                                                            800
                                                                        ? 16
                                                                        : 14,
                                                                color: AppColor
                                                                    .grey,
                                                                textOverflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 1,
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: '',
                                                              style: DefaultTextStyle
                                                                      .of(context)
                                                                  .style,
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    text:
                                                                        '\$${item.price}',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize: cx.height >
                                                                                800
                                                                            ? 26
                                                                            : 22)),
                                                                TextSpan(
                                                                    text: item.type ==
                                                                            1
                                                                        ? ' / Hour'
                                                                        : ' / team',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize: cx.height >
                                                                                800
                                                                            ? 15
                                                                            : 12)),
                                                              ],
                                                            ),
                                                          ),

                                                          // NunitoText(
                                                          //   text: "Sat, 12 may",
                                                          //   fontWeight: FontWeight.w500,
                                                          //   fontSize: cx.height/41.69,
                                                          //   color: Color(0xFFA8A8A8),
                                                          // ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
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
                                                          // Gap(cx.height/22.23),
                                                        ],
                                                      ),
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
                  height: cx.height / 7,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
