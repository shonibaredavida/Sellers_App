import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/Models/items_models.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/orders_screen/order_details_screen.dart';

class OrderCart extends StatefulWidget {
  const OrderCart(
      {super.key,
      this.data,
      this.itemCounts,
      this.orderId,
      required this.separateQuantityList});
  final int? itemCounts;
  final List<DocumentSnapshot>? data;
  final String? orderId;
  final List<String> separateQuantityList;

  @override
  State<OrderCart> createState() => _OrderCartState();
}

class _OrderCartState extends State<OrderCart> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(
                  orderID: widget.orderId,
                )));
      },
      child: Card(
        color: Colors.black,
        elevation: 10,
        shadowColor: Colors.white38,
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          height: widget.itemCounts! * 125,
          child: ListView.builder(
              itemCount: widget.itemCounts,
              itemBuilder: (context, index) {
                Items model = Items.fromJson(
                    widget.data![index].data() as Map<String, dynamic>);
                return placedOrderItemsDesignWidget(
                    model, context, widget.separateQuantityList[index]);
              }),
        ),
      ),
    );
  }
}

Widget placedOrderItemsDesignWidget(
    Items items, BuildContext context, itemQty) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 120,
    color: Colors.transparent,
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Image.network(
            items.thumbnailUrl.toString(),
            width: 120,
          ),
        ),
        sizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        items.itemTitle.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    sizedBox(width: 10),
                    const Text(
                      "N",
                      style: TextStyle(
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      items.price.toString(),
                      style: const TextStyle(
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
                sizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      "x",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      itemQty,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 28),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
