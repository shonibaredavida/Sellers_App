import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sellers_app/Models/brands_model.dart';
import 'package:sellers_app/Models/items_models.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/items_screens/item_ui_design.dart';
import 'package:sellers_app/items_screens/upload_items_screen.dart';
import 'package:sellers_app/widgets/text_delegate_header_widget.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key, this.model});

  final Brands? model;
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
          StreamBuilder(
            builder: (context, AsyncSnapshot dataSnapShot) {
              if (dataSnapShot.hasData) {
//if there are brands

                if (dev) printo("  getting brands");
                return SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                    staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                    itemBuilder: ((context, index) {
                      Items itemsModel = Items.fromJson(
                          dataSnapShot.data.docs[index].data()
                              as Map<String, dynamic>);
                      return ItemsUIDesignWidget(
                        context: context,
                        model: itemsModel,
                      );
                    }),
                    itemCount: dataSnapShot.data.docs.length);
              } else {
                if (dev) printo("  No brand available");
                //if there are no brands
                return const SliverToBoxAdapter(
                    child: Text(
                  'No Items Added',
                  textAlign: TextAlign.center,
                ));
              }
            },
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(sharedPreferences!.getString("uid"))
                .collection("brands")
                .doc(widget.model!.brandID)
                .collection('items')
                .orderBy("publishedDate", descending: true)
                .snapshots(),
          ),
        ],
      ),
    );
  }
}
