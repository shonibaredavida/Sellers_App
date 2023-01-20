import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sellers_app/Models/brands_model.dart';
import 'package:sellers_app/brandsScreens/brands_ui_design_widget.dart';
import 'package:sellers_app/brandsScreens/upload_brands_screen.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/widgets/my_drawer.dart';
import 'package:sellers_app/widgets/text_delegate_header_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => UploadBrandsScreen()));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            pinned: true,
            delegate: TextDelegateHeaderWidget(title: "My Brands"),
          ),
          StreamBuilder(
            builder: (context, AsyncSnapshot dataSnapShot) {
              if (dataSnapShot.hasData) {
                if (dev) print("WE WE WE WE brands exist");

//if there are brands
                return SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                    staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                    itemBuilder: ((context, index) {
                      if (dev)
                        print("WE WE WE WE Streaming the exisiting brands ");

                      Brands brandsModel = Brands.fromJson(
                          dataSnapShot.data.docs[index].data()
                              as Map<String, dynamic>);
                      return BrandsUIDesignWidget(
                        context: context,
                        model: brandsModel,
                      );
                    }),
                    itemCount: dataSnapShot.data.docs.length);
              } else {
                if (dev) print("WE WE WE WE No Brands Added' ");

                //if there are no brands
                return const SliverToBoxAdapter(
                    child: Text(
                  'No Brands Added',
                  textAlign: TextAlign.center,
                ));
              }
            },
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(sharedPreferences!.getString("uid"))
                .collection("brands")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
          ),
        ],
      ),
    );
  }
}
