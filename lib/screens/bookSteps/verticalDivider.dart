import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/commonController.dart';

class VerticDivider extends StatefulWidget {
  bool s4complete;
  VerticDivider(this.s4complete);

  @override
  State<VerticDivider> createState() => _VerticDividerState();
}

class _VerticDividerState extends State<VerticDivider> {
  CommonController cx = Get.put(CommonController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(
          left: widget.s4complete?MediaQuery.of(context).size.width*0.075:0
      ),
      child: Container(
          height:cx.height/30,
          width:3,
          color:const Color(0xFFE9E9E9)
      ),
    );
  }
}
