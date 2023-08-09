import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import '../../../commonModule/AppColor.dart';
import 'package:domez/screens/bottomSheet/bottomSheetSearch.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/Strings.dart';
import 'package:gap/gap.dart';
import '../../commonModule/utils.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../commonModule/widget/search/searchlocationPicker.dart';
import '../../controller/commonController.dart';
import '../../controller/domesDetailsController.dart';
import '../../controller/domesListController.dart';
import '../authPage/editProfile.dart';


class FilterDataList extends StatefulWidget {
  const FilterDataList({Key? key}) : super(key: key);

  @override
  State<FilterDataList> createState() => _BottomScrollState();
}

class _BottomScrollState extends State<FilterDataList> {
  String location = 'Null, Press Button';
  String Address = 'search';

  late GooglePlace googlePlace;
  final ScrollController _scroller = ScrollController();
  bool fav = true;
  var popularIndex = [false, false, false, false];
  CommonController cx = Get.put(CommonController());
  DomesListController mycontroller = Get.put(DomesListController());
  TextEditingController searchController = TextEditingController();
  final dx = Get.put(DomesDetailsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("Cur location is" + cx.searchDome.value.toString());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: AppColor.bg,
          //color set to transparent or set your own color
          statusBarIconBrightness: Constant.deviceBrightness,
          //set brightness for icons, like dark background light icons
        )
    );
    return WillPopScope(
      onWillPop: () async {
        if (cx.curIndex.value != 0) {
          cx.curIndex.value = 0;
        }
        return false;
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColor.bg,
          body: SingleChildScrollView(
            controller: _scroller,
            child: Container(
              height: cx.height,
              decoration: BoxDecoration(
                  color: AppColor.bg,
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                        0.6,
                        0.65
                      ],
                      colors: [
                        AppColor.bg,
                        cx.isoffline.value ? AppColor.bg : Colors.white,
                      ])),
              child: cx.isoffline.value
                  ? noInternetLottie()
                  : cx.isDataProcessing.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColor.darkGreen,
                          ),
                        )
                      : ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            // IgnorePointer(child: Gap(WonderEvents.topHeight)),
                            Container(
                              height: cx.height / 3.3,
                              decoration: BoxDecoration(
                                color: AppColor.bg,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.elliptical(
                                        cx.height / 16.7, cx.height / 23.82),
                                    bottomRight: Radius.elliptical(
                                        cx.height / 16.7, cx.height / 23.82)),
                              ),
                              child: ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                children: [
                                  Gap(cx.height / 22.23),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: cx.height / 33.5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Gap(cx.height / 66.7),
                                                InterText(
                                                  text: "Here Are Your Search",
                                                  color: Color(0xFF70A792),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize:
                                                      cx.responsive(30,24,20),
                                                ),
                                                Gap(7),
                                                SenticText(
                                                  text: "Results",
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize:
                                                      cx.responsive(42,34, 28),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Stack(
                                            fit: StackFit.passthrough,
                                            alignment: Alignment(50, 50),
                                            children: [
                                              Gap(8),
                                              InkWell(
                                                onTap: () {
                                                  if (cx.read("islogin")) {
                                                    Get.to(EditProfile());
                                                  } else {
                                                    cx.curIndex.value = 4;
                                                  }
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: cx.height / 41.7),
                                                  child: CircleAvatar(
                                                    radius:
                                                        cx.responsive(25,22.5, 20),
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          cx.read("image"),
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          CircleAvatar(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        radius: cx.responsive(
                                                            25, 20, 17),
                                                        backgroundImage:
                                                            NetworkImage(
                                                          cx.read("image"),
                                                        ),
                                                      ),
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (context, url) =>
                                                              CircleAvatar(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        radius: cx.responsive(
                                                            25,20, 17),
                                                        backgroundImage:
                                                            AssetImage(
                                                          Image1.anime,
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          CircleAvatar(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        radius: cx.responsive(
                                                            25,20, 17),
                                                        backgroundImage:
                                                            AssetImage(
                                                          Image1.anime,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: cx.responsive(3.5,2, 0.1),
                                                right: cx.height / 33,
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: cx.responsive(13,6, 4.5),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFFF5C5C),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    height:cx.responsive(20,17, 13),
                                                    width: double.infinity,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Gap(20),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            cx.responsive(22,18, 16),
                                            8,
                                            cx.responsive(26,21, 16),
                                            8),
                                        child: Obx(
                                          () => Column(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  var place =
                                                      await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          LocationPicker(
                                                              homePage: true),
                                                    ),
                                                  );
                                                  setState(() {
                                                    cx.searchDome.value =
                                                        place['location'];
                                                    cx.lat.value =
                                                        place['lat'].toString();
                                                    cx.lng.value =
                                                        place['lng'].toString();

                                                    cx.write(
                                                        Keys.lat, cx.lat.value);
                                                    cx.write(
                                                        Keys.lng, cx.lng.value);
                                                    // lat = place['lat'];
                                                    // lng = place['lng'];
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              cx.height / 6.67),
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        width: 3,
                                                        color:
                                                            Color(0xFFECFFF8),
                                                      )),
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          15.0, 4, 15, 4),
                                                  height: cx.responsive(90,70, 55),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: cx.width * 0.65,
                                                        child: InterText(
                                                          text: cx.searchDome
                                                                  .value.isEmpty
                                                              ? "Search Here"
                                                              : cx.searchDome
                                                                  .value
                                                                  .toString(),
                                                          fontSize:
                                                              cx.height > 800
                                                                  ? 17
                                                                  : 15,
                                                          color:
                                                              Color(0xFF81B5A1),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          Position position =
                                                              await _getGeoLocationPosition();
                                                          location =
                                                              'Lat: ${position.latitude} , Long: ${position.longitude}';
                                                          GetAddressFromLatLong(
                                                              position);
                                                          cx.lat.value =
                                                              position.latitude
                                                                  .toString();
                                                          cx.lng.value =
                                                              position.longitude
                                                                  .toString();

                                                          cx.write(Keys.lat,
                                                              cx.lat.value);
                                                          cx.write(Keys.lng,
                                                              cx.lng.value);

                                                          debugPrint(location);
                                                          debugPrint(Address);
                                                        },
                                                        child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColor
                                                                  .darkGreen,
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(
                                                                      cx.height /
                                                                          6.67)),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Icon(
                                                                Icons
                                                                    .location_searching,
                                                                color: Colors
                                                                    .white,
                                                                size:
                                                                    cx.height >
                                                                            800
                                                                        ? 26
                                                                        : 20,
                                                              ),
                                                            )),
                                                      ),
                                                    ],
                                                  ),
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
                            ),
                            Gap(8),
                            BottomSheetSearch(),
                          ],
                        ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
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
