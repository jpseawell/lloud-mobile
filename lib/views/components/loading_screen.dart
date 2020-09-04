import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.3,
          child: const ModalBarrier(dismissible: false, color: Colors.grey),
        ),
        Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(LloudTheme.red)),
        ),
      ],
    );
  }
}
