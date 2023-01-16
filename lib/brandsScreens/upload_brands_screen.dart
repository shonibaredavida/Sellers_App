import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellers_app/brandsScreens/home_screen.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/splashScreen/my_splash_screen.dart';
import 'package:sellers_app/widgets/progress_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';

class UploadBrandsScreen extends StatefulWidget {
  UploadBrandsScreen({Key? key}) : super(key: key);

  @override
  State<UploadBrandsScreen> createState() => _UploadBrandsScreenState();
}

class _UploadBrandsScreenState extends State<UploadBrandsScreen> {
  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();
  TextEditingController? brandInfoController = TextEditingController();
  TextEditingController? brandTitleController = TextEditingController();
  bool uploading = false;
  String downloadUrlImage = "";
  bool dev = false;
  String brandUniqueId = DateTime.now().millisecondsSinceEpoch.toString();

  getImageFromGallery() async {
    Navigator.of(context).pop();
    imgXFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgXFile;
    });
  }

  captureImageFromCamera() async {
    Navigator.of(context).pop();
    imgXFile = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imgXFile;
    });
  }

  saveBrandInfoToFireStoreDB() async* {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("brands")
        .doc(brandUniqueId)
        .set({
      "brandID": brandUniqueId,
      "sellerUID": sharedPreferences!.getString("uid"),
      "brandTitle": brandTitleController!.text.trim(),
      "brandInfo": brandInfoController!.text.trim(),
      "publishedDate": DateTime.now(),
      "status": "available",
      "ThumbnailUrl": downloadUrlImage,
    });

    setState(() {
      uploading = false;
      brandUniqueId = DateTime.now().millisecondsSinceEpoch.toString();
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (c) => const HomeScreen()));
  }

  validateUploadform() async {
    //image has been seleted
    if (imgXFile != null) {
      if (brandInfoController!.text.isNotEmpty &&
          brandTitleController!.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });
        //1 start upload of image n download imageUrl
        String filename = DateTime.now().microsecondsSinceEpoch.toString();
        fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
            .ref()
            .child("sellersBrandsImages")
            .child(filename);
        fStorage.UploadTask uploadImageTask =
            storageRef.putFile(File(imgXFile!.path));
        fStorage.TaskSnapshot taskSnapshot =
            await uploadImageTask.whenComplete(() => null);
        await taskSnapshot.ref.getDownloadURL().then((urlImage) {
          downloadUrlImage = urlImage;
        });
        if (dev) print("saving to db");

        //2 save brand info to firestore
        saveBrandInfoToFireStoreDB();
        //3 store the brand locally
        sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences!
            .setString("brandInfo", brandInfoController!.text.trim());
        await sharedPreferences!
            .setString("brandTitle", brandTitleController!.text.trim());
        await sharedPreferences!.setString("ThumbnailUrl", downloadUrlImage);
      } else if (brandInfoController!.text.isEmpty &&
          brandTitleController!.text.isEmpty) {
        //form is empty
        Fluttertoast.showToast(msg: "Pls enter Brand Title & Information");
      } else if (brandInfoController!.text.isEmpty) {
        //only brand title supplied
        Fluttertoast.showToast(msg: "Pls inter a Brand Information");
      } else {
        //only brand info supplied
        Fluttertoast.showToast(msg: "Pls inter a Brand Title");
      }
    } else {
      Fluttertoast.showToast(msg: "plsese Select a Pix");
    }
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
                  uploading == true ? null : validateUploadform();
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
          decoration: boxDecorationForAddingBrand(),
        ),
        title: const Text("Upload New Brand"),
        centerTitle: true,
      ),
      body: ListView(children: [
        uploading == true ? linearProgressIndicator() : Container(),

        //image
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
              controller: brandTitleController,
              decoration: const InputDecoration(
                  hintText: "Brand Title",
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
              controller: brandInfoController,
              decoration: const InputDecoration(
                  hintText: "brand Info",
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
          decoration: boxDecorationForAddingBrand(),
        ),
        title: const Text("Add New Brand"),
        centerTitle: true,
      ),
      body: Container(
        decoration: boxDecorationForAddingBrand(),
        child: Center(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_photo_alternate_outlined,
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
                  child: const Text("Add New Brand"),
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
              "Brand Image",
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

  BoxDecoration boxDecorationForAddingBrand() {
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

  @override
  Widget build(BuildContext context) {
    return imgXFile == null ? defaultScreen() : uploadFormScreen();
  }
}
