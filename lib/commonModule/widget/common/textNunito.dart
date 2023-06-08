import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NunitoText extends StatefulWidget {
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
  State<NunitoText> createState() => _NunitoTextState();
}

class _NunitoTextState extends State<NunitoText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text??"",
      textAlign: widget.textAlign,
      maxLines: widget.maxLines ?? 3,
      overflow: widget.textOverflow??TextOverflow.ellipsis,

      style: GoogleFonts.nunito(
        shadows: widget.shadow??[],
        height: widget.height,
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
        color: widget.color ?? Colors.black,
        decoration: widget.textDecoration,
        decorationStyle: TextDecorationStyle.solid,


      ),
    );
  }
}

