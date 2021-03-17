import 'package:budge8/components/categoryLimits.dart';
import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final Color colour;
  final String title;
  int index;
  State state;
  List categories;
  List categoryLimits;

  DeleteButton ({this.colour, this.title, this.categories, this.categoryLimits, this.state, this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: Color(0xFFff004c),
        borderRadius: BorderRadius.circular(15.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: () {
            state.setState(() {
              categories[index] = new Row();
              categoryLimits[index] = new CategoryLimits('');
            });
          },
          minWidth: 100.0,
          height: 42.0,
          child: Text(
            'Delete Category',
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}