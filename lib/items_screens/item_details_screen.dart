import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellers_app/Models/items_models.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/items_screens/items_screen.dart';
import 'package:sellers_app/mainScreens/home_screen.dart';
import 'package:sellers_app/splashScreen/my_splash_screen.dart';

class ItemsDetailsScreen extends StatefulWidget {
  ItemsDetailsScreen({this.model});
  Items? model;
  @override
  State<ItemsDetailsScreen> createState() => _ItemsDetailsScreenState();
}

class _ItemsDetailsScreenState extends State<ItemsDetailsScreen> {
  deleteItem() async {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("brands")
        .doc(widget.model!.brandID)
        .collection("items")
        .doc(widget.model!.itemID)
        .delete()
        .then((value) {
      FirebaseFirestore.instance
          .collection("items")
          .doc(widget.model!.itemID)
          .delete();
      if (dev) print(" WE WE WE WE  Item deleted successfully");
      Fluttertoast.showToast(msg: "Item Deleted Successfully");
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const MySplashScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model!.itemTitle.toString()),
        flexibleSpace: Container(
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
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (dev) print(" WE WE WE WE initialized Item deletion");
          deleteItem();
        },
        label: const Text("Delete this Item"),
        icon: const Icon(
          Icons.delete_sweep_outlined,
          color: Colors.pinkAccent,
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Image.network(
          widget.model!.thumbnailUrl.toString(),
        ),
        sizedbox(),
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 8),
          child: Text(
            widget.model!.itemTitle.toString(),
            textAlign: TextAlign.justify,
            style: const TextStyle(
              color: Colors.pinkAccent,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, right: 8, left: 8),
          child: Text(
            widget.model!.longDescription.toString(),
            textAlign: TextAlign.justify,
            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 9, right: 8, left: 8),
          child: Text(
            "₦ ${widget.model!.price.toString()}  ",
            textAlign: TextAlign.justify,
            style: const TextStyle(
              shadows: [
                Shadow(color: Colors.pinkAccent, offset: Offset(0, -7))
              ],
              color: Colors.transparent,
              decoration: TextDecoration.underline,
              decorationThickness: 4,
              decorationColor: Colors.pink,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ]),
    );
  }
}
