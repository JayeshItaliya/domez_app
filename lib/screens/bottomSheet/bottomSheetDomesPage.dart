import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:avatar_stack/avatar_stack.dart';

import 'package:domez/commonModule/Strings.dart';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../commonModule/AppColor.dart';
import 'package:flutter/material.dart';
import '../../commonModule/Constant.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../controller/commonController.dart';
import '../../controller/domesDetailsController.dart';
import '../../model/domesDetailsModel.dart';
import '../homePage/ratings.dart';
import '../../commonModule/utils.dart';

class BottomSheetDomesPage extends StatefulWidget {
  const BottomSheetDomesPage({Key? key}) : super(key: key);

  @override
  State<BottomSheetDomesPage> createState() => _BottomSheetDomesPageState();
}

class _BottomSheetDomesPageState extends State<BottomSheetDomesPage> {
  bool expansion1 = false;
  bool expansion2 = false;
  bool expansion3 = false;
  CommonController cx = Get.put(CommonController());
  DomesDetailsController mycontroller = Get.put(DomesDetailsController());
  late Marker marker;
  bool userMood = true;
  late StreamSubscription<Position> positionStream;
  Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _kGooglePlex;
  // String formattedString='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // marker = Marker(
    //     markerId: MarkerId(mycontroller.myList[0].lat + mycontroller.myList[0].lng),
    //     infoWindow: InfoWindow(title: "Google Plex"),
    //     icon: BitmapDescriptor.defaultMarker,
    //     position: LatLng(double.parse(mycontroller.myList[0].lat), double.parse(mycontroller.myList[0].lng)));
    //
    // _kGooglePlex = CameraPosition(
    //   target: LatLng(double.parse(mycontroller.myList[0].lat), double.parse(mycontroller.myList[0].lng)),
    //   zoom: 14.4746,
    // );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DomesDetailsModel item = mycontroller.myList[0];

    return Column(
      children: [
        Container(
          height: size.height / 2.7,
        ),
        Container(
          // height: size.height*2.2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(cx.height / 13.34),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: cx.width / 30),
            child: Obx(
              () => mycontroller.isoffline.value
                  ? noInternetLottie()
                  : mycontroller.isDataProcessing.value ||
                          mycontroller.myList.length <= 0
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColor.darkGreen,
                          ),
                        )
                      : ListView(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          padding:
                              EdgeInsets.fromLTRB(0, cx.height * 0.04, 0, 0),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/images/location.png",
                                    scale: cx.responsive(2.5, 1.5, 2),
                                  ),
                                  Container(
                                    width: cx.width * 0.8,
                                    child: NunitoText(
                                      textAlign: TextAlign.start,
                                      text: " ${item.city}, ${item.state}",
                                      fontWeight: FontWeight.w600,
                                      fontSize: cx.height > 800 ? 18 : 15,
                                      color: Color(0xFF6F6B6B),
                                      textOverflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: SenticText(
                                text: item.name,
                                fontSize: cx.height > 800 ? 28 : 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              width: cx.width-cx.width/15,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 0,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 4, 0, 4),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Color(0xFFF5F7F9),
                                            radius: cx.responsive(25, 20, 17),
                                            child: Icon(
                                              Icons.add_circle_outline,
                                              color: Color(0xFF629C86),
                                              size: cx.responsive(30, 24, 21),
                                            ),
                                          ),
                                          Gap(8),
                                          NunitoText(
                                            textAlign: TextAlign.start,
                                            text: item.totalFields == 1
                                                ? item.totalFields.toString() +
                                                    " Field"
                                                : item.totalFields.toString() +
                                                    " Fields",
                                            fontWeight: FontWeight.w500,
                                            fontSize: cx.height > 800 ? 17 : 14,
                                            color: Color(0xFFA8A8A8),
                                            textOverflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 0,
                                      child: Gap(cx.width / 20)),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 4, 0, 4),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Color(0xFFF5F7F9),
                                            radius: cx.responsive(25, 20, 17),
                                            child: Icon(
                                              Icons.access_time,
                                              color: Color(0xFF629C86),
                                              size: cx.responsive(30, 24, 21),
                                            ),
                                          ),
                                          Gap(8),
                                          Container(
                                            // width: cx.width * 0.5,
                                            child: NunitoText(
                                              textAlign: TextAlign.start,
                                              text:
                                                  "${item.startTime} To ${item.endTime}",
                                              fontWeight: FontWeight.w500,
                                              fontSize: cx.height > 800 ? 17 : 14,
                                              color: Color(0xFF9F9F9F),
                                              textOverflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gap(10),
                            InkWell(
                              onTap: () {
                                Get.to(Ratings());
                              },
                              child: Container(
                                height: cx.height / 10,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5F7F9),
                                  borderRadius:
                                      BorderRadius.circular(cx.height / 9.53),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: cx.responsive(16, 12, 10),
                                    right: cx.responsive(16, 12, 10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right:
                                                    cx.responsive(16, 12, 10)),
                                            child: Icon(
                                              Icons.star,
                                              color: Color(0xFFFFC439),
                                              size: cx.height / 19.057,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              NunitoText(
                                                textAlign: TextAlign.start,
                                                text: double.parse(item
                                                        .rattingData.avgRating)
                                                    .toStringAsFixed(2),
                                                fontWeight: FontWeight.w700,
                                                fontSize:
                                                    cx.height > 800 ? 21 : 19,
                                                color: Color(0xFF6F6B6B),
                                              ),
                                              NunitoText(
                                                textAlign: TextAlign.start,
                                                text: item.rattingData.images
                                                            .length !=
                                                        0
                                                    ? item.rattingData
                                                            .totalReview
                                                            .toString() +
                                                        " Reviews"
                                                    : "0 Review",
                                                fontWeight: FontWeight.w600,
                                                fontSize:
                                                    cx.height > 800 ? 17 : 15,
                                                color: Color(0xFF9F9F9F),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      item.rattingData.images.length == 0
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: cx.width / 4.76,
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: AvatarStack(
                                                    height: cx.height / 19.057,
                                                    borderColor: Colors.white,
                                                    borderWidth: 0.7,
                                                    avatars: [
                                                      for (var n = 0;
                                                          n < 0;
                                                          n++)
                                                        AssetImage(
                                                          "assets/images/img_2.png",
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: item
                                                                  .rattingData
                                                                  .images
                                                                  .length <=
                                                              1
                                                          ? cx.width / 9
                                                          : item
                                                                      .rattingData
                                                                      .images
                                                                      .length <=
                                                                  3
                                                              ? cx.width / 6
                                                              : cx.width / 4.5,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: AvatarStack(
                                                          height:
                                                              cx.width / 10.5,
                                                          borderColor:
                                                              Colors.white,
                                                          width: cx.width / 2,
                                                          borderWidth: 0.7,
                                                          avatars: item
                                                              .rattingData
                                                              .images
                                                              .map(
                                                                (e) =>
                                                                    NetworkImage(
                                                                        e),
                                                              )
                                                              .toList()),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Gap(cx.height / 37.06),

                            handleDescription("Dome Description",item.description),
                            Gap(cx.height / 37.06),
                            Gap(10),
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.5, color: Color(0xFFD8EAF1)),
                                  borderRadius: BorderRadius.circular(7)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SenticText(
                                    height: 1.2,
                                    text: 'Location',
                                    fontSize: cx.height > 800 ? 20 : 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  Gap(cx.height / 44.47),
                                  InkWell(
                                    onTap: () {
                                      openMap(item.lat, item.lng);
                                    },
                                    child: Image.asset(
                                      Image1.img,
                                      scale: cx.height > 800 ? 1.65 : 1.9,
                                    ),
                                  ),
                                  // Container(
                                  //   height:cx.height*0.25,
                                  //   width: cx.width*0.8,
                                  //   child: InkWell(
                                  //     onTap: () {
                                  //       openMap(item.lat, item.lng);
                                  //     },
                                  //     child: GoogleMap(
                                  //       trafficEnabled: true,
                                  //       indoorViewEnabled: true,
                                  //       mapType: userMood ? MapType.normal : MapType.satellite,
                                  //       markers: {marker},
                                  //       myLocationEnabled: true,
                                  //       initialCameraPosition: _kGooglePlex,
                                  //       onMapCreated: (GoogleMapController controller) {
                                  //         _controller.complete(controller);
                                  //       },
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            Gap(cx.height / 44.47),
                            SenticText(
                              height: 1.2,
                              text: 'Amenities',
                              fontSize: cx.height > 800 ? 20 : 18,
                              fontWeight: FontWeight.w500,
                            ),
                            Gap(8),
                            handleDescription("Amenities Description",item.benefitsDescription),
                            Gap(cx.height / 33.5),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              direction: Axis.horizontal,
                              children: List.generate(
                                item.benefits.length,
                                (index) {
                                  return InkWell(
                                    child: Container(
                                      width: cx.width / 2.4,
                                      padding: EdgeInsets.fromLTRB(
                                        cx.height / 66.7,
                                        cx.height / 51.31,
                                        8,
                                        cx.height / 51.31,
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xFFD4D4D4)),
                                          borderRadius: BorderRadius.circular(
                                              cx.height / 41.7)),
                                      child: Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            backgroundImage: AssetImage(
                                              item.benefits[index].benefit ==
                                                      "Changing Room"
                                                  ? "assets/images/changingroom.png"
                                                  : item.benefits[index]
                                                              .benefit ==
                                                          "Free Wifi"
                                                      ? "assets/images/freeWifi.png"
                                                      : item.benefits[index]
                                                                  .benefit ==
                                                              "Pool"
                                                          ? "assets/images/pool.png"
                                                          : item.benefits[index]
                                                                      .benefit ==
                                                                  "Parking"
                                                              ? "assets/images/parking.png"
                                                              : item.benefits[index]
                                                                          .benefit ==
                                                                      "Others"
                                                                  ? "assets/images/others.png"
                                                                  : "assets/images/changingroom.png",
                                            ),
                                          ),
                                          SizedBox(width: cx.width / 50),
                                          Container(
                                            width: (cx.width / 2.4) * 0.5,
                                            child: AutoSizeText(
                                              item.benefits[index].benefit,
                                              // softWrap: false,
                                              maxLines: 2,

                                              style: TextStyle(
                                                fontSize:
                                                    cx.height > 800 ? 18 : 15,
                                                overflow: TextOverflow.clip,
                                                // softWrap: false,
                                                // maxLines: 2,
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
                            Gap(cx.height / 9.53)
                          ],
                        ),
            ),
          ),
        ),
      ],
    );
  }

  openMap(String lat, String Lng) async {
    String googleURL =
        "https://www.google.com/maps/search/?api=1&query=$lat,$Lng";

    await canLaunchUrlString(googleURL)
        ? await launchUrlString(googleURL)
        : throw 'Could not launch $googleURL';
  }

  Widget handleDescription(String title,String desc) {

    return RichText(
      maxLines: 10,
      overflow: TextOverflow.clip,
      text: TextSpan(
        text: '',

        style: GoogleFonts.nunito(
          color: Color(0xFF444444),
          fontWeight: FontWeight.w500,
          fontSize: cx.height > 800 ? 18 : 16,
        ),
        children: <TextSpan>[
          desc.length > 150?TextSpan(
            text: desc.substring(0,150),
          ):TextSpan(
            text: desc.toString(),
          ),
          desc.length > 150
              ? TextSpan(
                  text: '...Show More',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    color: AppColor.darkGreen,
                    fontSize: cx.height > 800 ? 18 : 16,
                    // decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return moreDialog(title,desc);
                          });
                    },
                )
              : TextSpan(text: ''),
        ],
      ),
    );
  }
  Widget moreDialog(String title,String desc) =>
      StatefulBuilder(builder: (BuildContext context,
          StateSetter setState /*You can rename this!*/) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          insetPadding: EdgeInsets.zero,

          child: Container(
            width: cx.width / 1.15,
            height: cx.height / 1.1,
            child: Column(

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                SenticText(
                    height: 1.2,
                    text: title,
                    fontSize: cx.height > 800 ? 23 : 20,
                    fontWeight: FontWeight.w600,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    textOverflow: TextOverflow.ellipsis,
                    color: Colors.black),
                Gap(cx.height / 50),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12.0,8,10,8),
                        child: NunitoText(
                          color: Color(0xFF444444),
                          fontWeight: FontWeight.w500,
                          fontSize: cx.height > 800 ? 18 : 16,
                          textAlign: TextAlign.start,
                          text: desc,
                          maxLines: 100000,
                        ),
                      ),
                      Gap(cx.height / 25),

                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
