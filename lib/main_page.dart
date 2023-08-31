import 'package:domez/controller/categoryController.dart';
import 'package:domez/controller/leaguesListController.dart';
import 'package:domez/screens/authPage/signIn.dart';
import 'package:domez/screens/bottomSheet/bottomSheetLeague.dart';
import 'package:domez/screens/league/leagueHome.dart';
import 'package:domez/screens/menuPage/bookings.dart';
import 'package:domez/screens/menuPage/manageAccounts.dart';
import '../../../commonModule/AppColor.dart';
import 'package:domez/screens/searchPage/searchPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'commonModule/Constant.dart';
import 'commonModule/Strings.dart';
import 'commonModule/utils.dart';
import 'controller/bookListController.dart';
import 'controller/commonController.dart';
import 'controller/domesListController.dart';
import 'screens/bottomSheet/bottomSheet.dart';
import 'screens/homePage/homePage.dart';

class MainPageScreen extends StatefulWidget {
  final int curIndex;

  MainPageScreen({
    Key? key,
    this.curIndex = 0,
  }) : super(key: key);

  @override
  State<MainPageScreen> createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPageScreen> {
  CommonController cx = Get.put(CommonController());
  DomesListController myController = Get.put(DomesListController());
  CategoryController categoryController = Get.put(CategoryController());
  final bookListController = Get.put(BookListController());

  String location = '';
  String Address = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cx.curIndex.value = widget.curIndex;

      if (cx.read("islogin") == null || cx.read("isVerified") == null) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      //color set to transperent or set your own color
      statusBarIconBrightness: Constant.deviceBrightness,
      //set brightness for icons, like dark background light icons
    ));
    return GetBuilder<CommonController>(builder: (controller) {
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
                        : SignIn(isBackButton: false, curIndex: 1),
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
                    icon: SvgPicture.asset(Svg1.home,
                        color: cx.curIndex.value == 0
                            ? Colors.white
                            : AppColor.bnavigation,
                        height: cx.responsive(38, 32, 28)),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset(Svg1.booking,
                          color: cx.curIndex.value == 1
                              ? Colors.white
                              : AppColor.bnavigation,
                          height: cx.responsive(38, 32, 28)),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset(Svg1.leagues,
                          color: cx.curIndex.value == 2
                              ? Colors.white
                              : AppColor.bnavigation,
                          height: cx.responsive(38, 32, 28)),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset(Svg1.search,
                          color: cx.curIndex.value == 3
                              ? Colors.white
                              : AppColor.bnavigation,
                          height: cx.responsive(38, 32, 28)),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset(Svg1.profile,
                          color: cx.curIndex.value == 4
                              ? Colors.white
                              : AppColor.bnavigation,
                          height: cx.responsive(40, 32, 28)),
                      label: ''),
                ],
                currentIndex: cx.curIndex.value,
                onTap: (index) {
                  setState(() {
                    // debugPrint(index.toString());
                    // cx.curIndex = index;
                    cx.curIndex.value = index;
                  });

                  if (index == 1) {
                    bookListController.page = 1;
                    bookListController.getTask("1");
                  }
                  if (index == 0 || index == 2) {
                    categoryController.getTask();
                  }
                  if (cx.curIndex.value == 3) {
                    cx.searchDome.value = "";
                  }
                },
              ),
            ),
          ));
    });
  }
}
