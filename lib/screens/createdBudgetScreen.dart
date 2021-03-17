import 'package:budge8/screens/homePageScreen.dart';
import 'package:budge8/screens/startUpScreen.dart';
import 'package:budge8/screens/transactionsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/createdBudgetCategoryItem.dart';
import 'myGoalAfterSetup.dart';
import 'myGoalBeforeSetup.dart';

class CreatedBudgetScreen extends StatefulWidget {
  static String id = 'createdBudgetScreen';
  bool delete = false;
  bool mustAdd = false;
  bool doEdit = false;
  String categoryTitle;
  int salary;
  int categoryLimit;
  int editLimit = 0;
  int editAmount;
  bool mustLogout = false;
  final _formKey = GlobalKey<FormState>();

  @override
  _CreatedBudgetState createState() => _CreatedBudgetState();
}

class _CreatedBudgetState extends State<CreatedBudgetScreen> {
  final _auth = FirebaseAuth.instance;
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textFieldController1 = TextEditingController();
  final _fireStore = FirebaseFirestore.instance;
  List<CreatedBudgetCategoryItem> categories = List<CreatedBudgetCategoryItem>();
  bool mustLogout = false;
  User loggedInUser;


  @override
  void initState() {
    super.initState();

    getCurrentUser();

    this._fireStore.collection("users").doc(loggedInUser.email).collection("categories").get().then((doc) => {
      this.setState(() {
        for(int i = 0; i < doc.docs.length; i++)
        {
          categories.add(new CreatedBudgetCategoryItem(doc.docs[i].id, doc.docs[i].data().values.last, doc.docs[i].data().values.first));
        }
      })
    });

    this._fireStore.collection("users").doc(loggedInUser.email).get().then((doc) async => {
      this.setState(() {
        if(doc.exists){
        widget.salary = doc.data().values.last;
        }
      }),
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
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () { Scaffold.of(context).openDrawer(); },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            title: Text('My Budget Categories'),
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
                    Navigator.pop(context);
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
                  onTap: () async {

                    await this._fireStore.collection("users").doc(loggedInUser.email).collection('goal').doc('Financial Goal').get().then((doc) async => {
                      if(doc.exists){
                        Navigator.pushNamed(context, MyGoalAfterSetup.id),
                      }
                      else{
                        Navigator.pushNamed(context, MyGoalBeforeSetup.id),
                      }
                    });
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
          body: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 155,
                color: Color(0xFF002fff),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '${categories[index].getCategory()}',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Category Limit: ${categories[index].getLimit()}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Amount Spent: ${categories[index].getAmountSpent()}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Remaining Balance: ${categories[index].getRemainingBalance()}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              RaisedButton(
                                child: Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  await _editCategory(context, heading: 'Edit Category');

                                  int newLimit = 0;

                                  if(widget.doEdit)
                                  {
                                    newLimit = newTotalLimit(categories, index, widget.editLimit);
                                  }

                                  if(widget.salary > newLimit){
                                    if(widget.doEdit)
                                    {
                                      await this._fireStore.collection("users").doc(loggedInUser.email).collection("categories").doc('${categories[index].getCategory()}').update({
                                        'categoryLimit': widget.editLimit,
                                        'currentAmount': widget.editAmount,
                                      });

                                      setState(() {
                                        categories[index].setLimit(widget.editLimit);
                                        categories[index].setAmount(widget.editAmount);
                                        categories[index].updateRemaining();
                                      });
                                    }
                                  }
                                  else{
                                    _tooHigh(context);
                                  }
                                },
                                color: Color(0xFF161d6f),
                              ),
                              RaisedButton(
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  await _confirmDelete(context);

                                  setState(() {
                                    if(widget.delete)
                                    {
                                      this._fireStore.collection("users").doc(loggedInUser.email).collection("categories").doc(categories[index].getCategory()).update({
                                        'categoryLimit': FieldValue.delete(),
                                        'currentAmount': FieldValue.delete(),
                                      });

                                      this._fireStore.collection("users").doc(loggedInUser.email).collection("categories").doc(categories[index].getCategory()).delete();

                                      categories.removeAt(index);
                                    }
                                  });
                                },
                                color: Color(0xFFff004c),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),
        ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        heroTag: 'butn3',
                        onPressed: () async {
                          await _addCategory(context,heading: 'New Category');

                          if(widget.mustAdd)
                              {
                              await this._fireStore.collection("users").doc(loggedInUser.email).collection("categories").doc('${widget.categoryTitle}').set({
                                'categoryLimit': widget.categoryLimit,
                                'currentAmount': 0,
                              });


                              setState(() {
                                categories.add(new CreatedBudgetCategoryItem(widget.categoryTitle, widget.categoryLimit, 0));
                              });
                          }
                        },
                        child: const Icon(Icons.add),
                        backgroundColor: Color(0xFF161d6f),
                      ),
                    ]
                )
            ),
      ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Are you sure that you want to delete this category'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    color: Color(0xFF002fff),
                    textColor: Colors.white,
                    child: Text('Cancel'),
                    onPressed: () {
                      widget.delete = false;
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    color: Color(0xFF161d6f),
                    textColor: Colors.white,
                    child: Text('Yes'),
                    onPressed: () {
                      widget.delete = true;
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
          );
        });
  }

  Future<void> _tooHigh(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('If this limit were set, your budget would exceed your salary. Either decrease this or other limits.'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    color: Color(0xFF161d6f),
                    textColor: Colors.white,
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
          );
        });
  }

  Future<void> _addCategory(BuildContext context, {heading: String}) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(heading),
            content: SizedBox(
              height: 140,
              child: Form(
                key: widget._formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'A category title is required';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        widget.categoryTitle = value;
                      },
                      controller: _textFieldController,
                      decoration: InputDecoration(hintText: "Category Title"),
                    ),

                    TextFormField(
                      validator: (value) {
                        Pattern pattern = r"^[0-9]+$";
                        RegExp regex = new RegExp(pattern);
                        if (value.isEmpty) {
                          return 'Entering a limit is required';
                        }

                        if (!regex.hasMatch(value))
                        {
                          return 'Enter only digits';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        if(value != '')
                        {
                          int limit = int.tryParse(value);
                          if(limit != null)
                          {
                            widget.categoryLimit = limit;
                          }
                        }
                      },
                      controller: _textFieldController1,
                      decoration: InputDecoration(hintText: "Category Limit"),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Color(0xFF161d6f),
                textColor: Colors.white,
                child: Text('Cancel'),
                onPressed: () {
                  widget.mustAdd = false;
                  _textFieldController.clear();
                  _textFieldController1.clear();
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                color: Color(0xFF002fff),
                textColor: Colors.white,
                child: Text('Create Category'),
                onPressed: () {
                  if(widget._formKey.currentState.validate())
                    {
                      widget.mustAdd = true;
                      setState(() {
                        _textFieldController.clear();
                        _textFieldController1.clear();
                        Navigator.pop(context);
                      });
                    }

                },
              ),
            ],
          );
        });
  }

  Future<void> _editCategory(BuildContext context, {heading: String}) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(heading),
            content: SizedBox(
              height: 140,
              child: Form(
                key: widget._formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    TextFormField(
                      validator: (value) {
                        Pattern pattern = r"^[0-9]+$";
                        RegExp regex = new RegExp(pattern);
                        if (value.isEmpty) {
                          return 'Entering a limit is required';
                        }

                        if (!regex.hasMatch(value))
                        {
                          return 'Enter only digits';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        if(value != '')
                        {
                          int limit = int.tryParse(value);
                          if(limit != null)
                          {
                            widget.editLimit = limit;
                          }
                        }
                      },
                      controller: _textFieldController,
                      decoration: InputDecoration(hintText: "New Category Limit"),
                    ),

                    TextFormField(
                      validator: (value) {
                        Pattern pattern = r"^[0-9]+$";
                        int amount = int.tryParse(value);
                        RegExp regex = new RegExp(pattern);
                        if (value.isEmpty) {
                          return 'Entering the amount spent is required';
                        }

                        if(amount > widget.editLimit) {
                          return 'Amount Spent should be less than limit';
                        }

                        if (!regex.hasMatch(value))
                        {
                          return 'Enter only digits';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        if(value != '')
                        {
                          int amount = int.tryParse(value);
                          if(amount != null)
                          {
                            widget.editAmount = amount;
                          }
                        }
                      },
                      controller: _textFieldController1,
                      decoration: InputDecoration(hintText: "New Amount Spent"),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Color(0xFF161d6f),
                textColor: Colors.white,
                child: Text('Cancel'),
                onPressed: () {
                  widget.doEdit = false;
                  _textFieldController.clear();
                  _textFieldController1.clear();
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                color: Color(0xFF002fff),
                textColor: Colors.white,
                child: Text('Edit Category'),
                onPressed: () {
                  if(widget._formKey.currentState.validate())
                  {
                    widget.doEdit = true;
                    setState(() {
                      _textFieldController.clear();
                      _textFieldController1.clear();
                      Navigator.pop(context);
                    });
                  }

                },
              ),
            ],
          );
        });
  }

  int newTotalLimit(List<CreatedBudgetCategoryItem> cat, int position, int newLimit) {
    int totalLimit = newLimit;

    for(int i = 0; i < cat.length; i++) {
        if(position == i) {
            continue;
        }

        totalLimit = totalLimit + cat[i].getLimit();
    }
    return totalLimit;
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
