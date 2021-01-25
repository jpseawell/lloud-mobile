import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/components/edit_profile_form.dart';
import 'package:lloud_mobile/views/components/h2.dart';
import 'package:lloud_mobile/views/components/loading_screen.dart';
import 'package:lloud_mobile/views/components/profile_image_picker.dart';
import 'package:lloud_mobile/views/templates/base.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BaseTemplate(
      backgroundColor: LloudTheme.white2,
      child: Stack(
        children: [
          Column(
            children: [
              EditProfileHeader(),
              ProfileImagePicker(
                onLoading: setLoadingCB(true),
                onNotLoading: setLoadingCB(false),
              ),
              Expanded(child: EditProfileForm())
            ],
          ),
          if (_isLoading) LoadingScreen()
        ],
      ),
    );
  }

  Function setLoadingCB(bool val) {
    return () {
      setState(() {
        _isLoading = val;
      });
    };
  }
}

class EditProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: 40,
          child: FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: LloudTheme.whiteDark,
              )),
        ),
        Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              height: 56,
              child: H2('Edit Profile'),
            )),
        SizedBox(
          width: 40,
        )
      ],
    );
  }
}
