import 'package:budge8/components/appButton.dart';
import 'package:budge8/screens/transactionsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../const.dart';

class MakeTransactionScreen extends StatefulWidget {
  static String id = 'MakeTransactionScreen';
  String categoryName;
  int categoryLimit;
  int currentCategoryAmount;
  int amountIncreased;
  String userEmail;
  bool makeTransaction =false;

  MakeTransactionScreen({this.categoryName, this.categoryLimit, this.currentCategoryAmount, this.userEmail});

  @override
  _MakeTransactionState createState() => _MakeTransactionState();
}

class _MakeTransactionState extends State<MakeTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Transact'),
        backgroundColor: Color(0xFF161d6f),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Spending Limit for ${widget.categoryName}: R${widget.categoryLimit}',
                  textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                )
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Amount Spent on ${widget.categoryName} so far: R${widget.currentCategoryAmount}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Remaining Balance: R${widget.categoryLimit - widget.currentCategoryAmount}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Amount spent on ${widget.categoryName} has increased by:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                validator: (value) {
                  Pattern pattern = r"^[0-9]+$";
                  RegExp regex = new RegExp(pattern);
                  if (value.isEmpty) {
                    return 'Entering an amount is required';
                  }

                  if (!regex.hasMatch(value))
                  {
                    return 'Ensure that the entered value consists only of digits';
                  }

                  return null;
                },
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if(value != '')
                  {
                    int spent = int.tryParse(value);
                    if(spent != null)
                    {
                      widget.amountIncreased = spent;
                    }
                  }
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Amount Spent'),
              ),
              SizedBox(
                height: 1.0,
              ),
              AppButton(colour: Color(0xFF002fff), title: 'Record Amount', onPressed: () async
              {
                if(_formKey.currentState.validate()) {
                  if(widget.currentCategoryAmount + widget.amountIncreased <= widget.categoryLimit) {
                    try {

                      await _confirmTransaction(context);

                      if(widget.makeTransaction == true)
                      {
                        this._formKey.currentState.reset();

                        await this._fireStore.collection("users").doc(widget.userEmail).collection("categories").doc("${widget.categoryName}").update({
                          'currentAmount': widget.currentCategoryAmount + widget.amountIncreased
                        });

                        Navigator.pushNamed(context, TransactionScreen.id);
                      }
                      else {
                        this._formKey.currentState.reset();
                      }
                    }
                    catch (e) {

                      print(e);
                    }
                  }
                  else {
                    await _transactionTooHigh(context);
                  }
                }
              })
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmTransaction(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Are you sure that you want to increase ${widget.categoryName} by R${widget.amountIncreased}'),
             content: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    color: Color(0xFF002fff),
                    textColor: Colors.white,
                    child: Text('Cancel'),
                    onPressed: () {
                      widget.makeTransaction = false;
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    color: Color(0xFF161d6f),
                    textColor: Colors.white,
                    child: Text('Yes'),
                    onPressed: () {
                      widget.makeTransaction = true;
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
          );
        });
  }

  Future<void> _transactionTooHigh(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('The Entered Amount Exceeds the Limit. Please Edit your Budget to Cater for this Transaction.'),
              actions: [
                FlatButton(
                  color: Color(0xFF161d6f),
                  textColor: Colors.white,
                  child: Text('Okay'),
                  onPressed: () {
                    widget.makeTransaction = true;
                    Navigator.pop(context);
                  },
                ),
              ],
          );
        });
  }
}
