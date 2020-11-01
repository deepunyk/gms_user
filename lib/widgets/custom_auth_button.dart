import 'package:flutter/material.dart';

class CustomAuthButton extends StatelessWidget {
  final String title;
  final Function onTap;

  CustomAuthButton({this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 10),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          onTap();
        },
        child: Text(
          "$title",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
