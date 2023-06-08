import 'package:cached_network_image/cached_network_image.dart';
import 'package:domez/screens/menuPage/requestDomez.dart';
import 'package:domez/screens/menuPage/settings.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../commonModule/AppColor.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/Strings.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../../commonModule/widget/common/webView.dart';
import '../../controller/commonController.dart';
import '../authPage/editProfile.dart';
import '../authPage/signIn.dart';
import 'Favourites.dart';
import 'bookings.dart';
import 'helpcenter.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textNunito.dart';

class ManageAccounts extends StatefulWidget {
  const ManageAccounts({Key? key}) : super(key: key);

  @override
  State<ManageAccounts> createState() => _ManageAccountsState();
}

class _ManageAccountsState extends State<ManageAccounts> {
  CommonController cx = Get.put(CommonController());
  String? _linkMessage;
  bool _isCreatingLink = false;
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createDynamicLink(true,"/domeBooking");


    print(cx.image.value);
    print(cx.read("image"));
    if(cx.name.value==null){
      cx.name.value='';
    }
    print(cx.width);
  }
  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.white);

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          //color set to transperent or set your own color
          statusBarIconBrightness: Constant.deviceBrightness,
          //set brightness for icons, like dark background light icons
        )
    );
    return WillPopScope(
      onWillPop: () async{
        if(cx.curIndex.value!=0){
          cx.curIndex.value=0;
        }
        return false;

      },
      child: Scaffold(
          body: Padding(
            padding:  EdgeInsets.only(left:cx.height /74.11),
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                Gap(cx.height / 13.34),
                ListTile(

                  onTap: (){
                    if(cx.read("username")==''){
                      Get.to(
                          SignIn(curIndex: 4),
                          transition: Transition.rightToLeft
                      );
                    }
                    else{
                      if(cx.read("islogin")){
                        Get.to(EditProfile());

                      }

                    }
                  },
                  leading: InkWell(
                    onTap: () {
                      if(cx.read("islogin")){
                        Get.to(EditProfile());

                      }

                      },
                    child: CircleAvatar(
                      radius: cx.responsive(35,28, 25),
                      backgroundColor:Color(0xFFDCE4E1),

                      child:  CachedNetworkImage(

                        imageUrl: cx.read("image"),

                        imageBuilder: (context, imageProvider) => CircleAvatar(

                          backgroundColor: Colors.transparent,
                          radius: cx.responsive(30,24, 21),
                          backgroundImage: NetworkImage(
                            cx.read("image"),

                          ),
                        ),
                        fit: BoxFit
                            .cover,
                        placeholder: (context, url) => CircleAvatar(
                          backgroundColor:
                          Colors.transparent,
                          radius: cx.responsive(
                              30,24, 21),
                          backgroundImage:
                          AssetImage(
                            Image1.anime,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: cx.responsive(30,24, 21),
                              backgroundImage: AssetImage(
                                Image1.anime,
                              ),

                            ),
                      ),
                    ),
                  ),
                  title: cx.read("islogin")==false?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SenticText(
                          text: "Guest User",
                          fontSize: cx.height > 800 ? 25 : 21,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF222222),
                        ),
                        Gap(7),
                        InkWell(
                          onTap: (){
                            Get.to(
                                SignIn(curIndex: 4),
                                transition: Transition.rightToLeft
                            );
                            // onAlertSignIn(context:context);
                          },
                          child: SenticText(
                            text: "Sign In",
                            fontSize: cx.height > 800 ? 18 : 14,
                            fontWeight: FontWeight.w600,
                            color: AppColor.darkGreen,
                          ),
                        ),
                      ],
                    ):
                    SenticText(
                      text: cx.read("username").toString()=="null"?"Domez User":cx.read("username"),
                      fontSize: cx.height > 800 ? 25 : 21,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF222222),
                    ),

                  trailing: cx.read("username")==''?
                  Container(
                    child: Text(""),
                  ):
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                  )
                ),
                Gap(cx.height / 33.5),
                Divider(
                  thickness: 0.4,
                  color: Color(0xFFD6D6D6),
                  indent: 18,
                  endIndent: 18,
                  height: 5,
                ),
                Gap(cx.height / 33.5),
                InkWell(
                  onTap: () async {

                    cx.read("islogin")?
                    Get.to(Favourites()):
                    onAlertSignIn(context:context);
                  },
                  child: ListTile(
                    // dense: true,
                    // contentPadding:EdgeInsets.fromLTRB(20, cx.height/55.58, cx.height/44.47, 0),
                    leading:  Image.asset(
                      "assets/images/favourites.png",
                      scale: cx.height > 800 ? 2 : 2.5,
                    ),
                    title: NunitoText(
                      text: "Favourites",
                      fontSize: cx.height > 800 ? 22 : 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6A6A6A),
                    ),
                  ),
                ),
                Gap(cx.height / 55.58),


                InkWell(
                  onTap: (){
                    cx.read("islogin")?
                    Get.to(
                      Bookings(isBackButton: true),):
                      onAlertSignIn(context:context);

                  },
                  child: ListTile(
                    // dense: true,
                    // contentPadding:EdgeInsets.fromLTRB(20, cx.height/55.58, cx.height/44.47, 0),
                    leading: Image.asset(
                      "assets/images/bookings.png",
                      scale: cx.height > 800 ? 2 : 2.5,
                    ),
                    title: NunitoText(
                      text: "My Bookings",
                      fontSize: cx.height > 800 ? 22 : 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6A6A6A),
                    ),

                  ),
                ),
                Gap(cx.height / 55.58),

                InkWell(
                  onTap: (){
                    onShareData(
                        text: "\*Download Domez Now😍"
                            "\*\n\nLink For iOS:\nhttps://apps.apple.com/us/app/domez/id6444339880"
                            "\n\nLink For Android:"
                            "\nhttps://play.google.com/store/apps/details?id=domez.io\n"
                    );
                  },
                  child: ListTile(
                    // dense: true,
                    // contentPadding:EdgeInsets.fromLTRB(20, cx.height/55.58, cx.height/44.47, 0),
                    leading:   Image.asset(
                      "assets/images/invite.png",
                      scale: cx.height > 800 ? 2 : 2.5,
                    ),
                    title: NunitoText(
                      text: "Invite Friends",
                      fontSize: cx.height > 800 ? 22 : 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6A6A6A),
                    ),

                  ),
                ),
                Gap(cx.height / 55.58),


                InkWell(
                  onTap: (){
                    cx.read("islogin")?
                    Get.to(
                      RequestDomez(),):
                    onAlertSignIn(context:context);

                  },
                  child: ListTile(
                    // dense: true,
                    // contentPadding:EdgeInsets.fromLTRB(20, cx.height/55.58, cx.height/44.47, 0),
                    leading: Image.asset(
                      "assets/images/requestDomez.png",
                      scale: cx.height > 800 ? 2 : 2.5,
                    ),
                    title: NunitoText(
                      text: "Request Domez App",
                      fontSize: cx.height > 800 ? 22 : 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6A6A6A),
                    ),

                  ),
                ),
                Gap(cx.height / 55.58),

                InkWell(
                  onTap: (){
                    cx.read("islogin")?
                    Get.to(
                      HelpCenter(),
                    ):
                    onAlertSignIn(context:context);

                  },
                  child: ListTile(
                    // dense: true,
                    // contentPadding:EdgeInsets.fromLTRB(20, cx.height/55.58, cx.height/44.47, 0),
                    leading:  Image.asset(
                      "assets/images/help.png",
                      scale: cx.height > 800 ? 2 : 2.5,
                    ),
                    title: NunitoText(
                      text: "Help Center",
                      fontSize: cx.height > 800 ? 22 : 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6A6A6A),
                    ),

                  ),
                ),

                Gap(cx.height /22.23),
                Divider(
                  thickness: 0.4,
                  color: Color(0xFFD6D6D6),
                  indent: 18,
                  endIndent: 18,
                  height: 5,
                ),
                Gap(cx.height /70),
                Padding(
                  padding:  EdgeInsets.only(left: cx.width /18),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: Container(
                          height: 40,
                          width: cx.width,
                          child: NunitoText(
                            text: "Settings",
                            fontSize: cx.height > 800 ? 22 : 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6A6A6A),
                          ),
                        ),
                        onTap: () async {
                          cx.read("islogin")?
                          Get.to(Settings()):
                          onAlertSignIn(context:context);
                        },
                      ),

                      InkWell(
                        onTap: (){
                          Get.to(WebViewClass(
                            "Terms And Conditions",
                              Constant.termsUrl
                          ));
                        },
                        child: Container(
                          height: 40,
                          width: cx.width,
                          child: NunitoText(
                            text: "Terms And Conditions",
                            fontSize: cx.height > 800 ? 22 : 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6A6A6A),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Get.to(WebViewClass(
                              "Privacy Policy",
                              Constant.privacyUrl
                          ));
                        },
                        child: Container(
                          height: 40,
                          width: cx.width,
                          child: NunitoText(
                            text: "Privacy Policy",
                            fontSize: cx.height > 800 ? 22 : 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6A6A6A),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Get.to(WebViewClass(
                              "Cancellation Policy",
                              Constant.cancelUrl
                          ));
                        },
                        child: Container(
                          height: 40,
                          width: cx.width,
                          child: NunitoText(
                            text: "Cancellation Policy",
                            fontSize: cx.height > 800 ? 22 : 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6A6A6A),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Get.to(WebViewClass(
                              "Refund Policy",
                              Constant.refundUrl
                          ));
                        },
                        child: Container(
                          height: 40,
                          width: cx.width,
                          child: NunitoText(
                            text: "Refund Policy",
                            fontSize: cx.height > 800 ? 22 : 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6A6A6A),
                          ),
                        ),
                      ),
                      Gap(cx.height /51.31),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
  Future<void> _createDynamicLink(bool short, String link) async {
    setState(() {
      _isCreatingLink = true;
    });
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: Constant.kUriPrefix,
      // link: Uri.parse(Constant.kUriPrefix + link+'?bookingId=45'),
      link: Uri.parse("https://www.domez.io/domeBooking?bookingId=1"),
      // link: Uri.parse(Constant.kUriPrefix + link),
      // longDynamicLink: Uri.parse(
      //   'https://flutterfiretests.page.link?efr=0&ibi=io.flutter.plugins.firebase.dynamiclinksexample&apn=io.flutter.plugins.firebase.dynamiclinksexample&imv=0&amv=0&link=https%3A%2F%2Fexample%2Fhelloworld&ofl=https://ofl-example.com',
      // ),
      androidParameters: const AndroidParameters(
        packageName: 'domez.io',
        minimumVersion: 0,
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
      await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
    print("Hey NORA"+_linkMessage.toString());

  }
}