import 'package:budge8/components/deleteButton.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:budge8/components/appButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homePageScreen.dart';
import 'enterCategoryValues.dart';
import '../components/categoryLimits.dart';

class BudgetSetupScreen extends StatefulWidget {
  static String id = 'BudgetSetupScreen';
  List categoryLimits = List<CategoryLimits>();
  bool limitsExceedSalary = false;
  int totalLimits = 0;
  int salary = 0;

  BudgetSetupScreen({this.categoryLimits, this.salary});

  @override
  _BudgetSetupScreenState createState() => _BudgetSetupScreenState();

  int totalLimit()
  {
    int totalLimit = 0;
    for(int i = 0; i < categoryLimits.length; i++)
      {
        totalLimit = totalLimit + categoryLimits[i].getLimit();
      }

    return totalLimit;
  }
}

class _BudgetSetupScreenState extends State<BudgetSetupScreen> {
  final _fireStore = FirebaseFirestore.instance;
  TextEditingController _textFieldController = TextEditingController();
  String codeDialog;
  bool created = false;
  String valueText;
  List categories = List<Widget>();
  List limitAndCategory = [];
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  int ind = 0;

  @override
  void initState() {
    super.initState();

    getCurrentUser();

    if(widget.categoryLimits.length == 0) {
        widget.categoryLimits.add(new CategoryLimits('Housing Cost'));

        categories.add(
            Row(
              children: [
                AppButton(colour: Color(0xFF002fff), title: 'Housing Cost', onPressed: () {
                  limitAndCategory = [widget.categoryLimits, 'Housing Cost', widget.salary];
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EnterCategoryValuesScreen(limitAndCategory: limitAndCategory)
                      )
                  );
                }),
                SizedBox(
                  width: 8.0,
                ),
                DeleteButton(colour: Color(0xFF002fff), title: 'Delete Category', categories: categories, categoryLimits: widget.categoryLimits, state: this, index: this.ind++),
              ],
            )
        );

        widget.categoryLimits.add(new CategoryLimits('Transportation'));

        categories.add(
            Row(
              children: [
                AppButton(colour: Color(0xFF002fff), title: 'Transportation', onPressed: () {
                  limitAndCategory = [widget.categoryLimits, 'Transportation', widget.salary];
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EnterCategoryValuesScreen(limitAndCategory: limitAndCategory)
                      )
                  );
                }),
                SizedBox(
                  width: 8.0,
                ),
                DeleteButton(colour: Color(0xFF002fff), title: 'Delete Category', categories: categories, categoryLimits: widget.categoryLimits, state: this, index: this.ind++)
              ],
            )
        );

        widget.categoryLimits.add(new CategoryLimits('Food'));

        categories.add(
            Row(
              children: [
                AppButton(colour: Color(0xFF002fff), title: 'Food', onPressed: () {
                  limitAndCategory = [widget.categoryLimits, 'Food', widget.salary];
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EnterCategoryValuesScreen(limitAndCategory: limitAndCategory)
                      )
                  );
                }),
                SizedBox(
                  width: 8.0,
                ),
                DeleteButton(colour: Color(0xFF002fff), title: 'Delete Category', categories: categories, categoryLimits: widget.categoryLimits, state: this, index: this.ind++),
              ],
            )
        );

        widget.categoryLimits.add(new CategoryLimits('Savings'));

        categories.add(
            Row(
              children: [
                AppButton(colour: Color(0xFF002fff), title: 'Savings', onPressed: () {
                  limitAndCategory = [widget.categoryLimits, 'Savings', widget.salary];
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EnterCategoryValuesScreen(limitAndCategory: limitAndCategory)
                      )
                  );
                }),
                SizedBox(
                  width: 8.0,
                ),
                DeleteButton(colour: Color(0xFF002fff), title: 'Delete Category', categories: categories, categoryLimits: widget.categoryLimits, state: this, index: this.ind++),
              ],
            )
        );

        widget.categoryLimits.add(new CategoryLimits('Leisure'));

        categories.add(
            Row(
              children: [
                AppButton(colour: Color(0xFF002fff), title: 'Leisure', onPressed: () {
                  limitAndCategory = [widget.categoryLimits, 'Leisure', widget.salary];
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EnterCategoryValuesScreen(limitAndCategory: limitAndCategory)
                      )
                  );
                }),
                SizedBox(
                  width: 8.0,
                ),
                DeleteButton(colour: Color(0xFF002fff), title: 'Delete Category', categories: categories, categoryLimits: widget.categoryLimits, state: this, index: this.ind++),
              ],
            )
        );
      } else{
        for(int i = 0; i < widget.categoryLimits.length; i++)
          {
            if(widget.categoryLimits[i].isNotEmpty()) {
              addCategory(widget.categoryLimits[i].getCategory());
              this.ind++;
            }
            else{
              categories.add(Row());
              ind++;
            }
          }
    }
    widget.totalLimits = widget.totalLimit();

    if(widget.totalLimits > widget.salary)
      {
        widget.limitsExceedSalary = true;
      }

  }

  void getCurrentUser(){
    try{
      final user = _auth.currentUser;
      if(user != null) {
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Set Up Categories'),
          backgroundColor: Color(0xFF161d6f),
        ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: categories,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            FloatingActionButton.extended(
              heroTag: 'butn1',
              onPressed: () async {

                if(widget.limitsExceedSalary == false){
                  for(int i = 0; i < categories.length; i++)
                  {
                    if(categories[i].children.length > 0)
                    {
                      await this._fireStore.collection("users").doc(loggedInUser.email).collection("categories").doc('${categories[i].children[0].title}').set({
                        'categoryLimit': widget.categoryLimits[i].getLimit(),
                        'currentAmount': 0,
                      });
                    }

                  }

                  await this._fireStore.collection("users").doc(loggedInUser.email).get().then((doc) async => {
                    if(doc.exists){
                      if(doc.data().values.first == false) {
                        await this._fireStore.collection("users").doc(loggedInUser.email).update({
                          'budgetSetup' : true,
                        }),
                      }
                    }
                  });
                  Navigator.pushNamed(context, HomePageScreen.id);
                } else{
                  _limitsTooHigh(context);
                }
              },
              label: Text('Save'),
              backgroundColor: Color(0xFF161d6f),
            ),
            FloatingActionButton.extended(
              heroTag: 'butn2',
              onPressed:  () async {

                await _displayTextInputDialog(context, heading: 'New Category Name');

                setState(() {

                  if(created)
                  {
                    addCategory(codeDialog);
                    this.ind++;
                    created = false;
                  }
                });
              },
              label: Text('Add Category'),
              backgroundColor: Color(0xFF161d6f),
            ),
      ]
    )
      )

    );
  }
  void addCategory(String buttonTittle)
  {
    if(widget.categoryLimits.length == categories.length) {
      widget.categoryLimits.add(new CategoryLimits('$buttonTittle'));
    }
    categories.add(
        Row(
          children: [
            AppButton(colour: Color(0xFF002fff), title: buttonTittle, onPressed: () {
              limitAndCategory = [widget.categoryLimits, buttonTittle, widget.salary];
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EnterCategoryValuesScreen(limitAndCategory: limitAndCategory)
                  )
              );
            }),
            SizedBox(
              width: 8.0,
            ),
            DeleteButton(colour: Color(0xFF002fff), title: 'Delete Category', categories: categories, categoryLimits: widget.categoryLimits, state: this, index: this.ind),
          ],
        )
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context, {heading: String}) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(heading),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Category Title"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Color(0xFF161d6f),
                textColor: Colors.white,
                child: Text('Cancel'),
                onPressed: () {
                    _textFieldController.clear();
                    Navigator.pop(context);
                },
              ),
              FlatButton(
                color: Color(0xFF002fff),
                textColor: Colors.white,
                child: Text('Create Category'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    created = true;
                    _textFieldController.clear();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> _limitsTooHigh(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Your limits which totals to R${widget.totalLimits} exceeds your salary. Please decrease your limits'),
            actions: <Widget>[
              FlatButton(
                color: Color(0xFF161d6f),
                textColor: Colors.white,
                child: Text('Okay'),
                onPressed: () {
                  _textFieldController.clear();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
