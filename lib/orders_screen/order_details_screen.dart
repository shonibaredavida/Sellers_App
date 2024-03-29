import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sellers_app/Models/address_model.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/orders_screen/address_design_widget.dart';
import 'package:sellers_app/orders_screen/status_banner_widget.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String? orderID;
  const OrderDetailsScreen({super.key, this.orderID});
  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String orderDataStatus = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("orders")
                .doc(widget.orderID.toString())
                .get(),
            builder: (c, AsyncSnapshot dataSnapshot) {
              if (dataSnapshot.hasData) {
                if (dev) printo("retrieving order information");
                Map? orderDataMap =
                    dataSnapshot.data.data() as Map<String, dynamic>;
                orderDataStatus = orderDataMap['status'].toString();

                if (dev) printo("displaying order information");
                return Column(
                  children: [
                    StatusBanner(
                      orderStatus: orderDataStatus,
                      status: orderDataMap['isSucess'],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "N ${orderDataMap['totalAmount']}",
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Order ID: ${orderDataMap['orderId'].toString()}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Order at  ${DateFormat("dd MMMM,yyyy - hh:mm aa").format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(orderDataMap['orderTime'])),
                        )}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                      color: Colors.red,
                    ),
                    Container(
                      child: orderDataStatus != "ended"
                          ? Image.asset("images/packing.jpg")
                          : Image.asset("images/delivered.jpg"),
                    ),
                    const Divider(
                      thickness: 2,
                      color: Colors.red,
                    ),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("users")
                          .doc(orderDataMap["orderBy"])
                          .collection("userAddress")
                          .doc(orderDataMap["addressID"])
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot addressSnapshot) {
                        if (addressSnapshot.hasData) {
                          return AddressDesign(
                              model: Address.fromJson(addressSnapshot.data
                                  .data() as Map<String, dynamic>),
                              sellerId: orderDataMap['sellerUID'],
                              orderId: widget.orderID,
                              orderStatus: orderDataStatus,
                              orderedByUser: orderDataMap['orderBy'],
                              orderTotalAmount: orderDataMap['totalAmount']);
                        } else {
                          return const Text("No Data Found");
                        }
                      },
                    ),
                  ],
                );
              } else {
                return const Center(child: Text("No Details to display"));
              }
            }),
      ),
    );
  }
}
