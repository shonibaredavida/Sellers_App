import 'package:cloud_firestore/cloud_firestore.dart';

class Items {
  String? itemID;
  String? brandID;
  String? sellerName;
  String? sellerUID;
  String? itemTitle;
  String? itemInfo;
  String? price;
  String? longDescription;
  Timestamp? publishedDate;
  String? status;
  String? thumbnailUrl;

  Items({
    this.brandID,
    this.itemID,
    this.itemInfo,
    this.itemTitle,
    this.longDescription,
    this.price,
    this.publishedDate,
    this.sellerName,
    this.sellerUID,
    this.status,
    this.thumbnailUrl,
  });

  Items.fromJson(Map<String, dynamic> json) {
    brandID = json['brandID'];
    itemID = json['itemID'];
    itemInfo = json['itemInfo'];
    itemTitle = json['itemTitle'];
    longDescription = json['longDescription'];
    price = json['price'];
    publishedDate = json['publishedDate'];
    sellerName = json['sellerName'];
    sellerUID = json['sellerUID'];
    status = json['status'];
    thumbnailUrl = json['thumbnailUrl'];
  }
}
