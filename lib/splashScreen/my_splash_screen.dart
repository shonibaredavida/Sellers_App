import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/mainScreens/home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  splashScreenTimer() {
    Timer(
      const Duration(seconds: 3),
      (() async {
        if (FirebaseAuth.instance.currentUser != null) {
          // the seller is already logged in
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else {
          // No seller is logged in
          //   Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => const AuhScreen()));
        }
      }),
    );
  }

  @override
  void initState() {
    // runs first b4 any other things on run time
    super.initState();
    splashScreenTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.green,
                Colors.black,
                Colors.red,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              // stops: [0.0, 1.0],  #check
              tileMode: TileMode.clamp),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset("images/splash.png"),
              ),
              const SizedBox(height: 10),
              const Text("iShop Sellers App",
                  style: TextStyle(
                      fontSize: 30,
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }
}
