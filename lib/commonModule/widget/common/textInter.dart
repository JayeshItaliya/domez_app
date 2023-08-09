import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InterText extends StatelessWidget {
  String? text;
  double? fontSize;
  Color? color;
  FontWeight? fontWeight;
  TextDecoration? textDecoration;
  TextAlign? textAlign;
  double? height;
  List<Shadow>? shadow;

  InterText(
      {this.text,
      this.fontSize,
      this.fontWeight,
      this.textDecoration,
      this.color,
      this.textAlign,
      this.height,
        this.shadow

      });
  @override
  Widget build(BuildContext context) {

    return Text(
      text??"",
      textAlign: textAlign,
      maxLines: 1,

      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.inter(
        height: height,
        shadows: shadow??[],
        fontSize: fontSize ?? 20,
        fontWeight: fontWeight,
        color: color,
        decoration: textDecoration,
        decorationStyle: TextDecorationStyle.solid,

      ),
    );
  }
}
