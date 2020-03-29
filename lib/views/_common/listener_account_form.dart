import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

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
                },
                onSaved: (val) => this.user.firstName = val),
            TextFormField(
                initialValue: user.lastName,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (val) => this.user.lastName = val),
            TextFormField(
                initialValue: user.userName,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (val) => this.user.userName = val),
            TextFormField(
                initialValue: user.email,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (val) => this.user.email = val),
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
              onPressed: () async {
                final FormState form = _formKey.currentState;
                if (form.validate()) {
                  try {
                    form.save();
                    await this.user.update(this.user);

                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Account Info Updated')));
                  } catch (e) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Account Info Could Not Be Updated')));
                  }
                }
              },
              child: Text('Update Info'),
            )
          ]),
        ));
  }
}
