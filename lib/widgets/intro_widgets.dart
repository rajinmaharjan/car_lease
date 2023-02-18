import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../utils/colors_utils.dart';

Widget introWidget() {
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(180),
          bottomRight: Radius.circular(180)),
      gradient: LinearGradient(colors: [
        hexStringColor("47d3f0"),
        hexStringColor("47d3f0"),
      ], begin: Alignment.bottomLeft, end: Alignment.topRight),
    ),
    height: Get.height * 0.6,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage('assets/carLease.png'),
          height: Get.height * .1,
        ),
        const Text(
          'Yuuki Cars',
          style: TextStyle(height: 3, fontSize: 30),
        ),
      ],
    ),
  );
}
