import 'package:flutter/material.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/mainScreens/home_screen.dart';

class StatusBanner extends StatelessWidget {
  final bool? status;
  final String? orderStatus;
  const StatusBanner({super.key, this.status, this.orderStatus});

  @override
  Widget build(BuildContext context) {
    String? message;
    IconData? iconData;
    status! ? iconData = Icons.done : iconData = Icons.cancel;
    status! ? message = "Successful" : message = "Unsuccessful";
    return Container(
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
      height: 70,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            sizedBox(
              width: 30,
            ),
            Text(
              orderStatus == "ended"
                  ? "Parcel Delivered $message"
                  : orderStatus == "shifted"
                      ? "Parcel Shifted $message"
                      : orderStatus == "normal"
                          ? "Parcel Delivered $message"
                          : "",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            sizedBox(
              width: 6,
            ),
            CircleAvatar(
              radius: 8,
              backgroundColor: Colors.white,
              child: Center(
                child: Icon(
                  iconData,
                  color: Colors.black,
                  size: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
