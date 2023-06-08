import 'dart:math';
import 'package:domez/screens/bookSteps/selectPlayers.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:domez/commonModule/Strings.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../../commonModule/AppColor.dart';
import '../../../controller/commonController.dart';
import '../../commonModule/Constant.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../commonModule/widget/search/customButton.dart';
import '../../commonModule/widget/search/simplecircularIcon.dart';
import '../../controller/timeSlotsController.dart';
import '../../model/timeSlots.dart';
import 'package:flutter_calendar_carousel/classes/marked_date.dart';
import 'package:intl/intl.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/multiple_marked_dates.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class BookSlot extends StatefulWidget {
  bool isEditing;
  BookSlot({Key? key,required this.isEditing}) : super(key: key);

  @override
  State<BookSlot> createState() => _BookSlotState();
}

class _BookSlotState extends State<BookSlot> {
  CommonController cx = Get.put(CommonController());
  TimeSlotsController mycontroller = Get.put(TimeSlotsController());
  bool s2expanded = true;
  String startTime = "";
  String endTime = "";
  String startMeanTime = "";
  String endMeanTime = "";
  double totalPrice = 0.0;
  double previousPrice = 0.0;
  int removedIndex = -1;
  String bookedSlotList = '';

  // int isSelectedIndex = 0;

  int? _key;
  bool fav = false;
  List<int> selectedIndex = [];

  _collapse() {
    int? newKey;
    print(_key.toString());
    print("_keyyyyyy");

    do {
      _key = Random().nextInt(10000);
      print(_key.toString());
    } while (newKey == _key);
  }

  //---------- CalCarousel Variables-------//
  DateTime date = DateTime.now();
  final controller = new PageController(
    viewportFraction: 1 / 5,
    initialPage: 3,
  );

  DateTime todayDate = DateTime.now().subtract(const Duration(days: 1));

  // DateTime cx.currentDate.value = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime(2023, 04, 14));
  DateTime _targetDateTime = DateTime(2023, 04, 14);

  int presentDate = 17;
  int presentMonth = 4;
  int presentYear = 2023;

  List<MarkedDate> markedDates = [];
  bool isMarked = false;

  MarkedDate marked(var Date) {
    return MarkedDate(
        color: Color(0xFFF5F7F9),
        date: Date,
        textStyle: TextStyle(fontSize: 18, color: Color(0xFFD4D8D6)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("selectedIndexinit");
    print(cx.globalSelectedIndex);
    // print(cx.globalSelectedIndex.value);
    // String tempValue=cx.globalSelectedIndex.value.replaceAll(',', '');

    print("selectedIndex");
    print(selectedIndex);
    if(cx.globalSelectedIndex.length!=0){
      totalPrice=cx.globalPrice.value;
      previousPrice =totalPrice;
      for(int i=0;i<cx.globalSelectedIndex.length;i++){

        setState((){
          selectedIndex.add(cx.globalSelectedIndex[i]);
        });
      }
      print("selectedIndex");
      print(selectedIndex);
    }

    //---------- CalCarousel Variables-------//
    presentDate = int.parse(DateFormat("d").format(todayDate));
    presentMonth = int.parse(DateFormat("M").format(todayDate));
    presentYear = int.parse(DateFormat("y").format(todayDate));
    _currentMonth = DateFormat.yMMM().format(todayDate.add(const Duration(days: 1)));

    print(presentDate);
    print(presentMonth);
    print(presentYear);
    print("Heyyyy" + presentDate.toString());
    print("Heyyyy" + cx.fullDate.value);
    //---------- MarkedDate Variables-------//

    // markedDates.add(marked(DateTime(2023, 04, 22)));
    // markedDates.add(marked(DateTime.now().add(const Duration(days: 3))));
    // markedDates.add(marked(DateTime(2023, 04, 22)));
    // markedDates.add(marked(DateTime(2023, 04, 22)));
    // markedDates.add(marked(DateTime(2023, 04, 22)));
    // markedDates.add(marked(DateTime(2023, 04, 2)));


    for (int i = 1; i < presentDate; i++) {
      markedDates.addIf(
          DateTime(presentYear, presentMonth, i).millisecondsSinceEpoch <=
              todayDate.add(Duration(days: 1)).millisecondsSinceEpoch,
          marked(DateTime(presentYear, presentMonth, i)));
    }
    print("markedDates" + markedDates.toString());
    print("presentDate" + presentDate.toString());
    print("fullDate" + cx.fullDate.value);

  }

  @override
  Widget build(BuildContext context) {

    return Obx(
      () => Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                height: cx.height,
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
                                  top: cx.height / 6.06,
                                  // top: cx.responsive(200,167, 130),
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
                                                    scale:
                                                        cx.responsive(2.5,1.5, 2),
                                                    color:
                                                        AppColor.darkGreen),
                                                Container(
                                                  width: cx.width * 0.65,
                                                  child: NunitoText(
                                                    textAlign:
                                                        TextAlign.start,
                                                    text:
                                                        "${cx.read(Keys.city)}, ${cx.read(Keys.state)}",
                                                    fontWeight:
                                                        FontWeight.w400,
                                                    fontSize: cx.height > 800
                                                        ? 18
                                                        : 15,
                                                    color:
                                                        AppColor.lightGreen,
                                                    textOverflow:
                                                        TextOverflow.ellipsis,
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
                                iconColor:
                                    fav ? AppColor.darkGreen : Colors.black,
                                radius: cx.responsive(60,47, 37),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              height: cx.height / 2.9,
                            ),
                            Container(
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Gap(cx.height / 45),
                                    Card(
                                      color: s2expanded
                                          ? Colors.white
                                          : AppColor.bg,
                                      elevation:
                                          s2expanded ? cx.height / 55.58 : 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: s2expanded
                                              ? BorderRadius.circular(14)
                                              : BorderRadius.circular(
                                                  cx.height / 6.67),
                                          side: BorderSide(
                                            color: AppColor.Green,
                                          )),
                                      clipBehavior: Clip.antiAlias,
                                      margin: EdgeInsets.zero,
                                      child: ExpansionTile(
                                        maintainState: true,
                                        key: Key(_key.toString()),
                                        initiallyExpanded: s2expanded,
                                        tilePadding: EdgeInsets.fromLTRB(
                                            10,
                                            cx.responsive(12,8, 0),
                                            10,
                                            cx.responsive(12,8, 0)),
                                        collapsedIconColor:
                                            AppColor.darkGreen,
                                        onExpansionChanged: (s) {
                                          setState(() {
                                            s2expanded = s;
                                            debugPrint(s2expanded.toString());
                                          });
                                        },
                                        trailing:
                                            Container(width: 1, height: 1),
                                        leading: s2expanded == false
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                      10,
                                                      0,
                                                      0,
                                                      3,
                                                    ),
                                                    child: SvgPicture.asset(
                                                      "assets/svg/edit.svg",
                                                      color:
                                                          AppColor.darkGreen,
                                                      height: 25,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(
                                                height: 1,
                                                width: 1,
                                              ),
                                        title: Padding(
                                          padding: EdgeInsets.only(
                                            top: s2expanded
                                                ? cx.height / 41.69
                                                : 0.0,
                                            left: cx.s4complete.value
                                                ? 0
                                                : s2expanded
                                                    ? 0
                                                    : 10.0,
                                          ),
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment: cx
                                                      .s4complete.value
                                                  ? MainAxisAlignment.start
                                                  : MainAxisAlignment.center,
                                              crossAxisAlignment: cx
                                                      .s4complete.value
                                                  ? CrossAxisAlignment.start
                                                  : CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: cx.responsive(
                                                         5, 4, 3)),
                                                  child: NunitoText(
                                                    text: s2expanded
                                                        ? "Select Your Date"
                                                        : "Date:\t\t",
                                                    // textAlign:TextAlign.center,
                                                    fontSize: cx.height > 800
                                                        ? 19
                                                        : 17,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                    color: s2expanded
                                                        ? AppColor.darkGreen
                                                        : AppColor.darkGreen,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 3.0),
                                                  child:  NunitoText(
                                                      text: s2expanded
                                                          ? ""
                                                          : "${cx.selDate.value}" +
                                                              " " +
                                                              "${cx.selMonth.value}",
                                                      textAlign:
                                                          TextAlign.end,
                                                      fontSize:
                                                          cx.height > 800
                                                              ? 22
                                                              : 20,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: s2expanded
                                                          ? AppColor.darkGreen
                                                          : Color(0xFF628477),
                                                    ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        childrenPadding: EdgeInsets.zero,
                                        expandedAlignment:
                                            Alignment.bottomLeft,
                                        expandedCrossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Divider(
                                                thickness: 0.9,
                                                color: AppColor.Green,
                                              ),
                                              Obx(
                                                () => Column(
                                                  children: [
                                                    Gap(7),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.only(
                                                        left:
                                                            cx.height / 44.47,
                                                        right:
                                                            cx.height / 44.47,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          NunitoText(
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                            text:
                                                                _currentMonth,
                                                            color: AppColor
                                                                .darkGreen,
                                                            fontSize:
                                                                cx.height >
                                                                        800
                                                                    ? 21
                                                                    : 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Gap(cx.height / 41.69),
                                                    Container(
                                                      height: 300,
                                                      margin: EdgeInsets
                                                          .symmetric(
                                                              horizontal:
                                                                  8.0),
                                                      child: CalendarCarousel<
                                                          Event>(
                                                        markedDateCustomShapeBorder:
                                                            CircleBorder(
                                                                side:
                                                                    BorderSide(
                                                          color: Color(
                                                              0xFFF5F7F9),
                                                        )),
                                                        markedDateCustomTextStyle:
                                                            TextStyle(
                                                          fontSize: 18,
                                                          color: Color(
                                                              0xFFD4D8D6),
                                                        ),
                                                        daysHaveCircularBorder:
                                                            false,
                                                        // markedDatesMap: _markedDateMap,
                                                        daysTextStyle:
                                                            TextStyle(
                                                          color: AppColor
                                                              .darkGreen,
                                                          fontSize: 18,
                                                        ),
                                                        dayButtonColor:
                                                            AppColor.bg,


                                                        //-----Making Grey Previous Day-----//
                                                        customDayBuilder: (
                                                          bool isSelectable,
                                                          int index,
                                                          bool isSelectedDay,
                                                          bool isToday,
                                                          bool isPrevMonthDay,
                                                          TextStyle textStyle,
                                                          bool isNextMonthDay,
                                                          bool isThisMonthDay,
                                                          DateTime day,
                                                        ) {

                                                          if (day.month ==
                                                                  presentMonth &&
                                                              day.day ==
                                                                  presentDate) {
                                                            return Container(
                                                              height: 150,
                                                              decoration: BoxDecoration(
                                                                  color: Color(
                                                                      0xFFF5F7F9),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Color(
                                                                          0xFFF5F7F9),
                                                                      spreadRadius:
                                                                          1.9, //New
                                                                    )
                                                                  ]),
                                                              child: Center(
                                                                child: Text(
                                                                  "${presentDate}",
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xFFD4D8D6),
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                              ),
                                                            );
                                                          } else {
                                                            return null;
                                                          }
                                                        },

                                                        weekendTextStyle:
                                                            TextStyle(
                                                          color: AppColor
                                                              .darkGreen,
                                                          fontSize: 18,
                                                        ),
                                                        weekdayTextStyle:
                                                            TextStyle(
                                                          color: AppColor
                                                              .darkGreen,
                                                          fontSize: 15,
                                                        ),
                                                        inactiveDaysTextStyle:
                                                            TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 18,
                                                        ),


                                                        onDayPressed:
                                                            (date, events) {
                                                          // setState(() {
                                                          //   isMarked =
                                                          //       MultipleMarkedDates(
                                                          //     markedDates:
                                                          //         markedDates,
                                                          //   ).isMarked(date);
                                                          // });
                                                          // print(isMarked);

                                                          if ((date)
                                                                  .millisecondsSinceEpoch >=
                                                              todayDate
                                                                  .millisecondsSinceEpoch) {
                                                            if (!isMarked) {
                                                              setState(() {
                                                                cx.currentDate
                                                                        .value =
                                                                    date;
                                                                cx.selDate
                                                                    .value = DateFormat
                                                                        .d()
                                                                    .format(cx
                                                                        .currentDate
                                                                        .value);
                                                                cx.selMonth
                                                                    .value = DateFormat
                                                                        .MMM()
                                                                    .format(cx
                                                                        .currentDate
                                                                        .value);
                                                                cx.selYear
                                                                    .value = DateFormat
                                                                        .y()
                                                                    .format(cx
                                                                        .currentDate
                                                                        .value);
                                                                cx.fullDate
                                                                    .value = DateFormat(
                                                                        "yyyy-MM-dd")
                                                                    .format(cx
                                                                        .currentDate
                                                                        .value);
                                                              });
                                                            }
                                                            print(cx.selDate
                                                                .value);
                                                            print(cx.selMonth
                                                                .value);
                                                            print(cx.selYear
                                                                .value);
                                                            print(cx.fullDate
                                                                .value);

                                                            cx.write(
                                                                Keys.fullDate,
                                                                cx.fullDate
                                                                    .value);
                                                            cx.write(
                                                                Keys.selDate,
                                                                cx.selDate
                                                                    .value);
                                                            cx.write(
                                                                Keys.selMonth,
                                                                cx.selMonth
                                                                    .value);
                                                            cx.write(
                                                                Keys.selYear,
                                                                cx.selYear
                                                                    .value);
                                                            mycontroller
                                                                .getTask();
                                                            selectedIndex.clear();

                                                            totalPrice = 0.0;
                                                            previousPrice = 0.0;
                                                            cx.write(Keys.price, totalPrice);

                                                          }
                                                          ;
                                                        },
                                                        staticSixWeekFormat:
                                                            true,
                                                        showOnlyCurrentMonthDate:
                                                            true,
                                                        thisMonthDayBorderColor:
                                                            AppColor.bg,
                                                        weekFormat: false,
                                                        height: 420.0,
                                                        showHeader: false,
                                                        selectedDateTime: cx
                                                            .currentDate
                                                            .value,
                                                        customGridViewPhysics:
                                                            NeverScrollableScrollPhysics(),
                                                        todayTextStyle:
                                                            TextStyle(
                                                                color: AppColor
                                                                    .darkGreen,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                        todayButtonColor:
                                                            AppColor.bg,
                                                        todayBorderColor:
                                                            AppColor.bg,
                                                        firstDayOfWeek: 1,
                                                        selectedDayTextStyle:
                                                            TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                        dayPadding: 3,
                                                        multipleMarkedDates:
                                                            MultipleMarkedDates(
                                                                markedDates:
                                                                    markedDates),

                                                        targetDateTime:
                                                            _targetDateTime,

                                                        selectedDayBorderColor:
                                                            AppColor
                                                                .darkGreen,
                                                        selectedDayButtonColor:
                                                            AppColor
                                                                .darkGreen,


                                                        minSelectedDate:
                                                            todayDate,
                                                        maxSelectedDate:
                                                            todayDate.add(
                                                                Duration(
                                                                    days:
                                                                        90)),

                                                        onCalendarChanged:
                                                            (DateTime date) {
                                                          this.setState(() {
                                                            _targetDateTime =
                                                                date;
                                                            _currentMonth =
                                                                DateFormat
                                                                        .yMMM()
                                                                    .format(
                                                                        _targetDateTime);
                                                            print(
                                                                _currentMonth);
                                                          });
                                                          print("Hello");
                                                        },
                                                        markedDateIconBorderColor:
                                                        Color(0xFFF5F7F9),
                                                        // markedDateWidget:
                                                        //     Container(
                                                        //   height: 50,
                                                        //   color: Colors.red,
                                                        // ),
                                                        //
                                                        // markedDateMoreCustomDecoration:
                                                        //     BoxDecoration(
                                                        //         color: Colors
                                                        //             .red),
                                                        //
                                                        // nextMonthDayBorderColor:
                                                        //     Colors.red,
                                                        // prevDaysTextStyle:
                                                        // TextStyle(
                                                        //   fontSize: 16,
                                                        //   color: Colors
                                                        //       .pinkAccent,
                                                        // ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Gap(cx.height / 70),
                                              InkWell(
                                                onTap: () {
                                                  print(cx.selDate.value);
                                                  print(cx.selMonth.value);
                                                  print(cx.selYear.value);
                                                  print("cx.fullDate.value");
                                                  print(cx.fullDate.value);

                                                  setState(() {
                                                    // s1initiate=false;
                                                    s2expanded = false;
                                                    _collapse();
                                                    // s3initiate=true;
                                                    // expansionTile.currentState?.collapse();
                                                  });
                                                  // mycontroller.getTask();
                                                  // selectedIndex.clear();
                                                },
                                                child: Container(
                                                  height: cx.height / 11.7,
                                                  width: double.infinity,
                                                  color:
                                                      const Color(0xFF222222),
                                                  child: Center(
                                                    child: NunitoText(
                                                      textAlign:
                                                          TextAlign.center,
                                                      text: 'Confirm',
                                                      color: Colors.white,
                                                      fontSize:
                                                          cx.height > 800
                                                              ? 25
                                                              : 21,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Gap(cx.height / 30),
                                    mycontroller.isDataProcessing.value
                                        ?Container():InterText(
                                      text: "Available Slots (" +
                                          (mycontroller.myList.length)
                                              .toString() +
                                          ")",
                                      fontSize: cx.responsive(25,20, 17),
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      textAlign: TextAlign.left,
                                    ),
                                    Gap(cx.height / 40),
                                     mycontroller.isDataProcessing.value
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: AppColor.darkGreen,
                                                ),
                                              )
                                            : mycontroller.myList.length == 0
                                                ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height:
                                                            cx.height * 0.25,
                                                        // height: 200,
                                                        color: Colors.white,
                                                        alignment:
                                                            Alignment.center,
                                                        child: NunitoText(
                                                            text:
                                                                'Oops! No slots available',
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                            fontSize:
                                                                cx.responsive(
                                                                    35,27, 23),
                                                            color: Colors.grey
                                                                .shade600),
                                                      ),
                                                    ],
                                                  )
                                                : ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount: mycontroller
                                                        .myList.length,
                                                    itemBuilder:
                                                        (context, index) {

                                                      TimeSlotsModel item =mycontroller.myList[index];

                                                      return InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  if (item.status ==
                                                                      1) {
                                                                    if (selectedIndex
                                                                            .length !=
                                                                        0) {
                                                                      selectedIndex
                                                                          .sort();
                                                                      if (selectedIndex
                                                                          .contains(index)) {
                                                                        if (index == selectedIndex[0] ||
                                                                            index == selectedIndex[selectedIndex.length - 1]) {
                                                                          if (index ==
                                                                              selectedIndex[0]&&index!=selectedIndex[selectedIndex.length - 1]) {
                                                                            bottomNavigationTime(index, mycontroller.myList[index + 1]);
                                                                          } else if (index ==
                                                                              selectedIndex[selectedIndex.length - 1]&&index!=selectedIndex[0]) {
                                                                            bottomNavigationTime(index, mycontroller.myList[index - 1]);
                                                                          }
                                                                          selectedIndex.remove(index);
                                                                          totalPrice =
                                                                              previousPrice - item.price;
                                                                          previousPrice =
                                                                              totalPrice;
                                                                          removedIndex =
                                                                              index;
                                                                        }
                                                                      } else if (index == selectedIndex[0] - 1 ||
                                                                          index ==
                                                                              selectedIndex[selectedIndex.length - 1] + 1) {
                                                                        selectedIndex
                                                                            .add(index);

                                                                        totalPrice =
                                                                            previousPrice + item.price;
                                                                        previousPrice =
                                                                            totalPrice;
                                                                        bottomNavigationTime(
                                                                            index,
                                                                            mycontroller.myList[index]);
                                                                      }

                                                                      if (!selectedIndex.contains(index) &&
                                                                          index !=
                                                                              removedIndex) {
                                                                        onBookSlotAlert(
                                                                            context: context);
                                                                      }
                                                                    } else {
                                                                      selectedIndex
                                                                          .add(index);
                                                                      setState(
                                                                          () {
                                                                        totalPrice =
                                                                            previousPrice + item.price;
                                                                        previousPrice =
                                                                            totalPrice;
                                                                      });
                                                                      bottomNavigationTime(
                                                                          index,
                                                                          mycontroller.myList[index]);
                                                                    }


                                                                  }

                                                                  //Time For Bottom Navigation

                                                                  print(
                                                                      "startTimeeeeeee");
                                                                  print(
                                                                      startTime);
                                                                  print(
                                                                      startMeanTime);

                                                                  print(
                                                                      "endTimeeeeeee");
                                                                  print(
                                                                      endTime);
                                                                  print(
                                                                      endMeanTime);
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                  0,
                                                                  8,
                                                                  0,
                                                                  0,
                                                                ),
                                                                child:
                                                                    Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height:
                                                                      cx.height /
                                                                          12,
                                                                  decoration: BoxDecoration(
                                                                      color: item.status == 0
                                                                          ? Color(0xFFDADADA)
                                                                          : selectedIndex.contains(index)
                                                                              ? AppColor.bg
                                                                              : Colors.white,
                                                                      borderRadius: BorderRadius.all(Radius.circular(12)),
                                                                      border: Border.all(
                                                                        width: selectedIndex.contains(index)
                                                                            ? 1.8
                                                                            : 1.6,
                                                                        color: item.status == 0
                                                                            ? Color(0xFFA8A8A8)
                                                                            : selectedIndex.contains(index)
                                                                                ? Color(0xFF9BD9C1)
                                                                                : Color(0xFFF5F7F9),
                                                                      )),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      // Padding(
                                                                      //   padding: const EdgeInsets.only(
                                                                      //       left: 8.0),
                                                                      //   child: Row(
                                                                      //     children: [
                                                                      //       NunitoText(
                                                                      //         text:(index+1).toString()+":00 PM -",
                                                                      //         color: Colors.black,
                                                                      //         fontSize: cx.responsive(18,15, 13),
                                                                      //         fontWeight: FontWeight.w700,
                                                                      //
                                                                      //       ),
                                                                      //       NunitoText(
                                                                      //         text:(index+2).toString()+":00 PM",
                                                                      //         color: Colors.black,
                                                                      //         fontSize: cx.responsive(18,15, 13),
                                                                      //         fontWeight: FontWeight.w700,
                                                                      //
                                                                      //       ),
                                                                      //     ],
                                                                      //   ),
                                                                      // ),

                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(left: 8.0),
                                                                        child:
                                                                            NunitoText(
                                                                          text:
                                                                              item.slot,
                                                                          color: item.status == 0
                                                                              ? Color(0xFF757575)
                                                                              : Colors.black,
                                                                          fontSize:
                                                                              cx.responsive(18,15, 13),
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                        ),
                                                                      ),
                                                                      NunitoText(
                                                                        text:
                                                                            "\$${item.price}",
                                                                        color: item.status == 0
                                                                            ? Color(0xFF757575)
                                                                            : Colors.black,
                                                                        fontSize: cx.responsive(
                                                                            22,17, 15),
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                      item.status ==
                                                                              0
                                                                          ? Container(
                                                                              width: cx.width * 0.15,
                                                                            )
                                                                          : selectedIndex.contains(index)
                                                                              ? Container(
                                                                                  width: cx.width * 0.15,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(right: 12.0),
                                                                                    child: Icon(
                                                                                      Icons.highlight_remove_rounded,
                                                                                      color: Color(0xFFFF1A1A),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              : Container(
                                                                                  width: cx.width * 0.15,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(right: 12.0),
                                                                                    child: Icon(
                                                                                      Icons.add_circle_outline_rounded,
                                                                                      color: AppColor.lightGreen,
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                    },
                                                  ),
                                    selectedIndex.length == 0
                                        ? Gap(cx.height / 20)
                                        : Gap(cx.height / 15),
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
              selectedIndex.length != 0
                  ? Positioned(
                      bottom: -29,
                      child: (SvgPicture.asset(
                          "assets/svg/leftBottomNavigation.svg",
                          color: AppColor.darkGreen)),
                    )
                  : Container(),
              selectedIndex.length != 0
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
          bottomNavigationBar: selectedIndex.length != 0
              ? Container(
                  height: cx.height / 8.9,
                  color: AppColor.darkGreen,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 20, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        selectedIndex.length != 0
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SenticText(
                                        text: "\$" +
                                            totalPrice.toString() +
                                            " ",
                                        fontSize: cx.height > 800 ? 23 : 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        maxLines: 1,
                                        textOverflow: TextOverflow.ellipsis,
                                      ),
                                      SenticText(
                                        text:
                                            "(${selectedIndex.length} Slots Selected)",
                                        fontSize: cx.height > 800 ? 12 : 10,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                        maxLines: 1,
                                        textOverflow: TextOverflow.ellipsis,
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
                                    maxLines: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              )
                            : Container(),
                        AbsorbPointer(
                          absorbing: selectedIndex.length == 0 ? true : false,
                          child: Padding(
                            padding: EdgeInsets.only(bottom:  cx.responsive(cx.height / 25, cx.height / 35, cx.height / 50)),

                            child: Container(
                              child: CustomButton(
                                text: widget.isEditing?"Confirm":"Proceed",
                                fun: () {

                                  cx.write(Keys.price, totalPrice);
                                  cx.write(Keys.slots, selectedIndex.length);
                                  selectedIndex.forEach((element) {
                                    bookedSlotList = bookedSlotList + mycontroller.myList[element].slot +',';
                                    cx.write(
                                        Keys.slotsList,
                                        bookedSlotList.substring(
                                            0, bookedSlotList.length - 1));
                                  });



                                  cx.globalSelectedIndex=selectedIndex;
                                  cx.globalPrice.value=totalPrice;
                                  if(widget.isEditing){
                                    if(cx.read(Keys.fieldName).length!=0){
                                      List fields = cx.read(Keys.fieldName).split(",");
                                      cx.write(Keys.price, totalPrice*fields.length);
                                    }


                                    print("new price");
                                    print(cx.read(Keys.price));
                                  }
                                  else{

                                  }



                                  print("selectedIndex");
                                  print(cx.globalSelectedIndex);

                                  print(bookedSlotList.substring(
                                      0, bookedSlotList.length - 1));
                                  widget.isEditing?
                                      Get.back(result: [
                                        // cx.selDate.value,
                                        // cx.selMonth.value,
                                        cx.read(Keys.startTime),
                                        cx.read(Keys.endTime),
                                      ]):Get.to(
                                    SelectPlayers(isEditing: false,),
                                  )?.then((value) => refreshData());
                                },
                                radius: cx.height / 13.34,
                                width: cx.width *0.32,
                                size: cx.responsive(24,20, 18),
                                color: selectedIndex.length == 0
                                    ? Colors.grey
                                    : Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Container(height: 1, width: 1)),
    );
  }

  void bottomNavigationTime(int index, TimeSlotsModel item) {
    print("iti");
    print(item.slot);
    if (selectedIndex.length != 0) {
      selectedIndex.sort();
      print("item.slot.toString()");
      print(selectedIndex);
      print(selectedIndex[0]);
      print(selectedIndex[selectedIndex.length - 1]);

      if (index == selectedIndex[0]) {
        print("crushy1");
        print(item.slot.toString());

        cx.write(Keys.startTime, item.slot.toString());
        print("Original");
        print(cx.read(Keys.startTime));
        print(cx.read(Keys.endTime));

        setState(() {
          startTime = item.slot.toString().substring(0, 2);
          startMeanTime = item.slot.toString().substring(6, 8);
        });
        print("startTime");
        print(startTime);
        print(startMeanTime);
      }
      if (index == selectedIndex[selectedIndex.length - 1]) {
        print("crushy2");
        print(item.slot.toString());

        cx.write(Keys.endTime, item.slot.toString());
        print("Original");
        print(cx.read(Keys.startTime));
        print(cx.read(Keys.endTime));

        setState(() {
          endTime = item.slot.toString().substring(11, 13);
          endMeanTime = item.slot.toString().substring(17, 19);
        });
        print("endTime");
        print(endTime);
        print(endMeanTime);
      }
    }
  }


  refreshData() {
    cx.write(Keys.fieldName,'');
    print("hey");
    if(cx.globalSelectedIndex.length!=0){
      totalPrice=cx.globalPrice.value;
      previousPrice =totalPrice;
      print("hey1");
      print(cx.globalSelectedIndex.length);
      print(cx.globalSelectedIndex);
      setState((){
        selectedIndex=cx.globalSelectedIndex;

      });
      print("selectedIndex");
      print(selectedIndex);
    }
  }
  onBookSlotAlert({required BuildContext context, }) {
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
          Text(
            "Note",
            style: TextStyle(
                fontSize: cx.responsive(24,20, 18), fontWeight: FontWeight.w700),
          ),
          Gap(cx.height / 60),
          Text(
            "You cannot jump the time slot.Please select continuous time slot to proceed.",
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            maxLines: 3,
            style: TextStyle(
                fontSize: cx.responsive(22,18, 14), fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        ],
      ),
      closeIcon: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.cancel,
          color: Colors.red,
        ),
      ),
      // onWillPopActive:true ,
    ).show();
  }
}
