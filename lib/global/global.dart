import 'package:flutter/material.dart';
import 'package:sellers_app/assistant_method/cart_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
CartMethods cartMethods = CartMethods();
String previousSellerEarnings = "";

//mine
sizedBox({double? height, double? width, Widget? child}) {
  return SizedBox(
    height: height ?? 2,
    width: width ?? 0,
    child: child,
  );
}

String fcmServerToken =
    'key= AAAA7OeAvQc:APA91bGUDjnyGwuOBNFWczUpYcR0tqhLq9trtxioecRfHHwSMTovlywZaUDaAseMjMdS4Tr3mTQjGFX2gg_vx-ckaBdNIbAuIc8bszwF7daA0ZSBKd7W1fdsgS1KdzkQX3CijOJZPg1T';

bool dev = true;
printo(message) {
  // ignore: avoid_print
  print('WE WE WE WE $message');
}

Color appDeeperPrimaryColor = Colors.purpleAccent;

Widget text(String data,
    {Color? color,
    double? letterSpacing,
    double? fontSize,
    TextAlign? textAlign,
    FontWeight? fontWeight}) {
  return Text(
    data,
    textAlign: textAlign ?? TextAlign.start,
    style: TextStyle(
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? Colors.white,
        letterSpacing: letterSpacing ?? 2,
        fontSize: fontSize ?? 16),
  );
}
