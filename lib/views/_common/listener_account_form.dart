import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/util/auth.dart';

import 'package:lloud_mobile/providers/user.dart';
import 'package:lloud_mobile/models/user.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
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
                enabled: false,
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
            TextFormField(
                initialValue: user.address1,
                decoration: InputDecoration(labelText: 'Address 1'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (val) => this.user.address1 = val),
            TextFormField(
                initialValue: user.address2,
                decoration: InputDecoration(labelText: 'Address 2 (optional)'),
                onSaved: (val) => this.user.address2 = val),
            TextFormField(
                initialValue: user.city,
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (val) => this.user.city = val),
            TextFormField(
                initialValue: user.state,
                decoration: InputDecoration(labelText: 'State'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (val) => this.user.state = val),
            TextFormField(
                initialValue: user.zipcode,
                decoration: InputDecoration(labelText: 'Zipcode'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (val) => this.user.zipcode = val),
            TextFormField(
                initialValue: user.country,
                decoration: InputDecoration(labelText: 'Country'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (val) => this.user.country = val),
            SizedBox(height: 16.0),
            RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                        backgroundColor: LloudTheme.red,
                        content: Text(e.toString())));
                  }

                  Provider.of<UserModel>(context, listen: false).fetchUser();
                }
              },
              child: Text('Update Info', style: TextStyle(fontSize: 18)),
              color: LloudTheme.red,
              textColor: LloudTheme.white,
            ),
            SizedBox(height: 16.0),
            // TODO: Move logout button out of account form
            FlatButton(
                onPressed: () async {
                  await Auth.clearToken();
                  return Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  'Log out',
                  style: TextStyle(color: LloudTheme.red, fontSize: 18),
                )),
          ]),
        ));
  }
}
