import 'dart:convert';

import 'package:lloud_mobile/services/error_reporting.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:lloud_mobile/providers/avatar.dart';
import 'package:lloud_mobile/util/network.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/models/image_file.dart';
import 'package:lloud_mobile/models/user.dart';
import 'package:lloud_mobile/views/components/my_avatar.dart';
import 'package:lloud_mobile/views/components/lloud_dialog.dart';

class ProfileImagePicker extends StatefulWidget {
  final Function onLoading;
  final Function onNotLoading;

  ProfileImagePicker({this.onLoading, this.onNotLoading});

  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState(
      onLoading: this.onLoading, onNotLoading: this.onNotLoading);
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  final Function onLoading;
  final Function onNotLoading;

  final picker = ImagePicker();

  _ProfileImagePickerState({this.onLoading, this.onNotLoading});

  Future<void> destroyImage(User user, ImageFile img) async {
    onLoading();

    final url = '${Network.host}/api/v2/user/${user.id}/image-files/${img.id}';
    final token = Provider.of<Auth>(context, listen: false).token;
    final res = await http.delete(url, headers: Network.headers(token: token));
    Map<String, dynamic> decodedResponse = json.decode(res.body);

    if (decodedResponse['status'] != 'success') {
      onNotLoading();
      throw Exception('Error: Failed to delete image');
    }

    try {
      await Provider.of<Avatar>(context, listen: false).fetchAndSetImage();
    } catch (err, stack) {
      ErrorReportingService.report(err, stackTrace: stack);
    }

    onNotLoading();
  }

  Future<void> uploadImage(User user, PickedFile file) async {
    if (file == null) {
      return;
    }

    onLoading();

    try {
      await Provider.of<Avatar>(context, listen: false)
          .postProfileImg(file.path);
    } catch (err, stack) {
      ErrorReportingService.report(err, stackTrace: stack);
    }

    onNotLoading();
  }

  void showMenuDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => LloudDialog(
              content: Consumer<Auth>(
                builder: (context, auth, _) {
                  return Column(
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
                            ImageFile img =
                                await auth.user.fetchProfileImg(auth.token);
                            if (img != null) {
                              await destroyImage(auth.user, img);
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
                              await uploadImage(
                                  auth.user,
                                  await picker.getImage(
                                      source: ImageSource.camera));
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
                              await uploadImage(
                                  auth.user,
                                  await picker.getImage(
                                      source: ImageSource.gallery));
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
                  );
                },
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlatButton(
            padding: EdgeInsets.symmetric(vertical: 8),
            onPressed: () {
              showMenuDialog(context);
            },
            child: Column(
              children: [
                MyAvatar(
                  darkIfEmpty: true,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Text('Change Profile Photo'),
                )
              ],
            ))
      ],
    );
  }
}
