import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NunitoText extends StatelessWidget {
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

  NunitoText(
      {this.text,
      this.fontSize,
      this.fontWeight,
      this.textDecoration,
      this.color,
      this.textAlign,
      this.height,
      this.maxLines,
        this.textOverflow,
        this.shadow
      });
  @override
  Widget build(BuildContext context) {
    return Text(
      text??"",
      textAlign: textAlign,
      maxLines: maxLines ?? 3,
      overflow: textOverflow??TextOverflow.ellipsis,

      style: GoogleFonts.nunito(
        shadows: shadow??[],
        height: height,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Colors.black,
        decoration: textDecoration,
        decorationStyle: TextDecorationStyle.solid,


      ),
    );
  }
}

