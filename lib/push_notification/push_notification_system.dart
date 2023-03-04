import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sellers_app/functions/functions.dart';
import 'package:sellers_app/global/global.dart';

class PushNotifcationsSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //3 possible scenarios when notification is received
  Future whenNotficationIsReceived(context) async {
    //1. terminated
    //when app is completely closed & PNS opens app..
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        // when open then show Notification data

        showNotificationWhenOpenApp(remoteMessage.data['userOrderId'], context);
      }
    });

    //2. foreground
    //when app is opened but its currently in used..
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //show notificaton data immediately on app
        showNotificationWhenOpenApp(remoteMessage.data['userOrderId'], context);
      }
    });

    //3.  background (minimized)
    //when app is opened but its not currently in used..
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //switches to the app and shows the notification
        showNotificationWhenOpenApp(remoteMessage.data['userOrderId'], context);
      }
    });
  }

  //device recognition token
  showNotificationWhenOpenApp(orderId, context) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .get()
        .then((snapshot) {
      if (snapshot.data()!['status'] == 'ended') {
        showReusableSnackBar(
            "Order ID # $orderId\n\n has been delivered & received by the user",
            context);
      } else {
        showReusableSnackBar(
            "you have new Order. \nOrder ID # $orderId\n\n has delivered & received by the user",
            context);
      }
    });
  }

  Future generateDeviceRecognitionToken() async {
    String? registrationDeviceToken = await messaging.getToken();
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .update({"sellerDeviceToken": registrationDeviceToken}).whenComplete(
            () {
      if (dev) printo("Seller token $registrationDeviceToken");
    });
    messaging.subscribeToTopic("allSellers");
    messaging.subscribeToTopic("allUsers");
  }
}

notificationFormat(
    {String? userDeviceToken,
    String? orderId,
    String? notificationBody,
    String? notificationTitle}) {
  Map<String, String> hearderNotification = {
     'Content-Type': 'application/json',
    'Authorization': fcmServerToken
  };

  Map bodyNotification = {'body': notificationBody, 'title': notificationTitle};
  Map dataMap = {
    'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    'id': '1',
    "status": 'done',
    'orderId': orderId,
  };
  Map officialNotificationFormat = {
    'notification': bodyNotification,
    'data': dataMap,
    'priority': 'high',
    'to': userDeviceToken,
  };
  http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: hearderNotification,
      body: jsonEncode(officialNotificationFormat));
}
