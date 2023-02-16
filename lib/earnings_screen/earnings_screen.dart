import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/splashScreen/my_splash_screen.dart';

class EarningsSreen extends StatefulWidget {
  const EarningsSreen({super.key});

  @override
  State<EarningsSreen> createState() => _EarningsSreenState();
}

class _EarningsSreenState extends State<EarningsSreen> {
  String totalEarnings = "";
  readTotalEarnings() async {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snapShot) {
      setState(() {
        totalEarnings = snapShot.data()!['earnings'];
      });
    });
  }

  @override
  void initState() {
    readTotalEarnings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "N ${totalEarnings.toString()}",
                style: const TextStyle(
                    fontSize: 34,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              sizedBox(height: 4),
              const Text(
                "Total Earnings",
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
              sizedBox(height: 6),
              sizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: const Divider(
                  thickness: 4,
                  color: Colors.white60,
                ),
              ),
              sizedBox(height: 60),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MySplashScreen()));
                },
                child: const Card(
                  color: Colors.grey,
                  elevation: 2,
                  margin: EdgeInsets.symmetric(horizontal: 110, vertical: 10),
                  child: ListTile(
                    leading: Icon(Icons.arrow_back, color: Colors.white),
                    title: Text(
                      "Go Back",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                /*  child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  padding: const EdgeInsets.all(8),
                  color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(Icons.arrow_back, color: Colors.white),
                      sizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Go ",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          Text(
                            "Back",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
             */
              )
            ],
          ),
        ),
      ),
    );
  }
}
