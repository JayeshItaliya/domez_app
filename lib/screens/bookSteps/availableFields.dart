import 'package:domez/commonModule/Constant.dart';
import 'package:domez/controller/availableFieldController.dart';
import 'package:domez/model/availableFieldsModel.dart';
import 'package:domez/screens/bookSteps/reviewAndConfirm.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:domez/commonModule/Strings.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../../commonModule/AppColor.dart';
import '../../../controller/commonController.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../commonModule/widget/search/customButton.dart';
import '../../commonModule/widget/search/simplecircularIcon.dart';
import '../../commonModule/utils.dart';
import '../../commonModule/utils.dart';

class AvailableFields extends StatefulWidget {
  bool isEditing;

  AvailableFields({Key? key, required this.isEditing}) : super(key: key);

  @override
  State<AvailableFields> createState() => _AvailableFieldsState();
}

class _AvailableFieldsState extends State<AvailableFields> {
  CommonController cx = Get.put(CommonController());
  AvailableFieldController mycontroller = Get.put(AvailableFieldController());

  List<int> selectedIdList = [];
  List<String> fieldNameList = [];
  List<int> erroravailableFields = [];
  List<int> errorDomeImage = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(cx.globalAvailableFieldIndex);
    print(cx.globalAvailableFieldName);
    print("selectedIndex");
    print(selectedIdList);
    if (cx.globalAvailableFieldIndex.length != 0) {
      for (int i = 0; i < cx.globalAvailableFieldIndex.length; i++) {
        setState(() {
          selectedIdList.add(cx.globalAvailableFieldIndex[i]);
        });
      }
      print("selectedIdList");
      print(selectedIdList);
    }
    if (cx.globalAvailableFieldName.length != 0) {
      for (int i = 0; i < cx.globalAvailableFieldName.length; i++) {
        setState(() {
          fieldNameList.add(cx.globalAvailableFieldName[i]);
        });
      }
      print("selectedIdList");
      print(selectedIdList);
    }

    cx.price.value = cx.read(Keys.price);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
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
                                  decoration: errorDomeImage
                                          .contains(cx.read(Keys.domeId))
                                      ? BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                            image: AssetImage(
                                              Image1.domesAround,
                                            ),
                                            fit: BoxFit.cover,
                                          ))
                                      : BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  cx.height / 26.68)),
                                      gradient: backShadowContainer(),

                                      image: DecorationImage(
                                            image: NetworkImage(
                                              (cx.read(
                                                Keys.image,
                                              )).isEmpty
                                                  ? "https://thumbs.dreamstime.com/b/indoor-stadium-view-behind-wicket-cricket-160851985.jpg"
                                                  : cx.read(
                                                      Keys.image,
                                                    ),
                                              scale:
                                                  cx.height > 800 ? 1.8 : 2.4,
                                            ),
                                            fit: BoxFit.cover,
                                            onError: (Object e,
                                                StackTrace? stackTrace) {
                                              setState(() {
                                                errorDomeImage
                                                    .add(cx.read(Keys.domeId));
                                              });
                                            },
                                          )),
                                  margin: EdgeInsets.only(
                                      left: 8, right: 8, top: 8),
                                  width: MediaQuery.of(context).size.width,
                                  height: cx.height / 4.3,
                                ),
                                Positioned(
                                  top: cx.height / 6.06,
                                  // top: cx.responsive(200,167, 130),
                                  right: 20,
                                  left: 20,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
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
                                              text: cx.read(Keys.domeName),
                                              maxLines: 2,
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
                                                    scale: cx.responsive(
                                                        2.5, 1.5, 2),
                                                    color: AppColor.darkGreen),
                                                Container(
                                                  width: cx.width * 0.65,
                                                  child: NunitoText(
                                                    textAlign: TextAlign.start,
                                                    text:
                                                        "${cx.read(Keys.city)}, ${cx.read(Keys.state)}",
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: cx.height > 800
                                                        ? 18
                                                        : 15,
                                                    color: AppColor.lightGreen,
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
                              radius: cx.responsive(30, 25, 22),
                              child: SimpleCircularIconButton(
                                iconData: Icons.arrow_back_ios_new,
                                iconColor: Colors.black,
                                radius: cx.responsive(60, 47, 37),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: cx.height / 2.9,
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
                                        text: "Available Fields",
                                        fontSize: cx.responsive(37, 27, 25),
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Gap(cx.height / 80),
                                    Obx(
                                      () => mycontroller.isoffline.value
                                          ? noInternetLottie()
                                          : mycontroller.isDataProcessing.value
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: cx.height * 0.4,
                                                      // height: 200,
                                                      color: Colors.white,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: AppColor
                                                              .darkGreen,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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
                                                              cx.height * 0.4,
                                                          // height: 200,
                                                          color: Colors.white,
                                                          alignment:
                                                              Alignment.center,
                                                          child: NunitoText(
                                                              text:
                                                                  'Oops! No field available for your selection',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              fontSize:
                                                                  cx.responsive(
                                                                      35,
                                                                      27,
                                                                      23),
                                                              color: Colors.grey
                                                                  .shade600),
                                                        ),
                                                      ],
                                                    )
                                                  : ListView(
                                                      shrinkWrap: true,
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              child: Obx(
                                                                () => ListView
                                                                    .builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      BouncingScrollPhysics(),
                                                                  itemCount:
                                                                      mycontroller
                                                                          .myList
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    AvailableFieldsModel
                                                                        item =
                                                                        mycontroller
                                                                            .myList[index];
                                                                    return InkWell(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          // curfieldindex = index;
                                                                          if (selectedIdList
                                                                              .contains(item.id)) {
                                                                            if (selectedIdList.length ==
                                                                                2) {
                                                                              cx.write(Keys.price, cx.read(Keys.price) / 2);
                                                                            }
                                                                            selectedIdList.remove(item.id);
                                                                            fieldNameList.remove(item.name);
                                                                          } else {
                                                                            if (selectedIdList.length >=
                                                                                2) {
                                                                              // showLongToast("Max 2 Fields can Be Selected");
                                                                              onFieldSelectionAlert(context: context, errorText: "Please select maximum two fields to\ncontinue booking your dome");
                                                                            } else {
                                                                              if (selectedIdList.length == 1) {
                                                                                cx.write(Keys.price, cx.read(Keys.price) * 2);
                                                                              }
                                                                              selectedIdList.add(item.id);
                                                                              fieldNameList.add(item.name);
                                                                            }
                                                                          }
                                                                        });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height: cx.height /
                                                                            5.13,
                                                                        width:
                                                                            cx.width /
                                                                                5,
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Container(
                                                                                    width: cx.responsive(cx.width / 4.5, cx.width / 4, cx.width / 3.7),
                                                                                    height: cx.responsive(160, 135, 120),
                                                                                    decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.all(
                                                                                          Radius.circular(20),
                                                                                        ),
                                                                                        gradient: backShadowContainer(),
                                                                                        image: DecorationImage(
                                                                                            image: NetworkImage(
                                                                                              item.image,
                                                                                            ),
                                                                                            fit: BoxFit.cover)),
                                                                                  ),
                                                                                ),
                                                                                Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsets.fromLTRB(cx.responsive(15, 10, 8), cx.height / 50, 0, 0),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          Container(
                                                                                            decoration: erroravailableFields.contains(item.id)
                                                                                                ? BoxDecoration(
                                                                                                    image: DecorationImage(
                                                                                                    image: AssetImage(
                                                                                                      Image1.domesAround,
                                                                                                    ),
                                                                                                  ))
                                                                                                : BoxDecoration(
                                                                                                    image: DecorationImage(
                                                                                                    image: NetworkImage(
                                                                                                      item.sportData.image,
                                                                                                    ),
                                                                                                    onError: (Object e, StackTrace? stackTrace) {
                                                                                                      erroravailableFields.add(item.id);
                                                                                                    },
                                                                                                  )),
                                                                                            height: 25,
                                                                                            width: cx.responsive(40, 30, 21),
                                                                                            alignment: Alignment.centerLeft,
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.only(left: 3.0),
                                                                                            child: Container(
                                                                                              child: NunitoText(
                                                                                                textAlign: TextAlign.start,
                                                                                                fontSize: cx.responsive(23, 19, 16),
                                                                                                fontWeight: FontWeight.w700,
                                                                                                text: item.sportData.name,
                                                                                                color: Color(0xFFA8A8A8),
                                                                                                textOverflow: TextOverflow.ellipsis,
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                              width: cx.width * 0.38,
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(left: 9.0),
                                                                                      child: Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Container(
                                                                                            width: cx.width * 0.43,
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                                                                                              child: InterText(
                                                                                                text: "Field " + item.name,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                fontSize: cx.responsive(26, 22, 19),
                                                                                                // color: Color(0xFF6E6B6B),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Padding(
                                                                                              padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                                                                                              child: NunitoText(
                                                                                                textAlign: TextAlign.start,
                                                                                                fontSize: cx.responsive(25, 19, 16),
                                                                                                fontWeight: FontWeight.w400,
                                                                                                text: "Capacity:",
                                                                                                color: Color(0xFFA8A8A8),
                                                                                              )),
                                                                                          Padding(
                                                                                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                                                                              child: NunitoText(
                                                                                                textAlign: TextAlign.start,
                                                                                                fontSize: cx.responsive(25, 19, 16),
                                                                                                fontWeight: FontWeight.w500,
                                                                                                text: "${item.minPerson} - ${item.maxPerson} People",
                                                                                                color: Color(0xFF656565),
                                                                                              )),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Positioned(
                                                                              bottom: cx.responsive(50, 33, 20),
                                                                              right: cx.height / 66.7,
                                                                              child: InkWell(
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    // curfieldindex = index;
                                                                                    if (selectedIdList.contains(item.id)) {
                                                                                      if (selectedIdList.length == 2) {
                                                                                        cx.write(Keys.price, cx.read(Keys.price) / 2);
                                                                                      }
                                                                                      selectedIdList.remove(item.id);
                                                                                      fieldNameList.remove(item.name);
                                                                                    } else {
                                                                                      if (selectedIdList.length >= 2) {
                                                                                        onFieldSelectionAlert(context: context, errorText: "Please select maximum two fields to\ncontinue booking your dome");

                                                                                        // showLongToast("Max 2 Fields can Be Selected");
                                                                                      } else {
                                                                                        if (selectedIdList.length == 1) {
                                                                                          cx.write(Keys.price, cx.read(Keys.price) * 2);
                                                                                        }
                                                                                        selectedIdList.add(item.id);
                                                                                        fieldNameList.add(item.name);
                                                                                      }
                                                                                    }
                                                                                  });
                                                                                },
                                                                                child: Container(
                                                                                  child: Icon(
                                                                                    Icons.check,
                                                                                    color: Colors.white,
                                                                                    size: cx.responsive(33, 25, 20),
                                                                                  ),
                                                                                  decoration: BoxDecoration(color: selectedIdList.contains(item.id) ? AppColor.darkGreen : Colors.white, border: Border.all(color: AppColor.darkGreen)),
                                                                                  height: cx.responsive(35, 27, 22),
                                                                                  width: cx.responsive(35, 27, 22),
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
                                                            ),
                                                            Gap(80),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                    ),
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
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                          SenticText(
                            text: cx.read(Keys.slots)==1?"(${cx.read(Keys.slots)} Slot Selected)":"(${cx.read(Keys.slots)} Slots Selected)",
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
                            cx.read(Keys.endTime).toString().substring(11, 19),
                        fontSize: cx.height > 800 ? 17 : 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9AE3C7),
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: cx.responsive(
                            cx.height / 25, cx.height / 35, cx.height / 50)),
                    child: Container(
                      child: CustomButton(
                        text: widget.isEditing ? "Confirm" : "Proceed",
                        fun: () {
                          if (selectedIdList.length != 0) {
                            cx.write(Keys.fieldName, fieldNameList.join(","));
                            cx.write(Keys.fieldId, selectedIdList.join(","));

                            print("selectedIdIndex");
                            print(fieldNameList);
                            print(selectedIdList.join(","));
                            cx.globalAvailableFieldIndex = selectedIdList;
                            cx.globalAvailableFieldName = fieldNameList;
                            cx.price.value = cx.read(Keys.price);

                            widget.isEditing
                                ? Get.back(result: cx.read(Keys.fieldName))
                                : Get.to(
                                    ReviewConfirm(),
                                  )?.then((value) => refreshData());
                          } else {
                            onFieldSelectionAlert(
                                context: context,
                                errorText:
                                    "Please select the field to continue\nbooking your slot");
                          }
                        },
                        radius: cx.height / 13.34,
                        width: cx.width * 0.32,
                        size: cx.responsive(25, 20, 18),
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

  onFieldSelectionAlert(
      {required BuildContext context, required String errorText}) {
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
            "Select Field",
            style: TextStyle(
                fontSize: cx.responsive(25, 20, 18),
                fontWeight: FontWeight.w700),
          ),
          Gap(cx.height / 60),
          Text(
            errorText,
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            maxLines: 3,
            style: TextStyle(
                fontSize: cx.responsive(22, 18, 14),
                fontWeight: FontWeight.w400,
                color: Colors.grey),
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

  refreshData() {
    print("hey");

    if (cx.globalAvailableFieldIndex.length != 0) {
      cx.write(Keys.price, cx.price.value);

      print("Price");
      print(cx.read(Keys.price));
      print(cx.globalAvailableFieldIndex.length);
      print(cx.globalAvailableFieldIndex);
      setState(() {
        selectedIdList = cx.globalAvailableFieldIndex;
      });
      print("globalAvailableFieldIDIndex");
      print(selectedIdList);
    }

    if (cx.globalAvailableFieldName.length != 0) {
      print(cx.globalAvailableFieldName.length);
      print(cx.globalAvailableFieldName);
      setState(() {
        fieldNameList = cx.globalAvailableFieldName;
      });
      print("globalAvailableFieldNameIndex");
      print(fieldNameList);
    }
  }
}
