import 'dart:convert';
import 'package:flutter/material.dart';

import '../../util/dal.dart';
import '../../models/user.dart';

import 'package:lloud_mobile/views/_common/h1.dart';
import 'package:lloud_mobile/views/_common/h2.dart';

class ListenerAccountForm extends StatefulWidget {
  final User user;

  ListenerAccountForm(this.user);

  @override
  _ListenerAccountFormState createState() =>
      _ListenerAccountFormState(this.user);
}

class _ListenerAccountFormState extends State<ListenerAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final User user;

  _ListenerAccountFormState(this.user);

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: ListView(children: <Widget>[
            H1("My Account"),
            H2("Personal Info"),
            TextFormField(
                initialValue: user.firstName,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                }),
            TextFormField(
                initialValue: user.lastName,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                }),
            TextFormField(
                initialValue: user.userName,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                }),
            TextFormField(
                initialValue: user.email,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                }),
            SizedBox(height: 16.0),
            H2("Shipping Info"),
            SizedBox(height: 8.0),
            Text(
              "Your address is required for shipping purchased items from the store.",
              style: TextStyle(fontSize: 16.0),
            ),
            TextFormField(decoration: InputDecoration(labelText: 'Address 1')),
            TextFormField(decoration: InputDecoration(labelText: 'Address 2')),
            TextFormField(decoration: InputDecoration(labelText: 'City')),
            TextFormField(decoration: InputDecoration(labelText: 'State')),
            TextFormField(decoration: InputDecoration(labelText: 'Zipcode')),
            TextFormField(decoration: InputDecoration(labelText: 'Country')),
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Submit'),
            )
          ]),
        ));
  }
}
