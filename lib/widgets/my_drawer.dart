import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:sellers_app/brandsScreens/home_screen.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/orders_screen/orders_screen.dart';
import 'package:sellers_app/splashScreen/my_splash_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black54,
      child: ListView(
        children: [
          //header
          Container(
            padding: const EdgeInsets.only(
              top: 26,
              bottom: 12,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 130,
                  width: 130,
                  child: CircleAvatar(
                    radius: 65,
                    foregroundImage:
                        NetworkImage(sharedPreferences!.getString("photoUrl")!),
                  ),
                ),
                sizedBox(height: 12),
                Text(
                  sharedPreferences!.getString("name")!,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                sizedBox(height: 12)
              ],
            ),
          ), //body
          Container(
            padding: const EdgeInsets.only(top: 1),
            child: Column(
              children: [
                const Divider(height: 10, thickness: 2, color: Colors.grey),

                //Home
                ListTile(
                    leading: const Icon(Icons.home, color: Colors.grey),
                    title: const Text("Home",
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    }),

                //My Orders
                const Divider(height: 10, thickness: 2, color: Colors.grey),
                ListTile(
                    leading: const Icon(Icons.reorder, color: Colors.grey),
                    title: const Text("New Orders",
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OrdersScreen()));
                    }),
                //Not Yet Received
                const Divider(height: 10, thickness: 2, color: Colors.grey),
                const ListTile(
                    leading: Icon(Icons.picture_in_picture_alt_rounded,
                        color: Colors.grey),
                    title: Text("Not Yet Received",
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    onTap: null),

                //History
                const Divider(height: 10, thickness: 2, color: Colors.grey),
                const ListTile(
                    leading: Icon(Icons.access_time, color: Colors.grey),
                    title: Text("History",
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    onTap: null),

                //Search
                const Divider(height: 10, thickness: 2, color: Colors.grey),
                const ListTile(
                    leading: Icon(Icons.search, color: Colors.grey),
                    title: Text("Search",
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    onTap: null),

                //LogOut
                const Divider(height: 10, thickness: 2, color: Colors.grey),
                ListTile(
                    leading: const Icon(Icons.exit_to_app, color: Colors.grey),
                    title: const Text("LogOut",
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MySplashScreen()));
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
