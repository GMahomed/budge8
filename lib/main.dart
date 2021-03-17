import 'package:budge8/screens/budgetSetupScreen.dart';
import 'package:budge8/screens/createdBudgetScreen.dart';
import 'package:budge8/screens/enterCategoryValues.dart';
import 'package:budge8/screens/enterSalaryScreen.dart';
import 'package:budge8/screens/myGoalAfterSetup.dart';
import 'package:budge8/screens/myGoalBeforeSetup.dart';
import 'package:budge8/screens/myGoalSetupScreen.dart';
import 'package:budge8/screens/transactionsScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:budge8/screens/startUpScreen.dart';
import 'package:budge8/screens/loginScreen.dart';
import 'package:budge8/screens/emailRegistrationScreen.dart';
import 'package:budge8/screens/homePageScreenNoBudge.dart';
import 'package:budge8/screens/homePageScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(budge8());
}

class budge8 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: StartUpScreen.id,
      routes: {
        StartUpScreen.id: (context) => StartUpScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        EmailRegistrationScreen.id: (context) => EmailRegistrationScreen(),
        HomePageNoBudgeScreen.id: (context) => HomePageNoBudgeScreen(),
        BudgetSetupScreen.id: (context) => BudgetSetupScreen(),
        EnterSalaryScreen.id: (context) => EnterSalaryScreen(),
        HomePageScreen.id: (context) => HomePageScreen(),
        EnterCategoryValuesScreen.id: (context) => EnterCategoryValuesScreen(),
        TransactionScreen.id: (context) => TransactionScreen(),
        CreatedBudgetScreen.id: (context) => CreatedBudgetScreen(),
        MyGoalBeforeSetup.id: (context) => MyGoalBeforeSetup(),
        MyGoalSetupScreen.id: (context) => MyGoalSetupScreen(),
        MyGoalAfterSetup.id: (context) => MyGoalAfterSetup()
      },
    );
  }
}
