import 'package:flutter/material.dart';
import 'package:sellers_app/global/global.dart';

showReusableSnackBar(String title, BuildContext context) {
  SnackBar snackBar = SnackBar(
    backgroundColor: Colors.black,
    duration: const Duration(seconds: 2),
    content: text(title, fontSize: 16, color: Colors.white),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
