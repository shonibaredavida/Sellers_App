import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/splashScreen/my_splash_screen.dart';
import 'package:sellers_app/widgets/custom_text_field.dart';
import 'package:sellers_app/widgets/loading_dialog.dart';

class LoginTabPage extends StatefulWidget {
  const LoginTabPage({super.key});

  @override
  State<LoginTabPage> createState() => _LoginTabPageState();
}

class _LoginTabPageState extends State<LoginTabPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  validateForm() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      loginnow();
    } else if (emailController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Kindly enter your email");
    } else if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "KIindly enter your password");
    } else {
      Fluttertoast.showToast(
          msg: "Kindly enter your email and password details");
    }
  }

  loginnow() async {
    User? currentSeller;
    showDialog(
        context: context,
        builder: (c) => const LoadingDialogWidget(
              message: "Checking your credentials ",
            ));

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((auth) => currentSeller = auth.user)
        .catchError((errorMessage) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "Error occured \n $errorMessage");
    });
    if (currentSeller != null) {
      checkIfSellerRecordExist(currentSeller);
    }
  }

  checkIfSellerRecordExist(currentSeller) async {
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(currentSeller.uid)
        .get()
        .then((record) async {
      if (record.exists) {
        //Seller record exist
        if (record.data()!["status"] == "approved") {
          //Seller record is approved to login in
          await sharedPreferences!.setString("uid", record.data()!["uid"]);
          await sharedPreferences!.setString("email", record.data()!["email"]);
          await sharedPreferences!.setString("name", record.data()!["name"]);
          await sharedPreferences!
              .setString("photoUrl", record.data()!["photoUrl"]);
          await sharedPreferences!
              .setString("address", record.data()!["address"]);
          await sharedPreferences!
              .setDouble("earnings", record.data()!["earnings"]);

          //send the seller to home screen
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MySplashScreen()));
        } else {
          //seller have been BLOCKED by Admin \n contact amin@weshop.com
          FirebaseAuth.instance.signOut();
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "You have been BLOCKED by Admin \n contact amin@weshop.com");
        }
      } else {
        //seller record doesnt exist
        FirebaseAuth.instance.signOut();
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "This Seller doesnt exist, Pls Signup ");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      color: const Color.fromARGB(91, 167, 156, 156),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.20,
              child: Image.asset("images/seller.png"),
            ),
            const SizedBox(height: 30),
            Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextField(
                      emailController, Icons.email, false, true, "Email"),
                  CustomTextField(
                      passwordController, Icons.lock, true, true, "Password"),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
              ),
              onPressed: () {
                validateForm();
              },
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
