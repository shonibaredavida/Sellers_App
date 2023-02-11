import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
bool dev = true;

sizedBox({double? height, double? width, Widget? child}) {
  return SizedBox(
    height: height ?? 2,
    width: width ?? 0,
    child: child,
  );
}

printo(message) {
  // ignore: avoid_print
  print('WE WE WE WE $message');
}
