import 'package:domez/controller/commonController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../commonModule/Constant.dart';
import '../../commonModule/Strings.dart';
import '../../controller/domesDetailsController.dart';
import '../../controller/domesListController.dart';
import '../../model/domesListModel.dart';
import 'package:gap/gap.dart';
import '../../commonModule/widget/common/textInter.dart';
import '../../commonModule/widget/common/textNunito.dart';
import '../../commonModule/widget/common/textSentic.dart';
import '../authPage/signIn.dart';
import '../bookSteps/DomePage.dart';

class MostPopular extends StatefulWidget {
  const MostPopular({Key? key}) : super(key: key);

  @override
  State<MostPopular> createState() => _MostPopularState();
}

class _MostPopularState extends State<MostPopular> {
  CommonController cx = Get.put(CommonController());
  final mycontroller = Get.put(DomesListController());
  final dx = Get.put(DomesDetailsController());
  List<int> errorImagesMostPopular = [];



  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        systemStatusBarContrastEnforced:true
    ));

    return Scaffold(
        body: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
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
                          text: 'Most\nPopular',
                          fontSize:
                          cx.height > 800
                              ? 30
                              : 26,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Gap(cx.height / 33.5),
              Obx(()=>GridView.builder(
                  shrinkWrap: true,
                  itemCount: mycontroller.myList2.length,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                      left:  10,
                      right: 10
                  ),

                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    // maxCrossAxisExtent: 200,
                    crossAxisSpacing: 1.0,
                      mainAxisSpacing: 4.0,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (BuildContext context, int index){
                    DomesListModel item =
                    mycontroller.myList2[index];
                    return Padding(
                      padding: EdgeInsets.only(
                          left:  0,
                        right: 0
                          ),
                      child: InkWell(
                        onTap: (){
                          Get.to(
                            DomePage(
                              isFav: item.isFav,
                              domeId: item.id.toString(),
                            ),);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                                cx.width / 12),
                          ),
                          color: Colors.transparent,
                          elevation: 4,
                          clipBehavior:
                          Clip.antiAliasWithSaveLayer,
                          child: Container(
                            height: cx.height/2.78,
                            width: cx.width / 2.2,
                            decoration:
                            errorImagesMostPopular
                                .contains(item
                                .id)
                                ? BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(Image1.domesAround),

                                fit: BoxFit.cover,

                              ),
                            )
                                :BoxDecoration(
                              image:
                              DecorationImage(
                                image: NetworkImage(item
                                    .image
                                    .isEmpty
                                    ? "https://www.playall.in/images/gallery/orbitMall_box_cricket_2.png"
                                    : item.image),
                                fit: BoxFit
                                    .cover,
                                onError: (Object e, StackTrace? stackTrace) {
                                  setState(() {
                                    errorImagesMostPopular.add(item.id);
                                  });
                                },
                              ),
                              color: Colors
                                  .transparent,
                            ),
                            child: Container(
                              height: cx.height / 2.78,
                              width: cx.width / 2.2,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin:
                                      Alignment.topCenter,
                                      end: Alignment
                                          .bottomCenter,
                                      colors: [
                                        Colors.black
                                            .withOpacity(.0),
                                        Colors.black
                                            .withOpacity(.7),
                                      ])
                              ),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Container(
                                        width:cx.width / 4,
                                        height: cx.responsive(50,42, 38),
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: mycontroller.myList2[index].sportsList.length,
                                            itemBuilder: (context, i) {
                                              if(i<=1){
                                                return Padding(
                                                  padding: EdgeInsets.fromLTRB(i==0?cx.height / 41.69:3, 10, 0, 0),
                                                  child: Image.network(
                                                    item.sportsList[i].image,
                                                    scale: cx.height > 800
                                                        ? 1.2
                                                        : 1.4,
                                                    color: Colors.white,                                                  ),
                                                );
                                              }
                                              else{
                                                return Container();
                                              }


                                            }),
                                      ),
                                      Padding(
                                        padding: EdgeInsets
                                            .fromLTRB(
                                            0.0,
                                            cx.height /
                                                33.5,
                                            cx.height /
                                                44.47,
                                            0),
                                        child: Container(
                                          height: cx.height /15,
                                          alignment:
                                          Alignment(0, 0),
                                          width: cx.width /8,
                                          decoration: BoxDecoration(
                                              color: Color(
                                                  0xFFFFE68A),
                                              borderRadius: BorderRadius
                                                  .circular(cx.responsive(23,18, 15))),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center,
                                            children: [
                                              InterText(

                                                // text: item.price.toStringAsFixed(0).toString(),
                                                text: "\$" + item.price.toInt().toString(),
                                                fontSize: cx.height > 800 ? 17 : 15,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF07261A),
                                                textAlign: TextAlign.center,
                                                height: 0,
                                              ),
                                              InterText(
                                                height: 0,
                                                textAlign: TextAlign.center,
                                                text: '/Hour',
                                                fontSize: cx.height > 800 ? 11 : 9,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF07261A),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                    EdgeInsets.fromLTRB(
                                        cx.height / 41.69,
                                        cx.height /
                                            83.375,
                                        cx.height / 44.47,
                                        cx.height /
                                            83.375),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Container(
                                          width:
                                          cx.width *
                                              0.27,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              InterText(

                                                shadow: <Shadow>[
                                                  Shadow(
                                                    offset: Offset(1.0, 1.0),
                                                    blurRadius: 3.0,
                                                    color: Color.fromARGB(255, 0, 0, 0),
                                                  ),
                                                  Shadow(
                                                    offset: Offset(1.0, 1.0),
                                                    blurRadius: 8.0,
                                                    color: Color.fromARGB(255, 0, 0, 0),
                                                  ),
                                                ],
                                                text:
                                                item.totalFields.toString()+" Fields",
                                                fontWeight:
                                                FontWeight
                                                    .w500,
                                                color: Colors
                                                    .white
                                                    .withOpacity(
                                                    0.7),
                                                fontSize:
                                                cx.height >
                                                    800
                                                    ? 14
                                                    : 12,
                                                height: 2,

                                              ),
                                              Container(
                                                width:
                                                cx.width *
                                                    0.27,
                                                child: InterText(

                                                  shadow: <Shadow>[
                                                    Shadow(
                                                      offset: Offset(1.0, 1.0),
                                                      blurRadius: 3.0,
                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                    ),
                                                    Shadow(
                                                      offset: Offset(1.0, 1.0),
                                                      blurRadius: 8.0,
                                                      color: Color.fromARGB(255, 0, 0, 0),
                                                    ),
                                                  ],
                                                  text: item.name,
                                                  fontWeight:
                                                  FontWeight
                                                      .w700,
                                                  color: Colors
                                                      .white,
                                                  fontSize:
                                                  cx.height >
                                                      800
                                                      ? 19
                                                      : 16,
                                                  height: 1.5,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .location_on_outlined,
                                                    color: Colors
                                                        .white,
                                                    size: cx.responsive(24,20, 18),
                                                  ),
                                                  Container(
                                                    width:
                                                    cx.width *
                                                        0.2,
                                                    child:
                                                    NunitoText(

                                                      shadow: <Shadow>[
                                                        Shadow(
                                                          offset: Offset(1.0, 1.0),
                                                          blurRadius: 3.0,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                        ),
                                                        Shadow(
                                                          offset: Offset(1.0, 1.0),
                                                          blurRadius: 8.0,
                                                          color: Color.fromARGB(255, 0, 0, 0),
                                                        ),
                                                      ],
                                                      textAlign: TextAlign.start,
                                                      text: "${item.city}, ${item.state}",
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontSize: cx.height > 800 ? 17 : 14,
                                                      color: Colors.white,
                                                      height: 2,
                                                      textOverflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Gap(5)
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .end,
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .end,
                                          children: [
                                            InkWell(
                                              child: Icon(
                                                item.isFav
                                                    ? Icons
                                                    .favorite
                                                    :
                                                Icons
                                                    .favorite_border_rounded,
                                                color: Colors
                                                    .white,
                                                size:25,
                                              ),
                                              onTap: () {
                                                if (cx.read("islogin")) {
                                                  setState(
                                                          () {
                                                        // fav=!fav;
                                                        // print(mostPopular);
                                                        // mostPopular[index] =!mostPopular[index];
                                                        item.isFav =
                                                        !item
                                                            .isFav;
                                                      });
                                                  cx.favourite(
                                                      uid: cx.read("id").toString(),
                                                      did: item
                                                          .id
                                                          .toString());
                                                } else {
                                                  onAlertSignIn(context:context);


                                                  Get.to(
                                                      SignIn(curIndex: 0));
                                                }
                                              },
                                            ),
                                            SizedBox(
                                                height:
                                                cx.height /
                                                    44.47),
                                            Image.asset(
                                              Image1.calendar,
                                              scale:2,
                                            ),
                                            SizedBox(
                                                height:
                                                cx.height /
                                                    44.47),
                                          ],
                                        ),
                                        // Gap(50),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        ]));
  }
}
