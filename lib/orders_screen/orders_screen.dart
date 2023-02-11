import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/orders_screen/order_card.dart';

/* class OrdersScreen ext ends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "iShop",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(sharedPreferences!.getString("uid"))
            .collection("orders")
            .where("status", isEqualTo: "normal")
            .orderBy(("orderTime"), descending: true)
            .snapshots(),
        builder: (c, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (c, index) {
                return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("items")
                        .where("itemID",
                            whereIn: cartMethods.separateOrderItemIDs(
                                (snapshot.data.docs[index].data()
                                    as Map<String, dynamic>)["productIDs"]))
                        .where("orderBy",
                            whereIn: (snapshot.data.docs[index].data()
                                as Map<String, dynamic>)["uid"])
                        .orderBy("publishedDate", descending: true)
                        .get(),
                    builder: (c, AsyncSnapshot itemSnapshot) {
                      if (itemSnapshot.hasData) {
                        if (dev) print("incex of orders...\n\n\n $index\n\n");
                        return OrderCart(
                            itemCounts: itemSnapshot.data.docs.length,
                            data: itemSnapshot.data.docs,
                            orderId: itemSnapshot.data.docs[index].id,
                            separateQuantityList:
                                cartMethods.separateOrderItemQty((itemSnapshot
                                        .data.docs[index]
                                        .data()
                                    as Map<String, dynamic>)["productIDs"]));
                      } else {
                        if (dev) {
                          print(
                              "WE WE WE itemCounts:  ${itemSnapshot.data},   data:$index , orderId: ,\n\n");
                        }

                        return const Center(
                          child: Text(
                            "No Order has been placed..",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        );
                      }
                    });
              },
            );
          } else {
            return const Center(
              child: Text(
                "No Order has been placed",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }
} */

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
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
          )),
        ),
        title: const Text(
          "New Orders",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("status", isEqualTo: "normal")
            .where("sellerUID", isEqualTo: sharedPreferences!.getString("uid"))
            .orderBy("orderTime", descending: true)
            .snapshots(),
        builder: (c, AsyncSnapshot dataSnapShot) {
          if (dataSnapShot.hasData) {
            return ListView.builder(
              itemCount: dataSnapShot.data.docs.length,
              itemBuilder: (c, index) {
                return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("items")
                      .where("itemID",
                          whereIn: cartMethods.separateOrderItemIDs(
                              (dataSnapShot.data.docs[index].data()
                                  as Map<String, dynamic>)["productIDs"]))
                      .where("SellerUID  ",
                          whereIn: (dataSnapShot.data.docs[index].data()
                              as Map<String, dynamic>)["uid"])
                      .orderBy("publishedDate", descending: true)
                      .get(),
                  builder: (c, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (dev) {
                        printo("displayed the orders accordingly");
                      }
                      return OrderCart(
                        itemCounts: snapshot.data.docs.length,
                        data: snapshot.data.docs,
                        orderId: dataSnapShot.data.docs[index].id,
                        separateQuantityList: cartMethods.separateOrderItemQty(
                            (dataSnapShot.data.docs[index].data()
                                as Map<String, dynamic>)["productIDs"]),
                      );
                    } else {
                      if (dev) {
                        printo("No order to display2");
                      }
                      return const Center(
                        child: Text(
                          "No data exists.",
                          style: TextStyle(color: Colors.white54),
                        ),
                      );
                    }
                  },
                );
              },
            );
          } else {
            if (dev) {
              printo("o order to display1");
            }
            return const Center(
              child: Text(
                "No data exists.",
                style: TextStyle(color: Colors.white54),
              ),
            );
          }
        },
      ),
    );
  }
}
