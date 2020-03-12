import 'package:flutter/material.dart';

import 'package:lloud_mobile/views/_common/h1.dart';
import 'package:lloud_mobile/views/_common/h2.dart';

class ListenerAccountPage extends StatefulWidget {
  @override
  _ListenerAccountPageState createState() => _ListenerAccountPageState();
}

class _ListenerAccountPageState extends State<ListenerAccountPage> {
  final _formKey = GlobalKey<FormState>();

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
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                }),
            TextFormField(
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                }),
            TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                }),
            TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                }),
            H2("Shipping Info"),
            Text(
                "Your address is required for shipping purchased items from the store."),
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
