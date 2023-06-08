import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:get/get.dart';
import 'package:page_indicator/page_indicator.dart';
import '../../commonModule/AppColor.dart';
import '../../commonModule/Strings.dart';
import '../../commonModule/widget/search/simplecircularIcon.dart';
import '../../controller/commonController.dart';
import '../bottomSheet/bottomSheetSignUp.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  CommonController cx = Get.put(CommonController());
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    final size = MediaQuery.of(context).size;
    return Container(
      color:Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
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
                        Positioned(
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
                        ),

                        BottomSheetSignUp(),


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
