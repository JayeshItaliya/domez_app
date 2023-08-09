import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SenticText extends StatelessWidget {
  String? text;
  double? fontSize;
  Color? color;
  FontWeight? fontWeight;
  TextDecoration? textDecoration;
  TextAlign? textAlign;
  double? height;
  int? maxLines;
  TextOverflow? textOverflow;
  List<Shadow>? shadow;

  SenticText(
      {this.text,
      this.fontSize,
      this.fontWeight,
      this.textDecoration,
      this.color,
      this.textAlign,
      this.height,
      this.maxLines,
        this.shadow,
        this.textOverflow
      });
  @override
  Widget build(BuildContext context) {
    return Text(
      text??"",
      textAlign: textAlign??TextAlign.left,
      overflow: textOverflow??TextOverflow.ellipsis,
      maxLines:maxLines??2,

      style: GoogleFonts.inter(
        height: height??0,
        fontSize: fontSize ?? 20,
        fontWeight: fontWeight,
        color: color,
        decoration: textDecoration,
        decorationStyle: TextDecorationStyle.solid,
        shadows: shadow??[],
      ),
    );
  }
}
