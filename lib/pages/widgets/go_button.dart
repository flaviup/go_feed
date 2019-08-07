import 'package:flutter/material.dart';

class GoButton extends StatelessWidget {

  GoButton({this.text, this.semanticsLabel, this.onPressed});

  final String text;
  final String semanticsLabel;
  final VoidCallback onPressed;

  static final ButtonRadius = BorderRadius.circular(20); // 0 - 30

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.blue,
      focusElevation: 4,
      highlightElevation: 4,
      child: Text(
        text ?? "",
        semanticsLabel: semanticsLabel ?? "",
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: ButtonRadius,
      ),
      onPressed: onPressed,
    );
  }
}
