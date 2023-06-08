import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InterText extends StatefulWidget {
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
  State<InterText> createState() => _InterTextState();
}

class _InterTextState extends State<InterText> {

  @override
  Widget build(BuildContext context) {

    return Text(
      widget.text??"",
      textAlign: widget.textAlign,
      maxLines: 1,

      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.inter(
        height: widget.height,
        shadows: widget.shadow??[],
        fontSize: widget.fontSize ?? 20,
        fontWeight: widget.fontWeight,
        color: widget.color,
        decoration: widget.textDecoration,
        decorationStyle: TextDecorationStyle.solid,

      ),
    );
  }
}
