import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:sellers_app/global/global.dart';
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
                SizedBox(height: 12),
                Text(
                  sharedPreferences!.getString("name")!,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12)
              ],
            ),
          ), //body
          Container(
            padding: const EdgeInsets.only(top: 1),
            child: Column(
              children: [
                Divider(height: 10, thickness: 2, color: Colors.grey),

                //Home
                ListTile(
                    leading: Icon(Icons.home, color: Colors.grey),
                    title: Text("Home",
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    onTap: null),

                //My Orders
                Divider(height: 10, thickness: 2, color: Colors.grey),
                ListTile(
                    leading: Icon(Icons.reorder, color: Colors.grey),
                    title: Text("My Orders",
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    onTap: null),
                //Not Yet Received
                Divider(height: 10, thickness: 2, color: Colors.grey),
                ListTile(
                    leading: Icon(Icons.picture_in_picture_alt_rounded,
                        color: Colors.grey),
                    title: Text("Not Yet Received",
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    onTap: null),

                //History
                Divider(height: 10, thickness: 2, color: Colors.grey),
                ListTile(
                    leading: Icon(Icons.access_time, color: Colors.grey),
                    title: Text("History",
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    onTap: null),

                //Search
                Divider(height: 10, thickness: 2, color: Colors.grey),
                ListTile(
                    leading: Icon(Icons.search, color: Colors.grey),
                    title: Text("Search",
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    onTap: null),

                //LogOut
                Divider(height: 10, thickness: 2, color: Colors.grey),
                ListTile(
                    leading: Icon(Icons.exit_to_app, color: Colors.grey),
                    title: Text("LogOut",
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
