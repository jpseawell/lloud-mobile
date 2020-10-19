import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lloud_mobile/models/state.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/user.dart';
import 'package:lloud_mobile/providers/user.dart';
import 'package:lloud_mobile/views/components/h2.dart';
import 'package:lloud_mobile/views/components/loading_screen.dart';
import 'package:lloud_mobile/views/templates/base.dart';

class ShippingInfo extends StatefulWidget {
  @override
  _ShippingInfoState createState() => _ShippingInfoState();
}

class _ShippingInfoState extends State<ShippingInfo> {
  final _shippingInfoFormKey = GlobalKey<FormState>();
  final _stateKey = GlobalKey<FormFieldState>();
  Future<List<USState>> futureStates;
  List<USState> states;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    futureStates = fetchStates();
  }

  Future<List<USState>> fetchStates() async {
    final response = await DAL.instance().fetch('states/');
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      List<USState> tmpStates =
          USState.fromJsonList(decodedResponse["data"]["states"]);

      setState(() {
        states = tmpStates;
      });

      return states;
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    return BaseTemplate(
      backgroundColor: LloudTheme.white2,
      child: FutureBuilder<List<USState>>(
        future: futureStates,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loading();
          }

          return Stack(
            children: [
              Column(
                children: [
                  header(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Text(
                      'Your address is required for shipping purchased items from the shop.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(child: form(user))
                ],
              ),
              loading()
            ],
          );
        },
      ),
    );
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
              child: H2('Shipping Info'),
            )),
        SizedBox(
          width: 40,
        )
      ],
    );
  }

  Widget form(User user) {
    return Container(
      color: LloudTheme.white,
      child: Form(
          key: _shippingInfoFormKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: [
              TextFormField(
                  initialValue: user.address1,
                  decoration: InputDecoration(labelText: 'Address *'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter an address';
                    }

                    return null;
                  },
                  onSaved: (val) => user.address1 = val),
              TextFormField(
                  initialValue: user.address2,
                  decoration: InputDecoration(labelText: 'Address 2'),
                  onSaved: (val) => user.address2 = val),
              TextFormField(
                  initialValue: user.city,
                  decoration: InputDecoration(labelText: 'City *'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a city';
                    }

                    return null;
                  },
                  onSaved: (val) => user.city = val),
              DropdownButtonFormField<int>(
                key: _stateKey,
                value: user.state,
                decoration: InputDecoration(labelText: 'State *'),
                validator: (value) {
                  return (value == null) ? 'Please select a state' : null;
                },
                isExpanded: true,
                onChanged: (int state) {
                  user.state = state;
                },
                items: states
                    .map((USState state) => DropdownMenuItem(
                        value: state.id, child: Text(state.name)))
                    .toList(),
              ),
              TextFormField(
                  enabled: false,
                  initialValue: 'United States',
                  decoration: InputDecoration(labelText: 'Country *'),
                  onSaved: (val) => user.country = val),
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
                                _shippingInfoFormKey.currentState;

                            if (form.validate()) {
                              try {
                                form.save();
                                await user.update(user);
                                await Provider.of<UserProvider>(context,
                                        listen: false)
                                    .fetchAndNotify();
                                return Navigator.pop(context, 'success');
                              } catch (e) {
                                Scaffold.of(snackCtx)
                                    .showSnackBar(errorSnackBar());
                              }
                            }
                          },
                          child: Text('Update Shipping Info',
                              style: TextStyle(fontSize: 18)),
                          color: LloudTheme.red,
                          textColor: LloudTheme.white,
                        )),
              )
            ],
          )),
    );
  }

  Widget errorSnackBar() {
    return SnackBar(
        backgroundColor: LloudTheme.red,
        content: Text('Failed to update shipping info.'));
  }

  Widget loading() {
    if (isLoading) {
      return LoadingScreen();
    }

    return Container();
  }
}
