import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/splashScreen/my_splash_screen.dart';
import 'package:sellers_app/widgets/custom_text_field.dart';
import 'package:sellers_app/widgets/loading_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as f_storage;

class SignupTaPage extends StatefulWidget {
  const SignupTaPage({super.key});

  @override
  State<SignupTaPage> createState() => _SignupTaPageState();
}

class _SignupTaPageState extends State<SignupTaPage> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String downloadUrlImage = "";
  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();
  bool dev = true;

  getImageFromGallery() async {
    imgXFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgXFile;
    });
  }

  saveInfoToFireStoreAndLocally(User currentUser) async {
// save to firestore

    FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).set({
      "uid": currentUser.uid,
      "email": currentUser.email,
      "name": namecontroller.text.trim(),
      "photoUrl": downloadUrlImage,
      "phone": phoneController.text.trim(),
      "address": locationController.text.trim(),
      "earnings": 0.0,
      "status": "approved",
    });
    if (dev) printo(" saving to firebase");
// save locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email!);
    await sharedPreferences!.setString("name", namecontroller.text.trim());
    await sharedPreferences!.setString("photoUrl", downloadUrlImage).then(
        (value) => Navigator.push(context,
            MaterialPageRoute(builder: (c) => const MySplashScreen())));

    if (dev) printo(" saving locally & redirecting to MySplashScreen");
// route to home page
  }

  saveInformationToDatabase(email, password) async {
    //authenticating the user using firebase
    if (dev) printo(" creating user");

    User? currentSeller;
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((auth) {
      currentSeller = auth.user;
    }).catchError((errorMessage) {
      if (dev) printo(" creating user-- error occured");

      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "Error Occured: \n $errorMessage");
    });

    if (currentSeller != null) {
      if (dev) printo(" logged in");
      //save the user information to Database n save locally
      saveInfoToFireStoreAndLocally(currentSeller!);
    }
  }

  formValidation() async {
    if (imgXFile == null) // no image selected
    {
      if (dev) printo(' SELECT pix');
      Fluttertoast.showToast(msg: "Pls Select an Image");
    } else {
      if (emailController.text.isNotEmpty &&
          locationController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          namecontroller.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        if (dev) printo(' form filled ');
        // email n name, password, confirmatio n given
        if (passwordController.text == confirmPasswordController.text) {
          //password n confirmation field are same
          if (dev) printo(' password == confirmPassword');

          showDialog(
              context: context,
              builder: (c) {
                return const LoadingDialogWidget(
                  message: "Registering your Account",
                );
              });
          //1~ uploading pix and downloading Pix URL,
          String filename = DateTime.now().microsecondsSinceEpoch.toString();
          f_storage.Reference storageRef = f_storage.FirebaseStorage.instance
              .ref()
              .child("sellersImage")
              .child(filename);
          f_storage.UploadTask uploadImageTask =
              storageRef.putFile(File(imgXFile!.path));
          f_storage.TaskSnapshot taskSnapshot =
              await uploadImageTask.whenComplete(() => null);
          await taskSnapshot.ref.getDownloadURL().then((urlImage) {
            downloadUrlImage = urlImage;
          });
          if (dev) printo("  linking to firebase");

          //2~  Upload user info to firebase
          saveInformationToDatabase(
              emailController.text.trim(), passwordController.text.trim());
        } else {
          // password n confirmation field are not match
          Fluttertoast.showToast(
              msg: "Password and Password Confirmaion do not match");
        }
      } else {
        //either email n name, password, confirmatio isnt given
        Fluttertoast.showToast(msg: "kindly complete the form");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      color: const Color.fromARGB(91, 167, 156, 156),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: 12),
          // get pix
          GestureDetector(
            onTap: (() {
              getImageFromGallery();
            }),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              radius: MediaQuery.of(context).size.width * 0.23,
              backgroundImage:
                  imgXFile == null ? null : FileImage(File(imgXFile!.path)),
              child: imgXFile == null
                  ? Icon(
                      Icons.add_photo_alternate,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.width * 0.2,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          //input Field
          Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextField(
                      namecontroller, Icons.person, false, true, "Name"),
                  CustomTextField(
                      emailController, Icons.email, false, true, "Email"),
                  CustomTextField(
                      passwordController, Icons.lock, true, true, "Password"),
                  CustomTextField(confirmPasswordController, Icons.lock, true,
                      true, "Confirm Password"),
                  CustomTextField(
                      phoneController, Icons.lock, false, true, "Phone Number"),
                  CustomTextField(
                      locationController, Icons.lock, false, true, "Address"),
                  const SizedBox(height: 20),
                ],
              )),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
            ),
            onPressed: () {
              formValidation();
            },
            child: const Text(
              "Signup",
              style: TextStyle(color: Colors.white),
            ),
          )
        ]),
      ),
    );
  }
}
