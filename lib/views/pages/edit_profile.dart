import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:lloud_mobile/models/image_file.dart';
import 'package:lloud_mobile/views/components/loading_screen.dart';
import 'package:lloud_mobile/views/components/my_avatar.dart';
import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/views/components/lloud_dialog.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/user.dart';
import 'package:lloud_mobile/providers/user.dart';
import 'package:lloud_mobile/views/components/h2.dart';
import 'package:lloud_mobile/views/templates/base.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _editProfileFormKey = GlobalKey<FormState>();
  Map<String, dynamic> errors = {};
  final picker = ImagePicker();
  bool isLoading = false;

  void parseResponse(Map<String, dynamic> response) {
    if (response['status'] != "fail") {
      return;
    }

    Map<String, dynamic> tmpErrs = {};
    for (var obj in response['data']) {
      tmpErrs[obj['field']] = obj['message'];
    }

    setState(() {
      errors = tmpErrs;
    });
  }

  Future<void> uploadImage(BuildContext context, PickedFile file) async {
    if (file == null) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    User user = Provider.of<UserProvider>(context, listen: false).user;
    final response =
        await DAL.instance().postFile(file.path, 'user/${user.id}/image-files');
    Map<String, dynamic> decodedResponse = json.decode(response.body);

    // TODO: Handle failed response

    await Provider.of<UserProvider>(context, listen: false)
        .fetchProfileImgAndNotify();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> destroyImage(ImageFile img) async {
    setState(() {
      isLoading = true;
    });

    User user = Provider.of<UserProvider>(context, listen: false).user;
    final response = await DAL
        .instance()
        .delete('user/${user.id.toString()}/image-files/${img.id.toString()}');
    Map<String, dynamic> decodedResponse = json.decode(response.body);

    // TODO: Handle failed response

    await Provider.of<UserProvider>(context, listen: false)
        .fetchProfileImgAndNotify();
    setState(() {
      isLoading = false;
    });
  }

  void showProfilePhotoMenuDialog(BuildContext context) {
    ImageFile img =
        Provider.of<UserProvider>(context, listen: false).profileImg;
    showDialog(
        context: context,
        child: LloudDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(children: <Widget>[
                Expanded(
                    child: FlatButton(
                  child: Text(
                    "Remove Current Photo",
                    style: TextStyle(fontSize: 16),
                  ),
                  textColor: LloudTheme.red,
                  onPressed: () async {
                    if (img != null) {
                      await destroyImage(img);
                    }
                    Navigator.of(context).pop();
                  },
                )),
              ]),
              Divider(
                height: 1,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: FlatButton(
                    child: Text(
                      "Take Photo",
                      style: TextStyle(fontSize: 16),
                    ),
                    textColor: LloudTheme.black,
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await uploadImage(context,
                          await picker.getImage(source: ImageSource.camera));
                    },
                  ))
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: FlatButton(
                    child: Text(
                      "Choose From Library",
                      style: TextStyle(fontSize: 16),
                    ),
                    textColor: LloudTheme.black,
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await uploadImage(context,
                          await picker.getImage(source: ImageSource.gallery));
                    },
                  ))
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: FlatButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(fontSize: 16),
                    ),
                    textColor: LloudTheme.black,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ))
                ],
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    return BaseTemplate(
      backgroundColor: LloudTheme.white2,
      child: Stack(
        children: [
          Column(
            children: [header(), avatar(user), Expanded(child: form(user))],
          ),
          loading()
        ],
      ),
    );
  }

  Widget loading() {
    if (isLoading) {
      return LoadingScreen();
    }

    return Container();
  }

  Widget avatar(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlatButton(
            padding: EdgeInsets.symmetric(vertical: 8),
            onPressed: () {
              showProfilePhotoMenuDialog(context);
            },
            child: Column(
              children: [
                MyAvatar(),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Text('Change Profile Photo'),
                )
              ],
            ))
      ],
    );
  }

  Widget form(User user) {
    return Container(
      color: LloudTheme.white,
      child: Form(
        key: _editProfileFormKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          children: [
            TextFormField(
                initialValue: user.firstName,
                decoration: InputDecoration(labelText: 'First Name'),
                onSaved: (val) => user.firstName = val),
            TextFormField(
                initialValue: user.lastName,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  return null;
                },
                onSaved: (val) => user.lastName = val),
            TextFormField(
                initialValue: user.userName,
                decoration: InputDecoration(
                    labelText: 'Username *',
                    errorText: errors.containsKey('username')
                        ? errors['username']
                        : null),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a username';
                  }

                  return null;
                },
                onSaved: (val) => user.userName = val),
            TextFormField(
                initialValue: user.email,
                decoration: InputDecoration(
                    labelText: 'Email *',
                    errorText:
                        errors.containsKey('email') ? errors['email'] : null),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a valid email address';
                  }

                  if (!EmailValidator.validate(value)) {
                    return 'Please enter a valid email address';
                  }

                  return null;
                },
                onSaved: (val) => user.email = val),
            Container(
              margin: EdgeInsets.only(top: 16),
              child: Builder(
                  builder: (snackCtx) => RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        onPressed: () async {
                          final FormState form =
                              _editProfileFormKey.currentState;

                          if (form.validate()) {
                            try {
                              form.save();
                              parseResponse(await user.update(user));
                              await Provider.of<UserProvider>(context,
                                      listen: false)
                                  .fetchAndNotify();
                              if (errors.isNotEmpty) {
                                Scaffold.of(snackCtx)
                                    .showSnackBar(errorSnackBar());
                                return;
                              }

                              return Navigator.pop(context, 'success');
                            } catch (e) {}
                          }
                        },
                        child: Text('Update Profile',
                            style: TextStyle(fontSize: 18)),
                        color: LloudTheme.red,
                        textColor: LloudTheme.white,
                      )),
            )
          ],
        ),
      ),
    );
  }

  Widget errorSnackBar() {
    return SnackBar(
        backgroundColor: LloudTheme.red,
        content: Text('Failed to update user profile.'));
  }

  Widget header() {
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
