import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/commonController.dart';
import '../common/textNunito.dart';

class CustomButton extends StatefulWidget {
  CustomButton({Key? key,required this.text,required this.fun,this.color,this.textColor,this.radius,this.width,this.size,this.padding=0}) : super(key: key);
  Color? color;
  Color? textColor;
  double? radius;
  String text;
  double? width;
  double? size;
  double padding;
  VoidCallback fun;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  CommonController cx = Get.put(CommonController());
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.fun,
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
          color: widget.color??Colors.white,
          borderRadius: BorderRadius.circular(widget.radius??0.0)
        ),
        padding: EdgeInsets.all(widget.padding),
        child: Center(
          child: NunitoText(
            text: widget.text,
            fontWeight: FontWeight.w700,
            fontSize: widget.size,
            color: widget.textColor,
          ),
        ),
      ),
    );
  }
}
