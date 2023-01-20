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
      if (dev) print('WE WE WE WE initiating login ');
      loginnow();
    } else if (emailController.text.isEmpty) {
      if (dev) print('WE WE WE WE form validation-- kindly enter mail ');
      Fluttertoast.showToast(msg: "Kindly enter your email");
    } else if (passwordController.text.isEmpty) {
      if (dev) print('WE WE WE WE form validation-- kindly enter password ');
      Fluttertoast.showToast(msg: "KIindly enter your password");
    } else {
      if (dev)
        print('WE WE WE WE form validation-- kindly enter mail n password ');
      Fluttertoast.showToast(
          msg: "Kindly enter your email and password details");
    }
  }

  loginnow() async {
    User? currentSeller;

    if (dev)
      print(
          'WE WE WE WE form loginning--- Checking your credentials from firebse');
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
      if (dev) print('WE WE WE WE Checking your credentials..error occured');

      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "Error occured \n $errorMessage");
    });
    if (currentSeller != null) {
      if (dev) print('WE WE WE WE Checking your credentials.. found user');

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
        if (dev) print('WE WE WE WE Checking your credentials.. found record');

        if (record.data()!["status"] == "approved") {
          //Seller record is approved to login in
          if (dev) print('WE WE WE WE approved user record saved to device');

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

          if (dev) print('WE WE WE WE routing to MySplashScreen');
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MySplashScreen()));
        } else {
          //seller have been BLOCKED by Admin \n contact amin@weshop.com
          if (dev)
            print('WE WE WE WE user is blocked..\n routing to authScreen');

          FirebaseAuth.instance.signOut();
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "You have been BLOCKED by Admin \n contact amin@weshop.com");
        }
      } else {
        //seller record doesnt exist
        if (dev)
          print('WE WE WE WE  This Seller doesnt exist. routing to authScreen');
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
                if (dev) print('WE WE WE WE initiating the form validation ');
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
