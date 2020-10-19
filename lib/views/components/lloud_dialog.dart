import 'package:flutter/material.dart';

class LloudDialog extends StatelessWidget {
  Widget content;

  LloudDialog({this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: content,
    );
  }
}
