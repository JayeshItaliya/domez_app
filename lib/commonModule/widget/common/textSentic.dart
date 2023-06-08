import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// class SenticText extends StatefulWidget {
//   String? text;
//   double? fontSize;
//   Color? color;
//   FontWeight? fontWeight;
//   TextDecoration? textDecoration;
//   TextAlign? textAlign;
//   double? height;
//   int? maxLines;
//   TextOverflow? textOverflow;
//   SenticText(
//       {this.text,
//       this.fontSize,
//       this.fontWeight,
//       this.textDecoration,
//       this.color,
//       this.textAlign,
//       this.height,
//       this.maxLines,
//       this.textOverflow
//       });
//   @override
//   State<SenticText> createState() => _SenticTextState();
// }
//
// class _SenticTextState extends State<SenticText> {
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       widget.text??"",
//       textAlign: widget.textAlign??TextAlign.left,
//       overflow: widget.textOverflow??TextOverflow.ellipsis,
//       maxLines:widget.maxLines??2,
//
//       style: TextStyle(
//         color: widget.color,
//         height: widget.height,
//         fontFamily: 'Sentic',
//         fontWeight: widget.fontWeight??FontWeight.w500,
//         fontSize: widget.fontSize??32,
//       ),
//     );
//   }
// }
class SenticText extends StatefulWidget {
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
  State<SenticText> createState() => _SenticTextState();
}

class _SenticTextState extends State<SenticText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text??"",
      textAlign: widget.textAlign??TextAlign.left,
      overflow: widget.textOverflow??TextOverflow.ellipsis,
      maxLines:widget.maxLines??2,

      style: GoogleFonts.inter(
        height: widget.height??0,
        fontSize: widget.fontSize ?? 20,
        fontWeight: widget.fontWeight,
        color: widget.color,
        decoration: widget.textDecoration,
        decorationStyle: TextDecorationStyle.solid,
        shadows: widget.shadow??[],


      ),
    );
  }
}
