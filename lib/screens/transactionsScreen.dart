import 'package:budge8/components/appButton.dart';
import 'package:budge8/screens/homePageScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'makeTransactionScreen.dart';

class TransactionScreen extends StatefulWidget {
  static String id = 'transactionsScreen';

  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<TransactionScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  List<AppButton> categories = List<AppButton>();
  User loggedInUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser();

    this._fireStore.collection("users").doc(loggedInUser.email).collection("categories").get().then((doc) => {
      this.setState(() {
        for(int i = 0; i < doc.docs.length; i++)
        {
          categories.add(AppButton(colour: Color(0xFF002fff), title: doc.docs[i].id, onPressed: () {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MakeTransactionScreen(categoryName: doc.docs[i].id, categoryLimit: doc.docs[i].data().values.last, currentCategoryAmount: doc.docs[i].data().values.first, userEmail: loggedInUser.email)
                )
            );
          }));
        }
      })
    });
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
            automaticallyImplyLeading: false,
            title: Text('Select a Category to Transact in'
            ),
            backgroundColor: Color(0xFF161d6f),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: categories,
                ),
              ),
            ),
          ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed:  () {
                Navigator.pushNamed(context, HomePageScreen.id );
              },
              label: Text('Done'),
              backgroundColor: Color(0xFF161d6f),
            ),
        ),
      ),
    );
  }
}
