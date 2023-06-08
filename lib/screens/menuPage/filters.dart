import 'dart:math';
import 'package:domez/commonModule/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../commonModule/Strings.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../controller/categoryController.dart';
import '../../controller/commonController.dart';
import '../../controller/domesListController.dart';
import '../../controller/filterListController.dart';
import '../../model/categoryModel.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textNunito.dart';

class Filters extends StatefulWidget {
  const Filters({Key? key}) : super(key: key);

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  CommonController cx = Get.put(CommonController());
  final mycontroller = Get.put(CategoryController());
  final domesListController = Get.put(DomesListController());
  final filterListController = Get.put(FilterListController());

  int? _key;
  bool iscategories = false;
  bool isType = false;
  bool isdistance = false;
  bool isprice = false;

  bool isDome = true;
  double distance = 200.0;
  double minDistance = 0.0;
  double maxDistance = 500.0;
  List<int> sportsList = [];

  double start1 = 0.0;
  double end1 = 100.0;
  double minPrice = 0.0;
  double maxPrice = 500.0;
  RangeLabels labels = RangeLabels('1', "500");

  int vollyIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  _collapse() {
    int? newKey;
    do {
      _key = Random().nextInt(10000);
    } while (newKey == _key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F3F3),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 18, 30, 18),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: SvgPicture.asset(
                    "assets/svg/filterCancel.svg",
                    height: 38,
                  ),
                  onTap: () {
                    cx.searchDome.value = "";
                    Get.back();
                  },
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      start1 = 0.0;
                      end1 = 100.0;
                      isDome = true;
                      distance = 200.0;
                      sportsList.clear();
                    });
                  },
                  child: SenticText(
                    text: 'Reset',
                    fontSize: cx.height > 800 ? 19 : 17,
                    fontWeight: FontWeight.w600,
                    color: AppColor.darkGreen,
                  ),
                ),
              ],
            ),
            Gap(cx.height / 26.68),
            SenticText(
              text: 'Filters',
              fontSize: cx.height > 800 ? 32 : 28,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            Gap(cx.height / 60),
            ExpansionTile(
              maintainState: true,
              collapsedIconColor: AppColor.darkGreen,
              onExpansionChanged: (s) {
                setState(() {
                  isType = s;
                });
              },
              tilePadding: EdgeInsets.zero,
              title: SenticText(
                  height: 1.2,
                  text: 'Select Type',
                  fontSize: cx.height > 800 ? 20 : 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6A6A6A)),
              trailing: Icon(
                isType
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: cx.responsive(45,38, 33),
              ),
              childrenPadding: EdgeInsets.zero,
              expandedAlignment: Alignment.bottomLeft,
              expandedCrossAxisAlignment: CrossAxisAlignment.center,
              iconColor: AppColor.darkGreen,
              children: [
                Container(
                  height: cx.height / 13.34,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            isDome = true;
                          });
                        },
                        child: Row(
                          children: [
                            Container(
                              height: cx.responsive(65,53, 44),
                              width: cx.width / 2.45,
                              decoration: BoxDecoration(
                                  color: isDome
                                      ? AppColor.darkGreen
                                      : Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: Color(0xFFD4D4D4))),
                              alignment: Alignment.center,
                              // height: cx.height/cx.height/66.7,
                              child: NunitoText(
                                text: "Pickups",
                                fontSize: cx.height > 800 ? 18 : 16,
                                fontWeight: FontWeight.w700,
                                color: isDome ? Colors.white : Colors.black,
                                textOverflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Gap(5),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isDome = false;
                          });
                        },
                        child: Container(
                          height: cx.responsive(65,53, 44),
                          width: cx.width / 2.45,
                          decoration: BoxDecoration(
                              color: isDome
                                  ? Colors.white.withOpacity(0.15)
                                  : AppColor.darkGreen,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: Color(0xFFD4D4D4))),
                          alignment: Alignment.center,
                          // height: cx.height/cx.height/66.7,
                          child: NunitoText(
                            text: "League",
                            fontSize: cx.height > 800 ? 18 : 16,
                            fontWeight: FontWeight.w700,
                            color: isDome ? Colors.black : Colors.white,
                            textOverflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(
                  cx.height / 33.5,
                )
              ],
            ),
            ExpansionTile(
              maintainState: true,
              collapsedIconColor: AppColor.darkGreen,
              onExpansionChanged: (s) {
                setState(() {
                  iscategories = s;
                });
              },
              tilePadding: EdgeInsets.zero,
              title: SenticText(
                  height: 1.2,
                  text: 'Choose Categories',
                  fontSize: cx.height > 800 ? 20 : 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6A6A6A)),
              trailing: Icon(
                iscategories
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: cx.responsive(45,38, 33),
              ),
              childrenPadding: EdgeInsets.zero,
              expandedAlignment: Alignment.bottomLeft,
              expandedCrossAxisAlignment: CrossAxisAlignment.center,
              iconColor: AppColor.darkGreen,
              children: [
                Container(
                  height: cx.height / 13.34,
                  child: ListView.builder(
                      itemCount: mycontroller.myList.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        CategoryModel item = mycontroller.myList[index];

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: InkWell(
                                onTap: () {
                                  if (sportsList.contains(item.id)) {
                                    setState(() {
                                      sportsList.remove(item.id);
                                    });
                                  } else {
                                    setState(() {
                                      sportsList.add(item.id);
                                    });
                                  }

                                  print(sportsList);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: cx.responsive(6,4, 2),
                                    right: cx.responsive(6,4, 2),
                                  ),
                                  child: Container(
                                    height: cx.responsive(65,53, 44),
                                    width: cx.width / 2.75,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(100),
                                    ),
                                    // height: cx.height/cx.height/66.7,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: cx.height / 83.375),
                                          child: CircleAvatar(
                                            radius:
                                                cx.responsive(30,22, 17),
                                            backgroundColor:Colors.transparent,

                                            child: Image.network(
                                            item.image,
                                              color: sportsList.contains(item.id)
                                                  ?Colors.white
                                                  : AppColor.darkGreen,
                                          ),
                                          ),
                                        ),
                                        Gap(5),
                                        Container(
                                          width: cx.width / 5.3,
                                          child: NunitoText(
                                            text: item.name,
                                            fontSize: cx.height > 800
                                                ? 18
                                                : 16,
                                            fontWeight: FontWeight.w700,
                                            color: sportsList.contains(item.id)
                                                ? Colors.white
                                                : Colors.black,
                                            textOverflow:
                                                TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: sportsList.contains(item.id)
                                      ? AppColor.darkGreen
                                      : Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: Color(0xFFD4D4D4))),
                            ),
                            SizedBox(
                              width: cx.width / 50,
                            )
                          ],
                        );
                      }),
                ),
                Gap(
                  cx.height / 33.5,
                )
              ],
            ),
            ExpansionTile(

              maintainState: true,
              key: Key(_key.toString()),
              collapsedIconColor: AppColor.darkGreen,
              trailing: Icon(
                isdistance
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: cx.responsive(45,38, 33),
              ),
              iconColor: AppColor.darkGreen,
              onExpansionChanged: (s) {
                setState(() {
                  isdistance = s;
                });
              },
              tilePadding: EdgeInsets.zero,
              title: SenticText(
                  height: 1.2,
                  text: 'Select Distance Range',
                  fontSize: cx.height > 800 ? 20 : 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6A6A6A)),
              childrenPadding: EdgeInsets.zero,
              expandedAlignment: Alignment.bottomLeft,
              expandedCrossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Slider(
                      value: distance,
                      activeColor: AppColor.darkGreen,
                      inactiveColor: AppColor.Green,
                      min: minDistance,
                      max: maxDistance,
                      divisions: 60,
                      label: distance.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          distance = value;
                        });
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SenticText(
                              text: "",
                              fontSize: cx.height > 800 ? 18 : 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6A6A6A)),
                          SenticText(
                              text: distance.toStringAsFixed(00) + "Km",
                              fontSize: cx.height > 800 ? 18 : 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6A6A6A)),
                        ],
                      ),
                    ),


                    // Text(
                    //   "Start: " +
                    //       start.toStringAsFixed(2) +
                    //       "\nEnd: " +
                    //       end.toStringAsFixed(2),
                    //   style: const TextStyle(
                    //     fontSize: 32.0,
                    //   ),
                    // ),
                    Gap(cx.height / 26.68),
                  ],
                ),
              ],
            ),
            ExpansionTile(
              maintainState: true,
              collapsedIconColor: AppColor.darkGreen,
              iconColor: AppColor.darkGreen,
              trailing: Icon(
                isprice
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: cx.responsive(45,38, 33),
              ),
              onExpansionChanged: (s) {
                setState(() {
                  isprice = s;
                });
              },
              tilePadding: EdgeInsets.zero,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SenticText(
                      height: 1.2,
                      text: 'Select Price Range',
                      fontSize: cx.height > 800 ? 20 : 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6A6A6A)),
                  Padding(
                    padding: EdgeInsets.only(top: cx.responsive(6,4, 2)),
                    child: SenticText(
                      text: isDome?' (Per Hour)':' (Per Team)',
                      fontSize: cx.height > 800 ? 14 : 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.black.withOpacity(0.28),
                    ),
                  ),
                ],
              ),
              childrenPadding: EdgeInsets.zero,
              expandedAlignment: Alignment.bottomLeft,
              expandedCrossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    RangeSlider(
                      activeColor: AppColor.darkGreen,

                      inactiveColor: AppColor.Green,
                      values: RangeValues(start1, end1),
                      labels: labels,
                      // divisions: 500,
                      onChanged: (value) {
                        setState(() {
                          start1 = value.start;
                          end1 = value.end;
                          // start.toString(), end.toString()

                          labels = RangeLabels(
                              "\$${value.start.toInt().toString()}",
                              "\$${value.end.toInt().toString()}");
                        });
                      },
                      min: minPrice,
                      max: maxPrice,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SenticText(
                              text: "\$" + start1.toStringAsFixed(0),
                              fontSize: cx.height > 800 ? 18 : 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6A6A6A)),
                          SenticText(
                              text: "\$" + end1.toStringAsFixed(0),
                              fontSize: cx.height > 800 ? 18 : 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6A6A6A)),
                        ],
                      ),
                    ),
                    Gap(cx.height / 26.68),
                  ],
                ),
              ],
            ),
            Gap(cx.height / 5),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: cx.responsive(33,25, 20),
          right: cx.responsive(35,25, 18),
          left: cx.responsive(35,25, 18),
        ),
        child: InkWell(
          onTap: () {
            cx.searchDome.value = "";

            print("isDome");
            print(isDome);
            print(
              cx.read(Keys.lat),
            );
            print(
                cx.read(Keys.lng)
            );
            print(distance);
            print(start1);
            print(end1);
            print(sportsList.join(","));

            filterListController.type.value = isDome ? "1" : "2";
            filterListController.sportId.value = sportsList.join(',');
            filterListController.minPrice.value = start1.toStringAsFixed(2);
            filterListController.maxPrice.value = end1.toStringAsFixed(2);
            filterListController.distance.value = distance.toStringAsFixed(2);
            print(filterListController.type.value);
            print(filterListController.sportId.value);
            print(filterListController.minPrice.value);
            print(filterListController.maxPrice.value);
            print(filterListController.distance.value);

            // filterListController.getTask(true);
            filterListController.getTask(true);
            Get.back();
          },
          child: Container(
            height:cx.height / 12,
            width: cx.width / 1.1,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                borderRadius: BorderRadius.circular(
                  cx.height / 44.47,
                )),
            padding: EdgeInsets.all(cx.height / 66.7),
            child: Obx(()=> filterListController.isDataProcessing.value
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Center(
                      child: NunitoText(
                        text: "Apply Filters",
                        fontWeight: FontWeight.w700,
                        fontSize: cx.responsive(25, 22, 15),
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
