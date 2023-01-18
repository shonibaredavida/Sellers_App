import 'package:flutter/material.dart';
import 'package:sellers_app/Models/brands_model.dart';
import 'package:sellers_app/items_screens/upload_items_screen.dart';
import 'package:sellers_app/widgets/text_delegate_header_widget.dart';

class ItemsScreen extends StatefulWidget {
  ItemsScreen({this.model});
  Brands? model;
  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => UploadItemsScreen(widget.model)));
              },
              icon: const Icon(
                Icons.add_box_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextDelegateHeaderWidget(
                title: "My ${widget.model!.brandTitle.toString()} Items"),
          ),
        ],
      ),
    );
  }
}
