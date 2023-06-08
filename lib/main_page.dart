import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:domez/screens/authPage/signIn.dart';
import 'package:domez/screens/bottomSheet/bottomSheetLeague.dart';
import 'package:domez/screens/league/leagueHome.dart';
import 'package:domez/screens/menuPage/bookings.dart';
import 'package:domez/screens/menuPage/manageAccounts.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../commonModule/AppColor.dart';
import 'package:domez/screens/searchPage/searchPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'commonModule/Constant.dart';
import 'commonModule/Strings.dart';
import 'controller/commonController.dart';
import 'controller/domesListController.dart';
import 'screens/bottomSheet/bottomSheet.dart';
import 'screens/homePage/homePage.dart';

class WonderEvents extends StatefulWidget {
  final int curIndex;

  WonderEvents({
    Key? key,
    this.curIndex=0,
  }) : super(key: key);

  @override
  State<WonderEvents> createState() => _WonderEventsState();
}

class _WonderEventsState extends State<WonderEvents> {
  CommonController cx = Get.put(CommonController());
  DomesListController myController = Get.put(DomesListController());
  String location = '';
  String Address = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (cx.read("islogin") == null || cx.read("isVerified") == null) {
      print("isLogin");
      cx.write('islogin', false);
      cx.write('isVerified', false);
    }

      if (cx.read("username") == null) cx.write('username', '');
      if (cx.read("useremail") == null) cx.write('useremail', '');
      if (cx.read("phone") == null) cx.write('phone', '');
      if (cx.read("countrycode") == null) cx.write('countrycode', 'CA');
      if (cx.read("image") == null) cx.write('image', Constant.dummyProfileUrl);
      if (cx.read("id") == null) cx.write('id', 0);

    cx.id.value = cx.read("id");
    // print("WRAJ");
    // print(cx.id.value);
    // print(cx.read('id'));

    cx.email.value = cx.read("useremail");
    cx.phone.value = cx.read("phone");
    cx.countrycode.value = cx.read("countrycode");
    cx.image.value = cx.read("image");
    cx.isLogin.value = cx.read("islogin");
    cx.name.value = cx.read("username");
    cx.isVerified.value = cx.read("isVerified");

    if (myController.isoffline.value == false) {
      getCurrentLocation();
    }

    cx.searchDome.value = "";
    print(cx.searchDome.value);
    cx.curIndex.value=widget.curIndex;

    print("image222");
    print(cx.read("image"));
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          //color set to transperent or set your own color
          statusBarIconBrightness: Constant.deviceBrightness,
          //set brightness for icons, like dark background light icons
        )
    );
    return Scaffold(
      // backgroundColor: AppColor.bg,
        body: Container(
          // color: AppColor.bg,
          child: Obx(
            () => Stack(
              clipBehavior: Clip.none,
              children: [
                if (cx.curIndex.value == 0) HomePage(),
                if (cx.curIndex.value == 0) BottomScroll(),

                /// Top content, sits underneath scrolling list

                /// Scrolling Events list, takes up the full view
                if (cx.curIndex.value == 1)
                  cx.read("islogin")
                      ? Bookings(isBackButton: false)
                      : SignIn(isBackButton: false,curIndex: 1),
                if (cx.curIndex.value == 2) LeaguePage(),
                if (cx.curIndex.value == 2) BottomSheetLeague(),
                if (cx.curIndex.value == 3) FilterDataList(),

                if (cx.curIndex.value == 4) ManageAccounts(),

                MediaQuery.of(context).viewInsets.bottom == 0.0
                    ? Positioned(
                        bottom: -28,
                        child: (SvgPicture.asset(
                            "assets/svg/leftBottomNavigation.svg",
                            color: AppColor.darkGreen)),
                      )
                    : Container(),
                MediaQuery.of(context).viewInsets.bottom == 0.0
                    ? Positioned(
                        bottom: -28,
                        right: 0,
                        child: (SvgPicture.asset(
                            "assets/svg/rightBottomNavigation.svg",
                            color: AppColor.darkGreen)),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Obx(
          () => Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            // decoration: BoxDecoration(
            //     color: Color(
            //         0xFFF5F7F9),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Color(
            //             0xFFF5F7F9),
            //         spreadRadius:
            //         1.9, //New
            //       )
            //     ]),
            height: 75,
            child: BottomNavigationBar(

              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColor.darkGreen,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              elevation: 0,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    Svg1.home,
                    color: cx.curIndex.value == 0
                        ? Colors.white
                        : AppColor.bnavigation,
                    height: cx.responsive(38,32,28)
                  ),
                  label: '',
                  // title: Text("Home"),
                ),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      Svg1.booking,
                      color: cx.curIndex.value == 1
                          ? Colors.white
                          : AppColor.bnavigation,
                        height: cx.responsive(38,32,28)

                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      Svg1.leagues,
                      color: cx.curIndex.value == 2
                          ? Colors.white
                          : AppColor.bnavigation,
                        height: cx.responsive(38,32,28)

                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      Svg1.search,
                      color: cx.curIndex.value == 3
                          ? Colors.white
                          : AppColor.bnavigation,
                        height: cx.responsive(38,32,28)

                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      Svg1.profile,
                      color: cx.curIndex.value == 4
                          ? Colors.white
                          : AppColor.bnavigation,
                        height: cx.responsive(40,32,28)

                    ),
                    label: ''),
              ],
              currentIndex: cx.curIndex.value,
              onTap: (index) {
                if (cx.curIndex.value == 3) {
                  cx.searchDome.value = "";
                }
                if(cx.curIndex.value==0){

                }
                setState(() {
                  // debugPrint(index.toString());
                  // cx.curIndex = index;
                  cx.curIndex.value = index;
                });
              },
            ),
          ),
        ));
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
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
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
