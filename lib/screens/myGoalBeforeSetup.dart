import 'package:budge8/screens/homePageScreen.dart';
import 'package:budge8/screens/myGoalSetupScreen.dart';
import 'package:budge8/screens/startUpScreen.dart';
import 'package:budge8/screens/transactionsScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'createdBudgetScreen.dart';

class MyGoalBeforeSetup extends StatefulWidget {
  static String id = 'myGoalBeforeSetup';

  @override
  _MyGoalBeforeSetupState createState() => _MyGoalBeforeSetupState();
}

class _MyGoalBeforeSetupState extends State<MyGoalBeforeSetup> {
  final _auth = FirebaseAuth.instance;
  bool mustLogout = false;
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
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Center(
        child: Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () { Scaffold.of(context).openDrawer(); },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            title: Text('My Financial Goal'),
            backgroundColor: Color(0xFF161d6f),
          ),

          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Center(
                    child: Text(
                        loggedInUser.email,
                        style: TextStyle(color: Colors.white)
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF002fff),
                  ),
                ),
                ListTile(
                  title: Text('Dashboard'),
                  onTap: () {
                    Navigator.pushNamed(context, HomePageScreen.id);
                  },
                ),
                ListTile(
                  title: Text('My Budget Categories'),
                  onTap: () {
                    Navigator.pushNamed(context, CreatedBudgetScreen.id);
                  },
                ),
                ListTile(
                  title: Text('Transact'),
                  onTap: () {
                    Navigator.pushNamed(context, TransactionScreen.id);
                  },
                ),
                ListTile(
                  title: Text('My Financial Goal'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Logout'),
                  onTap: () async{
                    await  _confirmLogout(context);

                    if(mustLogout == true){
                      await _auth.signOut();
                      Navigator.pushNamedAndRemoveUntil(context, StartUpScreen.id, (route) => false);
                    }
                  },
                ),
              ],
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'You have not set a financial goal yet.',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    color: Color(0xFF002fff),
                    borderRadius: BorderRadius.circular(15.0),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: (){
                        Navigator.pushNamed(context, MyGoalSetupScreen.id);
                      },
                      minWidth: 325.0,
                      height: 42.0,
                      child: Text(
                        'Set a Goal',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Are you sure you want to logout?'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    color: Color(0xFF002fff),
                    textColor: Colors.white,
                    child: Text('No'),
                    onPressed: () {
                      mustLogout = false;
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    color: Color(0xFF161d6f),
                    textColor: Colors.white,
                    child: Text('Yes'),
                    onPressed: () {
                      mustLogout = true;
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
          );
        });
  }
}
