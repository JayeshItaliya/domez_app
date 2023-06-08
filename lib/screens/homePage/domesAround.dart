import 'package:domez/controller/commonController.dart';
import 'package:domez/controller/domesDetailsController.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../commonModule/AppColor.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/Strings.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../controller/domesListController.dart';
import '../../model/domesListModel.dart';
import '../authPage/signIn.dart';
import '../bookSteps/DomePage.dart';

class DomesAroundYou extends StatefulWidget {
  const DomesAroundYou({Key? key}) : super(key: key);

  @override
  State<DomesAroundYou> createState() => _DomesAroundYouState();
}

class _DomesAroundYouState extends State<DomesAroundYou> {
  final cx = Get.put(CommonController());
  final mycontroller = Get.put(DomesListController());
  final dx = Get.put(DomesDetailsController());
  String location = '';
  String Address = '';
  List<int> errorImagesDomeAround = [];

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);


    return Scaffold(
        body: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              Gap(cx.height / 40),
              Column(
                children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: cx.height / 33.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gap(cx.height / 50),
                        InkWell(
                          onTap: (){
                            Get.back();
                          },
                          child: Container(
                            width: cx.width*0.09,
                            height:cx.width*0.09,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFF5F7F9),
                                    blurRadius: 8,
                                    spreadRadius: 7, //New
                                  )
                                ],

                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  width: 1,
                                  color: Color(0xFFE8FFF6),
                                )
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left:cx.width*0.02),
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 18,
                                color: Colors.black,

                              ),
                            ),
                          ),
                        ),
                        Gap(cx.height / 30),
                        SenticText(
                          height: 1.2,
                          text:
                          'Domes\nAround You',
                          fontSize:
                          cx.height > 800
                              ? 30
                              : 26,
                          fontWeight:
                          FontWeight.w500,
                        ),

                      ],
                    ),
                  ),
                ],
              ),
              Gap(cx.height / 33.5),
              Obx(() =>cx.read(Keys.lat) == '' || cx.read(Keys.lng) == ''
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Gap(cx.height/33.5),
                        Column(
                          children: [
                            Gap(cx.height / 80),
                            InkWell(
                              onTap: () {
                                getCurrentLocation();
                              },
                              child: Container(
                                height: cx.height / 12,
                                width: cx.width * 0.55,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: AppColor.darkGreen,
                                ),
                                child: NunitoText(
                                  textAlign: TextAlign.center,
                                  text: "Get Nearby Domes",
                                  fontWeight: FontWeight.bold,
                                  fontSize: cx.height > 800 ? 20 : 18,
                                  color: Colors.white,
                                  // height: 2.3,
                                  textOverflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      // scrollDirection: Axis.horizontal,
                      itemCount: mycontroller.myList3.length,
                      itemBuilder: (context, index) {
                        DomesListModel item = mycontroller.myList3[index];

                        return InkWell(
                          onTap: () {
                            Get.to(
                              DomePage(
                                isFav: item.isFav,
                                domeId: item.id.toString(),
                              ),);
                            },
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: cx.height / 26.68,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: cx.height > 800 ? 300 : 265,
                                      width: cx.width - cx.height / 13.34,
                                      // color: Colors.white,
                                      decoration: BoxDecoration(
                                          // image: DecorationImage(
                                          //   image: AssetImage(
                                          //     Image1.domesAround,
                                          //   ),
                                          //   fit: BoxFit.fill,
                                          //
                                          // ),
                                          color: Colors.transparent,
                                          // border: Border.all(color: AppColor.bg, width: 1.2),
                                          // borderRadius: BorderRadius.circular(40),
                                          border: Border.all(
                                              color: Color(0xFFEDEBEB),
                                              width: 1.2),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: cx.height > 800 ? 200 : 170,
                                            width: double.infinity,
                                              decoration: errorImagesDomeAround
                                                  .contains(item
                                                  .id)
                                                  ? BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors
                                                          .transparent,
                                                      width:
                                                      1.2),
                                                  borderRadius: BorderRadius
                                                      .only(
                                                    bottomRight:
                                                    Radius.circular(0),
                                                    bottomLeft:
                                                    Radius.circular(0),
                                                    topLeft:
                                                    Radius.circular(12),
                                                    topRight:
                                                    Radius.circular(12),
                                                  ),
                                                  image: DecorationImage(
                                                      image: AssetImage(Image1.domesAround),
                                                      fit: BoxFit.cover,
                                                      scale: 0.8))
                                                  :BoxDecoration(
                                                  border: Border.all(color: Colors.transparent, width: 1.2),
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(12),
                                                    topRight: Radius.circular(12),
                                                  ),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                        item.image.isEmpty ? "https://cdn.xxl.thumbs.canstockphoto.com/3d-render-of-a-round-cricket-stadium-with-black-seats-and-vip-boxes-3d-render-of-a-beautiful-modern-clipart_csp46450310.jpg" : item.image,
                                                      ),
                                                      fit: BoxFit.cover,
                                                      onError: (Object e, StackTrace? stackTrace) {
                                                        setState(() {
                                                          errorImagesDomeAround.add(item.id);
                                                        });
                                                      },
                                                      scale: 0.8)),
                                          ),
                                          Positioned(
                                            right: 25,
                                            top: 18,
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  child: Icon(
                                                    item.isFav
                                                        ? Icons.favorite
                                                        : Icons
                                                            .favorite_border_rounded,
                                                    color: Colors.white,
                                                    size: cx.height / 23.82,
                                                  ),
                                                  onTap: () {
                                                    if (cx.read("islogin")) {
                                                      setState(() {
                                                        item.isFav =
                                                            !item.isFav;
                                                        print(index);
                                                      });
                                                      cx.favourite(
                                                          uid: cx.read("id")
                                                              .toString(),
                                                          type: "1",
                                                          did: item.id
                                                              .toString());
                                                    } else {
                                                      print(index);
                                                      Get.to(
                                                          SignIn(curIndex: 0));
                                                      onAlertSignIn(
                                                          context: context);
                                                    }
                                                  },
                                                ),
                                                SizedBox(
                                                    height: cx.height / 44.47),
                                                Image.asset(
                                                  Image1.calendar,
                                                  scale:
                                                      cx.height > 800 ? 1.6 : 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                              right: cx.height > 800
                                                  ? cx.height / 40
                                                  : cx.height / 37.06,
                                              bottom: cx.responsive(95, 70, 55),
                                              child: Container(
                                                height: cx.responsive(75, 72, 65),
                                                alignment: Alignment(0, 0),
                                                width: cx.responsive(76, 69, 65),
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFFFE68A),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            cx.height / 66.7)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: cx.width * 0.8,
                                                      child: InterText(
                                                        // text: item.price.toStringAsFixed(0).toString(),
                                                        text: "\$" +
                                                            item.price
                                                                .toInt()
                                                                .toString(),
                                                        fontSize:
                                                            cx.height > 800
                                                                ? 18
                                                                : 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xFF07261A),
                                                        textAlign:
                                                            TextAlign.center,
                                                        height: 0,
                                                      ),
                                                    ),
                                                    InterText(
                                                      height: 0,
                                                      textAlign:
                                                          TextAlign.center,
                                                      text: '/Hour',
                                                      fontSize: cx.height > 800
                                                          ? 12
                                                          : 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFF07261A),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                          Positioned(
                                              left: cx.height / 44.47,
                                              bottom: cx.height / 44.47,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  InterText(
                                                    text: item.totalFields.toString() + " Fields",
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColor.darkGreen,
                                                    fontSize: cx.height > 800 ? 18 : 15,
                                                    height: 1,
                                                  ),
                                                  Gap(3),
                                                  Container(
                                                    width: cx.width / 1.6,
                                                    child: InterText(
                                                      text: item.name,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.black,
                                                      fontSize: cx.height > 800 ? 21 : 18,
                                                      height: 1,
                                                    ),
                                                  ),
                                                  Gap(4),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Image.asset("assets/images/location.png", scale: cx.responsive(2.5,1.5, 2), color: AppColor.darkGreen),
                                                      Container(
                                                          width: cx.width / 2,
                                                          child: NunitoText(
                                                            textAlign: TextAlign.start,
                                                            text: "${item.city}, ${item.state}",
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: cx.height > 800 ? 18 : 15,
                                                            maxLines: 1,
                                                            color: AppColor.darkGreen,
                                                            height: 1,
                                                            textOverflow: TextOverflow.ellipsis,
                                                          )),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          Positioned(
                                            right: cx.responsive(30,20, 13),
                                            bottom: cx.height / 42,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  width: cx.width / 4,
                                                  height: cx.responsive(50,40, 34),
                                                  child: ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: mycontroller
                                                          .myList2[index]
                                                          .sportsList
                                                          .length,
                                                      itemBuilder:
                                                          (context, i) {
                                                        if(i<=1) {
                                                          return Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                i == 0
                                                                    ? cx
                                                                    .height /
                                                                    41.69
                                                                    : 3,
                                                                10,
                                                                0,
                                                                0),
                                                            child: Image
                                                                .network(
                                                              item.sportsList[i]
                                                                  .image,
                                                              scale: cx.height >
                                                                  800
                                                                  ? 1.2
                                                                  : 1.4,
                                                              color: AppColor
                                                                  .darkGreen,
                                                            ),
                                                          );
                                                        }
                                                        else{
                                                          return Container();
                                                        }
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Gap(cx.height / 22.23)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
            ],
              ),
            ]));
  }
  Future<void> getCurrentLocation() async {
    Position position = await _getGeoLocationPosition();
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    GetAddressFromLatLong(position);

    cx.lat.value = position.latitude.toString();
    cx.lng.value = position.longitude.toString();

    print(cx.lat.value);
    print(cx.lng.value);
    cx.write(Keys.lat,cx.lat.value);
    cx.write(Keys.lng,cx.lng.value);
    debugPrint(location);
    debugPrint(Address);
  }
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    debugPrint("++++++" + placemarks.toString());
    Placemark place = placemarks[0];
    Address =
    '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    cx.searchDome.value = place.locality! + "," + place.country.toString();

    debugPrint(cx.searchDome.value.toString());
  }
}
