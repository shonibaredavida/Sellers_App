import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellers_app/Models/brands_model.dart';
import 'package:sellers_app/brandsScreens/home_screen.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/splashScreen/my_splash_screen.dart';
import 'package:sellers_app/widgets/progress_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';

class UploadItemsScreen extends StatefulWidget {
  UploadItemsScreen(this.model);
  Brands? model;
  @override
  State<UploadItemsScreen> createState() => _UploadItemsScreenState();
}

class _UploadItemsScreenState extends State<UploadItemsScreen> {
  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();
  TextEditingController? itemInfoController = TextEditingController();
  TextEditingController? itemTitleController = TextEditingController();
  TextEditingController? itemPriceController = TextEditingController();
  TextEditingController? itemDescriptionController = TextEditingController();
  bool uploading = false;
  String downloadUrlImage = "";
  String itemUniqueId = DateTime.now().millisecondsSinceEpoch.toString();

  getImageFromGallery() async {
    Navigator.of(context).pop();
    imgXFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (dev) print("WE WE WE WE WE get Image From Gallery");

    setState(() {
      imgXFile;
    });
  }

  captureImageFromCamera() async {
    if (dev) print("WE WE WE WE WE IMage Captured");
    Navigator.of(context).pop();
    imgXFile = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imgXFile;
    });
  }

  saveItemInfoToFireStoreDB() {
    if (dev) print("saving Item info to related brand collection");
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("brands")
        .doc(widget.model!.brandID)
        .collection("items")
        .doc(itemUniqueId)
        .set({
      "itemID": itemUniqueId,
      "brandID": widget.model!.brandID,
      "sellerName": sharedPreferences!.getString("name"),
      "sellerUID": sharedPreferences!.getString("uid"),
      "itemTitle": itemTitleController!.text.trim(),
      "itemInfo": itemInfoController!.text,
      "price": itemPriceController!.text,
      "longDescription": itemDescriptionController!.text,
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrlImage,
    }).then((value) {
      if (dev) print("saving Item info to items collection");
      FirebaseFirestore.instance.collection("items").doc(itemUniqueId).set({
        "itemID": itemUniqueId,
        "brandID": widget.model!.brandID,
        "sellerName": sharedPreferences!.getString("name"),
        "sellerUID": sharedPreferences!.getString("uid"),
        "itemTitle": itemTitleController!.text.trim(),
        "itemInfo": itemInfoController!.text,
        "price": itemPriceController!.text,
        "longDescription": itemDescriptionController!.text,
        "publishedDate": DateTime.now(),
        "status": "available",
        "thumbnailUrl": downloadUrlImage,
      });
    });

    setState(() {
      uploading = false;
    });
    if (dev) print("WE WE WE WE WE save item Info To FireStore DB");
    Navigator.push(
        context, MaterialPageRoute(builder: (c) => const HomeScreen()));
  }

  validateItemUploadform() async {
    //image has been seleted
    if (imgXFile != null) {
      if (itemInfoController!.text.isNotEmpty &&
          itemTitleController!.text.isNotEmpty &&
          itemPriceController!.text.isNotEmpty &&
          itemDescriptionController!.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });
        //1 start upload of image n download imageUrl
        if (dev) print(" WE WE WE WE getting the url");
        String filename = DateTime.now().microsecondsSinceEpoch.toString();
        if (dev) print(" WE WE WE WE getting the filenme");
        fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
            .ref()
            .child("sellersItemImages")
            .child(filename);
        if (dev) print(" WE WE WE WE creating storageRef");
        fStorage.UploadTask uploadImageTask =
            storageRef.putFile(File(imgXFile!.path));
        if (dev) print(" WE WE WE WE uploadtask");
        fStorage.TaskSnapshot taskSnapshot =
            await uploadImageTask.whenComplete(() {
          if (dev) print(" WE WE WE WE finish taskSnapshot");
        });
        await taskSnapshot.ref.getDownloadURL().then((urlImage) {
          downloadUrlImage = urlImage;
          if (dev) print(" WE WE WE WE gotten the url $downloadUrlImage");
        });
        if (dev) print(" WE WE WE WE going to firetore");
        //2 save item info to firestore
        saveItemInfoToFireStoreDB();
        //3 store the item locally
        sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences!
            .setString("itemInfo", itemInfoController!.text.trim());
        await sharedPreferences!
            .setString("itemTitle", itemTitleController!.text.trim());
        await sharedPreferences!.setString("thumbnailUrl", downloadUrlImage);
        if (dev) print("WE WE WE WE WE save to Device");
      } else {
        //form is not completely filled
        Fluttertoast.showToast(msg: "Pls fill form");
      }
    } else {
      Fluttertoast.showToast(msg: "please Select a Pix");
    }
  }

  BoxDecoration boxDecorationForAddingItem() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.pinkAccent,
          Colors.purpleAccent,
        ],
        begin: FractionalOffset(0.0, 0.0),
        end: FractionalOffset(1, 0),
        stops: [0, 0],
        tileMode: TileMode.clamp,
      ),
    );
  }

  uploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
                onPressed: () {
                  //validate the form
                  uploading == true ? null : validateItemUploadform();
                },
                icon: const Icon(Icons.cloud_upload)),
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MySplashScreen(),
              ),
            );
          },
        ),
        flexibleSpace: Container(
          decoration: boxDecorationForAddingItem(),
        ),
        title: const Text("Upload New Item"),
        centerTitle: true,
      ),
      body: ListView(children: [
        uploading == true ? linearProgressIndicator() : Container()

        //image
        ,
        SizedBox(
          height: 220,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  File(imgXFile!.path),
                ),
              ),
            ),
          ),
        ),
        const Divider(
          color: Colors.pinkAccent,
          thickness: 1,
        ),
        ListTile(
          leading: const Icon(
            Icons.title,
            color: Colors.purple,
          ),
          title: SizedBox(
            width: 250,
            child: TextField(
              controller: itemTitleController,
              decoration: const InputDecoration(
                  hintText: "Item Title",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none),
            ),
          ),
        ),
        const Divider(
          color: Colors.pinkAccent,
          thickness: 1,
        ),
        ListTile(
          leading: const Icon(
            Icons.perm_device_info_outlined,
            color: Colors.purple,
          ),
          title: SizedBox(
            width: 250,
            child: TextField(
              controller: itemInfoController,
              decoration: const InputDecoration(
                  hintText: "Item Info",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none),
            ),
          ),
        ),
        const Divider(
          color: Colors.pinkAccent,
          thickness: 1,
        ),
        ListTile(
          leading: const Icon(
            Icons.camera,
            color: Colors.purple,
          ),
          title: SizedBox(
            width: 250,
            child: TextField(
              controller: itemPriceController,
              decoration: const InputDecoration(
                  hintText: "Item Price",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none),
            ),
          ),
        ),
        const Divider(
          color: Colors.pinkAccent,
          thickness: 1,
        ),
        ListTile(
          leading: const Icon(
            Icons.description,
            color: Colors.purple,
          ),
          title: SizedBox(
            width: 250,
            child: TextField(
              controller: itemDescriptionController,
              decoration: const InputDecoration(
                  hintText: "Item Description",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none),
            ),
          ),
        ),
      ]),
    );
  }

  defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: boxDecorationForAddingItem(),
        ),
        title: const Text("Add New Item"),
        centerTitle: true,
      ),
      body: Container(
        decoration: boxDecorationForAddingItem(),
        child: Center(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_photo_alternate,
                  color: Colors.white,
                  size: 200,
                ),
                ElevatedButton(
                  onPressed: () {
                    obtainImageDialogBox(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Add New Item"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  obtainImageDialogBox(context) {
    return showDialog(
        context: context,
        builder: (c) {
          return SimpleDialog(
            title: const Text(
              "Item Image",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            alignment: Alignment.center,
            children: [
              SimpleDialogOption(
                child: const Text(
                  "Capture Image with Camera",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  captureImageFromCamera();
                },
              ),
              SimpleDialogOption(
                child: const Text(
                  "Select Image from Gallery",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  getImageFromGallery();
                },
              ),
              SimpleDialogOption(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {},
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return imgXFile == null ? defaultScreen() : uploadFormScreen();
  }
}
