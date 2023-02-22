import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellers_app/Models/address_model.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/splashScreen/my_splash_screen.dart';

class AddressDesign extends StatelessWidget {
  final Address? model;
  final String? orderStatus;
  final String? orderId;
  final String? sellerId;
  final String? orderedByUser;
  final String? orderTotalAmount;
  const AddressDesign(
      {super.key,
      this.model,
      this.sellerId,
      this.orderId,
      this.orderStatus,
      this.orderedByUser,
      this.orderTotalAmount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Shipping Details",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        sizedBox(height: 5),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(
            horizontal: 90,
            vertical: 5,
          ),
          child: Table(
            children: [
              TableRow(children: [
                const Text(
                  "Name",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  model!.name.toString(),
                  style: const TextStyle(color: Colors.grey),
                ),
              ]),
              TableRow(children: [sizedBox(height: 4), sizedBox(height: 4)]),
              TableRow(children: [sizedBox(height: 4), sizedBox(height: 4)]),
              TableRow(children: [
                const Text(
                  "Phone Number",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  model!.phoneNumber.toString(),
                  style: const TextStyle(color: Colors.grey),
                ),
              ]), /* TableRow(children: [
                const Text(
                  "Full Address ",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  model!.completeAddress.toString(),
                  style: const TextStyle(color: Colors.grey),
                ),
              ]), */
            ],
          ),
        ),
        sizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            model!.completeAddress.toString(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        sizedBox(height: 5),
        GestureDetector(
          onTap: () {
            if (orderStatus == "ended") {
              if (dev) printo("user order status is \"ended\"");
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MySplashScreen()));
            } else if (orderStatus == "shifted") {
              if (dev) printo("user order status is \"shifted\"");
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MySplashScreen()));
            } else if (orderStatus == "normal") {
              //update user earnings

              if (dev) printo("user order status is normal");

              FirebaseFirestore.instance
                  .collection("sellers")
                  .doc(sharedPreferences!.getString("uid"))
                  .update({
                "earnings": (double.parse(previousSellerEarnings) +
                        double.parse(orderTotalAmount!))
                    .toString()
              }).whenComplete(() {
                if (dev) printo("updated seller earnings");

                // //implement changing the order status to shifted
                FirebaseFirestore.instance
                    .collection("orders")
                    .doc(orderId)
                    .update({
                  "status": "shifted",
                });
              }).whenComplete(() {
                if (dev) printo("updated order status to shifted");
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(orderedByUser)
                    .collection("orders")
                    .doc(orderId)
                    .update({
                  "status": "shifted",
                });
              }).whenComplete(() {
                if (dev) printo("updated user order status to shifted ");
                //send notification to the user... order shifted
                //
                if (dev) printo("sending post notification to specific user");

                Fluttertoast.showToast(msg: "Confirmed Successfully.");

                if (dev) printo("sent flutterToast to Seller");
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MySplashScreen()));
              });
            } else {
              if (dev) printo(" user order  has no status ");

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MySplashScreen()));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.pinkAccent,
                      Colors.purpleAccent,
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                width: MediaQuery.of(context).size.width - 40,
                height: orderStatus == "ended"
                    ? 60
                    : MediaQuery.of(context).size.height * 0.08,
                child: Center(
                  child: Text(
                    orderStatus == "ended"
                        ? "Go Back"
                        : orderStatus == "Shifted"
                            ? "Go Back"
                            : orderStatus == "normal"
                                ? "Parcel Packed &\n Shifted to the nearest Picking Point \n Click to Confirm"
                                : "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                )),
          ),
        )
      ],
    );
  }
}
