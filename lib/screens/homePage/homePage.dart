import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:domez/model/categoryModel.dart';
import 'package:flutter/services.dart';
import '../../../commonModule/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/Strings.dart';
import '../../commonModule/widget/search/searchlocationPicker.dart';
import '../../controller/categoryController.dart';
import '../../controller/commonController.dart';
import '../../controller/domesListController.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../authPage/editProfile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location = 'Null, Press Button';
  String Address = 'search';
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  String string = '';
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  late DetailsResult detailsResult;
  CommonController cx = Get.put(
    CommonController(),
  );
  final mycontroller = Get.put(CategoryController());
  final domeListController = Get.put(DomesListController());
  ScrollController _scrollController = ScrollController();

  int vollyIndex = 0;
  int initialCategoryId = 6;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();


    googlePlace = GooglePlace(Constant.mapkey);
    if (cx.read("image") == null) cx.write('image', Constant.dummyProfileUrl);
    if (cx.image.value == '') cx.image.value = Constant.dummyProfileUrl;
    // print(cx.profilePicture);
    // print(cx.isLoggedIn.value);

    domeListController.getTask1(domeListController.sportid.value);
    domeListController.getTask2(domeListController.sportid.value);
    domeListController.getTask3(domeListController.sportid.value);

    print("initState");
    print(cx.read("username"));
    print(cx.read("id"));
    print(cx.read("useremail"));
    print(cx.read("image"));
    print(cx.read("islogin"));
    print(cx.read("phone"));





    //Checking internet
    _networkConnectivity.initialise();
    _networkConnectivity.myStream.listen((source) {
      _source = source;
      print('source $_source');
      // 1.
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          string =
          _source.values.toList()[0] ? 'Mobile: Online' : 'Mobile: Offline';
          break;
        case ConnectivityResult.wifi:
          string =
          _source.values.toList()[0] ? 'WiFi: Online' : 'WiFi: Offline';
          break;
        case ConnectivityResult.none:
        default:
          string = 'Offline';
      }
      // 2.
      // 3.
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       string,
      //       style: TextStyle(fontSize: 30),
      //     ),
      //   ),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        print("initial category"+initialCategoryId.toString());

        if (initialCategoryId!=6) {
          setState(() {
            vollyIndex = 0;
            _scrollController.jumpTo(0);
            initialCategoryId=6;
          });

          domeListController
              .sportsUpdate(initialCategoryId.toString())
              .then((value) {});
          print("different sport Id");
          return false;
          // Get.off(WonderEvents());

        }
        // else if(!cx.isReset.value){
        //   cx.isReset.value=true;
        //   print("Reset HomePaqe");
        //   DraggableScrollableActuator.reset(context);
        //   return false;
        // }
        else{
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldkey,
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: Obx(
          () => Container(
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
                           domeListController.isDataProcessing1.value||
                          domeListController.isDataProcessing2.value||
                          domeListController.isDataProcessing3.value
                          ? AppColor.bg
                          : domeListController.isoffline.value
                              ? AppColor.bg
                              : Colors.white,
                    ])
            ),
            child: Obx(()=> mycontroller.isoffline.value||string=="Mobile: Offline"||string=="Wifi: Offline"
                  ? noInternetLottie()
                  : ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: [
                        Gap(cx.height / 20),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: cx.height / 33.5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Gap(cx.height / 66.7),
                                      InterText(
                                        text: "Find A Dome",
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF70A792),
                                        fontSize: cx.responsive(30,24,20),
                                        height: 0.15,
                                      ),
                                      Gap(cx.height / 95.29),
                                      SenticText(
                                        text: "Near You",
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: cx.responsive(42,36, 32),
                                      ),
                                    ],
                                  ),
                                ),
                                Stack(
                                  fit: StackFit.passthrough,
                                  alignment: Alignment(50, 50),
                                  children: [
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
                                          radius: cx.responsive(25,22.5, 20),
                                          backgroundColor: Colors.white,
                                          child: CachedNetworkImage(
                                            imageUrl: cx.image.value,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: cx.responsive(25,20, 17),
                                              backgroundImage: NetworkImage(
                                                  cx.image.value,
                                              ),
                                            ),
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: cx.responsive(25,20, 17),
                                              backgroundImage: AssetImage(
                                                Image1.anime,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: cx.responsive(25,20, 17),
                                              backgroundImage: AssetImage(
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
                                                BorderRadius.circular(50),
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
                            Gap(cx.height / 33.5),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  cx.height / 37.06,
                                  cx.height / 83.375,
                                  cx.height / 37.06,
                                  cx.height / 83.375),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(
                                        LocationPicker(homePage: true),
                                        transition: Transition.rightToLeft,
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              cx.height / 6.67),
                                          color: Colors.white,
                                          border: Border.all(
                                            width: 3,
                                            color: Color(0xFFECFFF8),
                                          )),
                                      padding: const EdgeInsets.fromLTRB(
                                          15.0, 4, 15, 4),
                                      height: cx.responsive(90,70, 55),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InterText(
                                            text: "Search Dome",
                                            fontSize: cx.height > 800 ? 17 : 15,
                                            color: Color(0xFF81B5A1),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              Position position =
                                                  await _getGeoLocationPosition();
                                              location =
                                                  'Lat1: ${position.latitude} , Long: ${position.longitude}';
                                              GetAddressFromLatLong(position);

                                              debugPrint(location);
                                              debugPrint(Address);

                                              cx.lat.value =
                                                  position.latitude.toString();
                                              cx.lng.value =
                                                  position.longitude.toString();

                                              cx.write(Keys.lat, cx.lat.value);
                                              cx.write(Keys.lng, cx.lng.value);

                                              cx.curIndex.value = 3;
                                              debugPrint("hello" +
                                                  cx.curIndex.value.toString());
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: AppColor.darkGreen,
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(
                                                          cx.height / 6.67)),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.location_searching,
                                                    color: Colors.white,
                                                    size: cx.height > 800
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
                            Gap(cx.responsive(cx.height/60, cx.height/50, cx.height/40)),
                          ],
                        ),
                        Container(
                          height: cx.height / 15,
                          child: Obx(
                            () => ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: mycontroller.myList.length,
                              itemBuilder: (context, index) {
                                CategoryModel item = mycontroller.myList[index];
                                // if (index == 0) {
                                //   domeListController.sportid.value =
                                //       item.id.toString();
                                //   domeListController.sportsUpdate(
                                //       domeListController.sportid.value);
                                //
                                //   print(domeListController.sportid.value);
                                // }
                                return Padding(
                                  padding: EdgeInsets.only(
                                    left:
                                    index == 0 ? cx.height / 44.47 : 0,
                                    right: index == mycontroller.myList.length-1
                                        ? cx.height / 44.47
                                        : 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: InkWell(
                                          onTap: () {
                                            // domeListController.getTask1();
                                            // domeListController.getTask2();
                                            // domeListController.getTask3();
                                            // debugPrint("Hello");
                                            domeListController.sportid.value =
                                                item.id.toString();
                                            domeListController
                                                .sportsUpdate(item.id.toString());

                                            print(domeListController.sportid.value);

                                            setState(() {
                                              vollyIndex = index;
                                              initialCategoryId = item.id;
                                            });
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
                                                        color: index == vollyIndex
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
                                                      color:index == vollyIndex
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
                                            color: index == vollyIndex
                                                ? AppColor.darkGreen
                                                : Colors.white.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(100),
                                            border: Border.all(color: Color(0xFFD4D4D4))),
                                      ),
                                      SizedBox(
                                        width: cx.width / 50,
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        // BottomScroll(),
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
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      permission = await Geolocator.requestPermission();
      // await Geolocator.openLocationSettings();
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
      await Geolocator.openLocationSettings();

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
