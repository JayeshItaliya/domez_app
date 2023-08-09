import 'package:cached_network_image/cached_network_image.dart';
import '../../../commonModule/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import '../../../controller/SearchController.dart';
import '../../../controller/commonController.dart';
import '../../../controller/domesDetailsController.dart';
import '../../../controller/leagueDetailsController.dart';
import '../../../model/favouriteModel.dart';
import '../../../screens/bookSteps/DomePage.dart';
import '../../../screens/league/leaguePageDetails.dart';
import '../../Constant.dart';
import '../../Debouncer.dart';
import '../../Strings.dart';
import 'package:gap/gap.dart';
import '../../utils.dart';
import '../common/textNunito.dart';


class LocationPicker extends StatefulWidget {
  final bool homePage;

  LocationPicker({
    Key? key,
    required this.homePage,
  }) : super(key: key);

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {

  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  late DetailsResult detailsResult;
  TextEditingController searchController = TextEditingController();

  CommonController cx = Get.put(CommonController());
  SearchListController mycontroller = Get.put(SearchListController());

  @override
  void initState() {
    mycontroller.myList.clear();
    mycontroller.type.value = widget.homePage ? 1 : 2;
    googlePlace = GooglePlace(Constant.mapkey);
    super.initState();
  }
  final _debouncer = Debouncer(delay: 500);
  String _searchText = '';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(cx.height * 0.11),
        // here the desired height

        child: AppBar(
          leading: Padding(
            padding: EdgeInsets.fromLTRB(
                8, cx.responsive(26, 18, 12), cx.responsive(0, 0, 8), 0),
            child: InkWell(
              onTap: () {
                if (widget.homePage == true) {
                  cx.curIndex.value = 0;
                } else if (widget.homePage == false) {
                  cx.curIndex.value = 2;
                }
                FocusScope.of(context).requestFocus(new FocusNode());
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                Get.back();
              },
              borderRadius: BorderRadius.circular(cx.height / 13.34),
              child: CircleAvatar(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: 20,
                ),
                backgroundColor: Colors.white,
              ),
            ),
          ),
          backgroundColor: AppColor.bg,
          elevation: 0,
        ),
      ),
      backgroundColor: AppColor.bg,
      body: Container(
        // height: cx.height,
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            Container(
              height: cx.height * 0.12,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0, right: 14),
                    child: TextFormField(
                      onFieldSubmitted: (value) {
                        if (searchController.text.isNotEmpty) {
                          autoCompleteSearch(searchController.text);
                        } else {
                          if (predictions.length > 0 && mounted) {
                            setState(() {
                              predictions = [];
                            });
                          }
                        }

                        if (searchController.text.isEmpty) {
                          mycontroller.myList.clear();
                        } else {
                          mycontroller.searchName.value = searchController.text;
                          mycontroller.getTask(
                              mycontroller.type.value.toString(),
                              mycontroller.searchName.value);
                        }
                      },
                      controller: searchController,
                      cursorColor: Color(0xFF81B5A1),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      autofocus: true,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: () {
                            if (searchController.text.isNotEmpty) {
                              autoCompleteSearch(searchController.text);
                            } else {
                              if (predictions.length > 0 && mounted) {
                                setState(() {
                                  predictions = [];
                                });
                              }
                            }

                            if (searchController.text.isEmpty) {
                              mycontroller.myList.clear();
                            } else {
                              mycontroller.searchName.value =
                                  searchController.text;
                              mycontroller.getTask(
                                  mycontroller.type.value.toString(),
                                  mycontroller.searchName.value);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.search,
                              color: AppColor.darkGreen,
                              size: cx.responsive(35, 30, 27),
                            ),
                          ),
                        ),
                        fillColor: Colors.white,
                        hintText: "Search Here",
                        hintStyle: TextStyle(
                          fontSize: cx.height > 800 ? 18 : 15,
                          color: Color(0xFF81B5A1),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(cx.height / 6.67),
                          borderSide: BorderSide(
                            width: 3,
                            color: Color(0xFFECFFF8),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(cx.height / 6.67),
                          borderSide: BorderSide(
                            width: 3,
                            color: Color(0xFFECFFF8),
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(cx.height / 6.67),
                          borderSide: BorderSide(
                            width: 3,
                            color: Color(0xFFECFFF8),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(cx.height / 6.67),
                          borderSide: BorderSide(
                            width: 3,
                            color: Color(0xFFECFFF8),
                          ),
                        ),
                        filled: true,
                        contentPadding: EdgeInsets.all(20),
                      ),
                      onChanged: onSearchTextChanged
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Container(
              height: cx.height * 0.75,
              child: Obx(
                () => mycontroller.isDataProcessing.value
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColor.darkGreen,
                          ),
                        ),
                      )
                    : predictions.length == 0 &&
                            mycontroller.myList.length == 0 &&
                            searchController.text.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: cx.height * 0.45,
                                // height: 200,
                                color: AppColor.bg,
                                alignment: Alignment.center,
                                child: NunitoText(
                                    text: 'Oops! No Result Found',
                                    textAlign: TextAlign.center,
                                    fontSize: cx.responsive(35, 27, 23),
                                    color: Colors.grey.shade600),
                              ),
                            ],
                          )
                        : SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              // shrinkWrap: true,
                              // physics: ClampingScrollPhysics(),
                              children: <Widget>[
                                Obx(
                                  () => mycontroller.isoffline.value
                                      ? noInternetLottie()
                                      : mycontroller.isDataProcessing.value
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                color: AppColor.darkGreen,
                                              ),
                                            )
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: predictions.length,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {

                                                return index == 2 ||
                                                        index == 3 ||
                                                        index == 4
                                                    ? Container()
                                                    : InkWell(
                                                        onTap: () {
                                                          getDetils(
                                                              predictions[index]
                                                                  .placeId
                                                                  .toString());

                                                          setState(() {
                                                            cx.searchDome
                                                                    .value =
                                                                predictions[
                                                                        index]
                                                                    .description
                                                                    .toString();
                                                            debugPrint(cx
                                                                .searchDome
                                                                .value);
                                                          });
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left:
                                                                      cx.width *
                                                                          0.047,
                                                                  bottom: 8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width:
                                                                    cx.width *
                                                                        0.10,
                                                                child:
                                                                    CircleAvatar(
                                                                  backgroundColor:
                                                                      AppColor
                                                                          .darkGreen,
                                                                  child: Icon(
                                                                    Icons
                                                                        .pin_drop,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                    left: cx.width *
                                                                        0.045),
                                                                child:
                                                                    Container(
                                                                  width:
                                                                      cx.width *
                                                                          0.75,
                                                                  child: Text(
                                                                    predictions[
                                                                            index]
                                                                        .description
                                                                        .toString(),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .clip,
                                                                    maxLines: 3,
                                                                    style: TextStyle(
                                                                        fontSize: cx.responsive(
                                                                            22,
                                                                            17,
                                                                            15)),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                              },
                                            ),
                                ),
                                Obx(
                                  () => mycontroller.isoffline.value
                                      ? Container()
                                      : mycontroller.isDataProcessing.value
                                          ? Container()
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  mycontroller.myList.length,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                FavouriteModel item =
                                                    mycontroller.myList[index];
                                                return InkWell(
                                                  onTap: () {
                                                    if (widget.homePage) {

                                                      cx.curIndex.value = 0;
                                                      Get.to(
                                                        DomePage(
                                                          isFav: item.isFav,
                                                          domeId: item.id.toString(),
                                                        ),);
                                                    } else {
                                                      Get.to(
                                                          LeaguePageDetails(
                                                            isFav: item.isFav,
                                                            leagueId: item.id.toString(),));
                                                    }

                                                    // getDetils(predictions[index].placeId.toString());
                                                    // setState((){
                                                    //   cx.searchDome.value=predictions[index].description.toString();
                                                    //   debugPrint(cx.searchDome.value);
                                                    // });
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: cx.width * 0.047,
                                                        bottom: 8),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width:
                                                              cx.width * 0.10,
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                item.image,
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                CircleAvatar(
                                                              backgroundColor:
                                                                  AppColor
                                                                      .darkGreen,
                                                              radius:
                                                                  cx.responsive(
                                                                      40,
                                                                      28,
                                                                      20),
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      item.image),
                                                            ),
                                                            fit: BoxFit.cover,
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    CircleAvatar(
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              radius:
                                                                  cx.responsive(
                                                                      40,
                                                                      28,
                                                                      20),
                                                              backgroundImage:
                                                                  AssetImage(
                                                                Image1.anime,
                                                              ),
                                                            ),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                CircleAvatar(
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              radius:
                                                                  cx.responsive(
                                                                      40,
                                                                      28,
                                                                      20),
                                                              backgroundImage:
                                                                  AssetImage(
                                                                Image1.anime,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width:
                                                              cx.width * 0.75,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: cx.width *
                                                                        0.045),
                                                            child: Text(
                                                              widget.homePage
                                                                  ? item
                                                                      .domeName
                                                                  : item
                                                                      .leagueName,
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                              maxLines: 3,
                                                              style: TextStyle(
                                                                  fontSize: cx
                                                                      .responsive(
                                                                          22,
                                                                          17,
                                                                          15)),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                ),
                                MediaQuery.of(context).viewInsets.bottom == 0.0
                                    ? Gap(cx.height * 0.4)
                                    : Gap(cx.height * 0.15)
                              ],
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getDetils(String placeId) async {
    var result = await this.googlePlace.details.get(placeId);
    if (result != null && result.result != null && mounted) {
      setState(() {
        detailsResult = result.result!;
        final data = {
          "location": detailsResult.formattedAddress,
          "lat": detailsResult.geometry?.location?.lat.toString(),
          "lng": detailsResult.geometry?.location?.lng.toString()
        };


        cx.curIndex.value = 3;
        cx.lat.value = detailsResult.geometry!.location!.lat.toString();
        cx.lng.value = detailsResult.geometry!.location!.lng.toString();

        cx.write(Keys.lat, cx.lat.value);
        cx.write(Keys.lng, cx.lng.value);
        Navigator.pop(context, data);


      });
    }
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    print(result!.status);
    if (result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }
  void onSearchTextChanged(String searchText) {
    _debouncer(() {
      setState(() {
        _searchText = searchText;
      });
      if (searchController.text.isNotEmpty) {
        autoCompleteSearch(searchText);
      } else {
        if (predictions.length > 0 && mounted) {
          setState(() {
            predictions = [];
          });
        }
      }

      if (searchController.text.isEmpty) {
        mycontroller.myList.clear();
      } else {
        mycontroller.searchName.value = searchController.text;
        mycontroller.getTask(
            mycontroller.type.value.toString(),
            mycontroller.searchName.value);
      }
    });
  }
}
