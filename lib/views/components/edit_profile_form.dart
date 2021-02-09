import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:lloud_mobile/services/error_reporting.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/providers/auth.dart';

class EditProfileForm extends StatefulWidget {
  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _editProfileFormKey = GlobalKey<FormState>();
  Map<String, dynamic> _errors = {};

  void parseResponse(List<dynamic> response) {
    if (response.isEmpty) {
      setState(() {
        _errors = {};
      });
      return;
    }

    Map<String, dynamic> tmpErrs = {};
    for (var obj in response) {
      tmpErrs[obj['field']] = obj['message'];
    }

    setState(() {
      _errors = tmpErrs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: LloudTheme.white,
        child: Form(
          key: _editProfileFormKey,
          child: Consumer<Auth>(
              builder: (context, auth, _) => ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      TextFormField(
                          initialValue: auth.user.firstName,
                          decoration: InputDecoration(labelText: 'First Name'),
                          onSaved: (val) => auth.user.firstName = val),
                      TextFormField(
                          initialValue: auth.user.lastName,
                          decoration: InputDecoration(labelText: 'Last Name'),
                          validator: (value) {
                            return null;
                          },
                          onSaved: (val) => auth.user.lastName = val),
                      TextFormField(
                          initialValue: auth.user.userName,
                          decoration: InputDecoration(
                              labelText: 'Username *',
                              errorText: _errors.containsKey('username')
                                  ? _errors['username']
                                  : null),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a username';
                            }

                            return null;
                          },
                          onSaved: (val) => auth.user.userName = val),
                      TextFormField(
                          initialValue: auth.user.email,
                          decoration: InputDecoration(
                              labelText: 'Email *',
                              errorText: _errors.containsKey('email')
                                  ? _errors['email']
                                  : null),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a valid email address';
                            }

                            if (!EmailValidator.validate(value)) {
                              return 'Please enter a valid email address';
                            }

                            return null;
                          },
                          onSaved: (val) => auth.user.email = val),
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
                                        parseResponse(
                                            await auth.updateUser(auth.user));

                                        if (_errors.isNotEmpty) {
                                          Scaffold.of(snackCtx).showSnackBar(
                                              SnackBar(
                                                  backgroundColor:
                                                      LloudTheme.red,
                                                  content: Text(
                                                      'Failed to update user profile.')));
                                          return;
                                        }

                                        return Navigator.pop(
                                            context, 'success');
                                      } catch (err, stack) {
                                        ErrorReportingService.report(err,
                                            stackTrace: stack);
                                      }
                                    }
                                  },
                                  child: Text('Update Profile',
                                      style: TextStyle(fontSize: 18)),
                                  color: LloudTheme.red,
                                  textColor: LloudTheme.white,
                                )),
                      )
                    ],
                  )),
        ));
  }
}
