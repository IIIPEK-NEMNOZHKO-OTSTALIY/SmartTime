import 'package:flutter/material.dart';

Widget iosContainer({
  required List<Widget> children,
}) {
  return Container(
    height: 52,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(10),
          blurRadius: 12,
          offset: Offset(0,4),
        ),
      ],
    ),
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: [
        ...children
      ],
    ),
  );
}
