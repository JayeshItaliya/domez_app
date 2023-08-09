import 'package:domez/controller/commonController.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../commonModule/AppColor.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/Strings.dart';
import '../../controller/leagueDetailsController.dart';
import '../../controller/leaguesListController.dart';
import '../../model/leagueListModel.dart';
import '../authPage/signIn.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/common/textSentic.dart';
import 'leaguePageDetails.dart';
import '../../commonModule/utils.dart';


class LeagueAroundYou extends StatefulWidget {
  const LeagueAroundYou({Key? key}) : super(key: key);

  @override
  State<LeagueAroundYou> createState() => _LeagueAroundYouState();
}

class _LeagueAroundYouState extends State<LeagueAroundYou> {
  final cx = Get.put(CommonController());
  final mycontroller = Get.put(LeagueListController());
  final lx = Get.put(LeagueDetailsController());
  List<int> errorImagesLeagueAround = [];

  String location = '';
  String Address = '';

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);

    return WillPopScope(
      onWillPop: () async {
        mycontroller.page.value=1;
        return true;

      },
      child: Scaffold(
          body: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              controller: mycontroller.scrollController3,
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
                              mycontroller.page.value=1;

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
                            text: 'Leagues\nAround You',
                            fontSize: cx.height > 800 ? 30 : 26,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(cx.height / 33.5),
                Obx(() => cx.read(Keys.lat) == '' || cx.read(Keys.lng) == ''
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
                    : Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            // scrollDirection: Axis.horizontal,
                            itemCount: mycontroller.myList3.length,
                  //controller: mycontroller.scrollController3,
                            itemBuilder: (context, index) {
                              LeagueListModel item = mycontroller.myList3[index];

                              return InkWell(
                                onTap: () {
                                  cx.write(Keys.image, item.image);

                                  Get.to(
                                      LeaguePageDetails(
                                        isFav: item.isFav,
                                        leagueId: item.id.toString(),));
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
                                                    color: AppColor.bg, width: 1.2),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  height: cx.height > 800 ? 200 : 170,
                                                  width: double.infinity,
                                                  decoration: errorImagesLeagueAround
                                                          .contains(item.id)
                                                      ? BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.transparent,
                                                              width: 1.2),
                                                          borderRadius:
                                                              BorderRadius.only(
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
                                                              image: AssetImage(
                                                                  Image1.domesAround),
                                                              fit: BoxFit.cover,
                                                              scale: 0.8))
                                                      : BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.transparent,
                                                              width: 1.2),
                                                          borderRadius:
                                                              BorderRadius.only(
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
                                                              image: NetworkImage(
                                                                  item.image),
                                                              onError: (Object e,
                                                                  StackTrace?
                                                                      stackTrace) {
                                                                setState(() {
                                                                  errorImagesLeagueAround
                                                                      .add(item.id);
                                                                });
                                                              },
                                                              fit: BoxFit.cover,
                                                              scale: 0.8)),
                                                ),
                                                Positioned(
                                                  right: 10,
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
                                                              // fav=!fav;
                                                              // print(mostPopular);
                                                              // mostPopular[index] =!mostPopular[index];
                                                              item.isFav =
                                                                  !item.isFav;
                                                            });
                                                            cx.favourite(
                                                                uid: cx.read("id")
                                                                    .toString(),
                                                                type: "2",
                                                                lid: item.id
                                                                    .toString());
                                                          } else {
                                                            Get.to(
                                                                SignIn(curIndex: 2));
                                                            onAlertSignIn(
                                                                context: context,currentIndex: 2,noOfPopTimes: 1);
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
                                                    left: cx.height / 44.47,
                                                    bottom: cx.height / 44.47,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          width: cx.width * 0.57,
                                                          child: InterText(
                                                            text: item.domeName,
                                                            // text: "item.name",
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.black,
                                                            fontSize: cx.height > 800
                                                                ? 21
                                                                : 18,
                                                            height: 1,
                                                          ),
                                                        ),
                                                        Gap(3),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.start,
                                                          children: [
                                                            Image.asset(
                                                              "assets/images/location.png",
                                                              scale: cx.responsive(2.5,1.5, 2),
                                                              color: AppColor.darkGreen,
                                                            ),
                                                            Container(
                                                              width: cx.width * 0.53,
                                                              child: NunitoText(
                                                                  textAlign:
                                                                      TextAlign.start,
                                                                  text:
                                                                      "${item.city}, ${item.state}",
                                                                  fontWeight:
                                                                      FontWeight.w400,
                                                                  maxLines: 1,
                                                                  fontSize:
                                                                      cx.height > 800
                                                                          ? 18
                                                                          : 15,
                                                                  color: AppColor
                                                                      .darkGreen,
                                                                  height: 1),
                                                            ),
                                                          ],
                                                        ),
                                                        Gap(4),
                                                        InterText(
                                                          text: item.date,
                                                          fontWeight: FontWeight.w500,
                                                          color: AppColor.darkGreen,
                                                          fontSize: cx.height > 800
                                                              ? 18
                                                              : 15,
                                                          height: 1,
                                                        ),
                                                      ],
                                                    )),
                                                Positioned(
                                                  right: cx.height / 44.47,
                                                  bottom: cx.height / 44.47,
                                                  child: Image.network(
                                                    item.sportData[0].image,
                                                    // item.image,
                                                    scale:
                                                        cx.height > 800 ? 1.2 : 1.4,
                                                    color: AppColor.darkGreen,
                                                  ),
                                                ),
                                                Positioned(
                                                    left: cx.width / 25,
                                                    top: cx.height / 30,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          width: cx.width * 0.65,
                                                          child: NunitoText(
                                                            shadow: <Shadow>[
                                                              Shadow(
                                                                offset:
                                                                    Offset(1.0, 1.0),
                                                                blurRadius: 3.0,
                                                                color: Color.fromARGB(
                                                                    255, 0, 0, 0),
                                                              ),
                                                              Shadow(
                                                                offset:
                                                                    Offset(1.0, 1.0),
                                                                blurRadius: 8.0,
                                                                color: Color.fromARGB(
                                                                    255, 0, 0, 0),
                                                              ),
                                                            ],
                                                            text:
                                                                "${item.leagueName.split(" ").sublist(0, 1).join(" ")}\n",
                                                            // text: "item.name",
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                            fontSize: cx.height > 800
                                                                ? 26
                                                                : 22,
                                                            height: 0,
                                                            textOverflow:
                                                                TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: cx.width * 0.65,
                                                          child: NunitoText(
                                                            shadow: <Shadow>[
                                                              Shadow(
                                                                offset:
                                                                    Offset(1.0, 1.0),
                                                                blurRadius: 3.0,
                                                                color: Color.fromARGB(
                                                                    255, 0, 0, 0),
                                                              ),
                                                              Shadow(
                                                                offset:
                                                                    Offset(1.0, 1.0),
                                                                blurRadius: 8.0,
                                                                color: Color.fromARGB(
                                                                    255, 0, 0, 0),
                                                              ),
                                                            ],
                                                            text:
                                                                "${item.leagueName}",
                                                            // text: "item.name",
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                            fontSize: cx.height > 800
                                                                ? 26
                                                                : 22,
                                                            height: 0,
                                                            textOverflow:
                                                                TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                                Positioned(
                                                    right:10,
                                                    bottom: cx.height / 13,
                                                    child: Container(
                                                      height: cx.height / 11.17,
                                                      width: cx.width / 5,
                                                      decoration: BoxDecoration(
                                                        // color: Color(
                                                        //     0xFFFFE68A),
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                            'assets/images/priceTag2.png',
                                                          ),
                                                          scale: 0.6,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                cx.height / 66.7),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            child: SenticText(
                                                              // text: item.price.toStringAsFixed(0).toString(),

                                                              text: "\$" +
                                                                  item.price
                                                                      .toInt()
                                                                      .toString(),
                                                              fontWeight:
                                                                  FontWeight.w700,
                                                              textOverflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              color:
                                                                  Color(0xFF444444),
                                                              fontSize: cx.responsive(
                                                                  22,18, 16),
                                                            ),
                                                          ),
                                                          SenticText(
                                                            text: '/Team',
                                                            fontSize: cx.height > 800
                                                                ? 12
                                                                : 10,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(0xFF444444),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
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
                          ),
                        mycontroller.reLoadingDataProcessing3.value == true
                            ? Column(
                          children: [
                            Gap(cx.height / 30),
                            CircularProgressIndicator(),
                          ],
                        )
                            : Container()                      ],
                    )
                ),
              ],
            ),
          ])),
    );
  }

  Future<void> getCurrentLocation() async {
    Position position = await _getGeoLocationPosition();
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    GetAddressFromLatLong(position);

    cx.lat.value = position.latitude.toString();
    cx.lng.value = position.longitude.toString();
    cx.write(Keys.lat,cx.lat.value);
    cx.write(Keys.lng,cx.lng.value);
    print(cx.lat.value);
    print(cx.lng.value);

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
