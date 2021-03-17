import 'package:budge8/screens/enterSalaryScreen.dart';
import 'package:budge8/screens/startUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePageNoBudgeScreen extends StatefulWidget {
  static String id = 'homePageScreenNoBudge';

  @override
  _HomePageNoBudgeState createState() => _HomePageNoBudgeState();
}

class _HomePageNoBudgeState extends State<HomePageNoBudgeScreen> {
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
            title: Text('Budge8'),
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
                  enabled: false,
                  title: Text('Dashboard'),
                ),
                ListTile(
                  enabled: false,
                  title: Text('My Budget Categories'),
                ),
                ListTile(
                  enabled: false,
                  title: Text('Transact'),
                ),
                ListTile(
                  enabled: false,
                  title: Text('Transact'),
                ),
                ListTile(
                  enabled: false,
                  title: Text('My Financial Goal'),
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
                    'You have not created a budget yet.',
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
                          Navigator.pushNamed(context, EnterSalaryScreen.id);
                        },
                        minWidth: 310.0,
                        height: 42.0,
                        child: Text(
                          'Create a budget',
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
