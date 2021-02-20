import 'package:flutter/material.dart';
class appButton extends StatelessWidget {
  final Color colour;
  final String title;
  final Function onPressed;

  appButton ({this.colour, this.title, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: colour,
        borderRadius: BorderRadius.circular(15.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}