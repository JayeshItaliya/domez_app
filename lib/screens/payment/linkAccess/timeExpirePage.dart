import 'package:domez/commonModule/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../commonModule/widget/common/textNunito.dart';
import '../../../commonModule/widget/search/simplecircularIcon.dart';
import '../../../controller/commonController.dart';
import '../../../main_page.dart';

class TimeExpirePage extends StatefulWidget {
  const TimeExpirePage({Key? key}) : super(key: key);

  @override
  State<TimeExpirePage> createState() => _TimeExpirePageState();
}

class _TimeExpirePageState extends State<TimeExpirePage> {
  CommonController cx = Get.put(CommonController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: NunitoText(
                text:
                'Oops! The Timer Has\nBeen Expired',
                textAlign:
                TextAlign
                    .center,
                fontSize: cx
                    .responsive(
                    35,
                    29,
                    26),
                color: Colors
                    .grey
                    .shade600),
          ),
          Positioned(
            left: cx.responsive(60, 38, 28),
            top: cx.responsive(35, 25, 20),
            child: InkWell(
              onTap: () {
                Get.offAll(WonderEvents());
                cx.curIndex.value=0;
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 22,
                child: SimpleCircularIconButton(
                  iconData:
                  Icons.arrow_back_ios_new,
                  iconColor: Colors.black,
                  radius: cx.responsive(50, 42, 37),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
