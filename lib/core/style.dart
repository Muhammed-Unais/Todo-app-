import 'package:flutter/material.dart';

class TextandStyles extends StatelessWidget {
  const TextandStyles(
      {super.key,
      required this.titles,
      required this.fsize,
      required this.clr,
      required this.fwhit});

  final String titles;
  final double fsize;
  final Color clr;
  final FontWeight fwhit;

  @override
  Widget build(BuildContext context) {
    return Text(
      titles,
      style: TextStyle(
        fontSize: fsize,
        color: clr,
        fontWeight: fwhit,
      ),
    );
  }
}
