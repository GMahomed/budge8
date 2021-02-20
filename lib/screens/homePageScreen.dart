import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePageScreen extends StatefulWidget {
  static String id = 'homePageScreen';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageScreen> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser(){
    try{
      final user = _auth.currentUser;
      if(user != null)
      {
        loggedInUser = user;
      }
    }
    catch(e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('You have logged in'),
        backgroundColor: Color(0xFFDA9FF9),
      ),

      bottomNavigationBar: BottomAppBar(
        color: Color(0xFFDA9FF9),
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.home_filled),
                onPressed: () {

                },
            ),
            Spacer(),
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
