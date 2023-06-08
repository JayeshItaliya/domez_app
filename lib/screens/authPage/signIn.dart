import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:get/get.dart';
import 'package:page_indicator/page_indicator.dart';
import '../../commonModule/AppColor.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/Strings.dart';
import '../../commonModule/widget/search/simplecircularIcon.dart';
import '../../controller/commonController.dart';
import '../bottomSheet/bottomSheetSignIn.dart';

class SignIn extends StatefulWidget {
  final bool isBackButton;
  final int curIndex;

   SignIn({
    Key? key,
    this.isBackButton =true,
    required this.curIndex

  }) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool fav=false;
  CommonController cx = Get.put(CommonController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!cx.read("islogin")&&widget.isBackButton==false) {
      showLongToast("Please Sign In First!");
    }
  }
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);

    final size = MediaQuery.of(context).size;
    return Container(
      color:Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        // resizeToAvoidBottomInset: true,
        // key: _scaffoldkey,
        body:
        SafeArea(
          top:false,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                height: size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                        0.5,
                        0.6
                      ],
                      colors: [
                        Colors.white,
                        Colors.white,
                      ]),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(cx.height/16.7, cx.height/23.82),
                      bottomRight: Radius.elliptical(cx.height/16.7, cx.height/23.82)),
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.zero,

                  children: [
                    Stack(
                      children: [
                        Container(
                          height: size.height / 2 ,
                          child: buildImage(
                              size
                          ),
                        ),
                        widget.isBackButton?Positioned(
                          left:cx.height>800?25: 20,
                          top: 38,
                          child: InkWell(
                            onTap: (){
                              Get.back();
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: cx.responsive(32,24,17),
                              child: SimpleCircularIconButton(
                                iconData: Icons.arrow_back_ios_new,
                                fillColor: Colors.red,
                                radius: cx.responsive(60,45,35),

                              ),
                            ),
                          ),
                        ):Container(),
                        BottomSheetSignIn(curIndex: widget.curIndex),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildImage(Size size) {
    return  Container(
      height: size.height/2,
      child: PageIndicatorContainer (
          padding: EdgeInsets.only(bottom: cx.responsive(115,90,75),),
          align: IndicatorAlign.bottom,
          length:1,
          indicatorColor: AppColor.bg,
          indicatorSelectorColor: AppColor.darkGreen,
          // size: 10.0,
          indicatorSpace: 8.0,
          child: PageView.builder(
              itemCount:1,
              itemBuilder: (BuildContext context,int i){
                return Container(
                    child: Image.asset(Image1.signUp,fit: BoxFit.cover,)
                );
              })),
    );
  }

}
