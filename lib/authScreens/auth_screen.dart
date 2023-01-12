import 'package:flutter/material.dart';
import 'package:sellers_app/authScreens/login_tab_page.dart';
import 'package:sellers_app/authScreens/signup_tab_page.dart';

class AuhScreen extends StatefulWidget {
  const AuhScreen({super.key});

  @override
  State<AuhScreen> createState() => _AuhScreenState();
}

class _AuhScreenState extends State<AuhScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            "iShop Sellers app",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.indigoAccent,
                    Colors.grey,
                    Colors.teal,
                    Colors.orange,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  // stops: [0.0, 1.0],  #check
                  tileMode: TileMode.clamp),
            ),
          ),
          bottom: const TabBar(
              indicatorColor: Colors.white54,
              indicatorWeight: 8,
              tabs: [
                Tab(
                    text: "Login",
                    icon: Icon(
                      Icons.lock,
                      color: Colors.white,
                    )),
                Tab(
                    text: "SignUp",
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                    )),
              ]),
        ),
        body: TabBarView(children: [
          const LoginTabPage(),
          SignupTaPage(),
        ]),
      ),
    );
  }
}
