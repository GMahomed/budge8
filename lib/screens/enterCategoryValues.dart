import 'package:budge8/const.dart';
import 'package:flutter/material.dart';
import 'package:budge8/components/appButton.dart';

import 'budgetSetupScreen.dart';

class EnterCategoryValuesScreen extends StatefulWidget {
  static String id = 'enterCategoryValuesScreen';
  final List limitAndCategory;
  String limit;
  int index;

  EnterCategoryValuesScreen({this.limitAndCategory})
  {
    index = findIndex();
  }


  @override
  _EnterCategoryValuesScreenState createState() => _EnterCategoryValuesScreenState();

  int findIndex ()
  {
    for(int i = 0; i < limitAndCategory[0].length; i++)
      {
        if(limitAndCategory[0][i].getCategory() == (limitAndCategory[1]))
          {
            index = i;
            break;
          }
      }

    return index;
  }
}

class _EnterCategoryValuesScreenState extends State<EnterCategoryValuesScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Enter the maximum value that may be spent on ${widget.limitAndCategory[1]}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20
                ),
              ),

              SizedBox(
                height: 25.0,
              ),

              TextFormField(
                initialValue: widget.limitAndCategory[0][widget.index].getLimit().toString(),
                validator: (value) {
                  Pattern pattern = r"^[0-9]+$";
                  RegExp regex = new RegExp(pattern);
                  if (value.isEmpty) {
                    return 'Entering a maximum category value is required';
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
                  if(value != ''){
                    widget.limit = value;
                  }
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Category Max'),
              ),
              SizedBox(
                height: 8.0,
              ),
              AppButton(
                title: 'Continue',
                colour: Color(0xFF002fff),
                onPressed: () async {
                  if(_formKey.currentState.validate()) {
                    try {
                      this._formKey.currentState.reset();
                      widget.limitAndCategory[0][widget.index].setLimit(int.parse(widget.limit));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BudgetSetupScreen(categoryLimits: widget.limitAndCategory[0], salary: widget.limitAndCategory[2])
                          )
                      );

                    }
                    catch (e) {

                      print(e);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
