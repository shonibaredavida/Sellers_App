import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sellers_app/global/global.dart';

class PushNotifcationsSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  //device recognition token
  Future generateDeviceRecognitionToken() async {
    String? registrationDeviceToken = await messaging.getToken();
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .update({"sellerDeviceToken": registrationDeviceToken}).whenComplete(
            () {
      if (dev) printo("Seller token $registrationDeviceToken");
    });
    //   messaging.subscribeToTopic("allSellers");
    // messaging.subscribeToTopic("allUsers");
  }
}
