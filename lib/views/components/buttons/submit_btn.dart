import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Builder(
      builder: (snackContext) => RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          onPressed: () {
            onPressed();
          }),
    ));
  }
}
