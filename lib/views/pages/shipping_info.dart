import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:lloud_mobile/util/network.dart';
import 'package:lloud_mobile/models/state.dart';
import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/components/backpage_header.dart';
import 'package:lloud_mobile/views/components/loading_screen.dart';
import 'package:lloud_mobile/views/templates/base.dart';

class ShippingInfo extends StatefulWidget {
  @override
  _ShippingInfoState createState() => _ShippingInfoState();
}

class _ShippingInfoState extends State<ShippingInfo> {
  final _shippingInfoFormKey = GlobalKey<FormState>();
  final _stateKey = GlobalKey<FormFieldState>();
  Future<List<USState>> states;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    states = fetchStates(Provider.of<Auth>(context, listen: false).token);
  }

  Future<List<USState>> fetchStates(String token) async {
    setState(() {
      isLoading = true;
    });

    const url = '${Network.host}/api/v2/states';
    final res = await http.get(url, headers: Network.headers(token: token));

    if (res.statusCode != 200) throw Exception('Could not fetch states.');

    Map<String, dynamic> decodedResponse = json.decode(res.body);

    setState(() {
      isLoading = false;
    });

    return USState.fromJsonList(decodedResponse["data"]["states"]);
  }

  @override
  Widget build(BuildContext context) {
    return BaseTemplate(
      backgroundColor: LloudTheme.white2,
      child: FutureBuilder<List<USState>>(
        future: states,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return LoadingScreen();

          return Stack(
            children: [
              Column(
                children: [
                  BackpageHeader('Shipping Info'),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Text(
                      'Your address is required for shipping purchased items from the shop.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(child: form(snapshot.data))
                ],
              ),
              if (isLoading) LoadingScreen()
            ],
          );
        },
      ),
    );
  }

  Widget form(List<USState> fetchedStates) {
    return Container(
        color: LloudTheme.white,
        child: Form(
          key: _shippingInfoFormKey,
          child: Consumer<Auth>(
            builder: (context, auth, _) {
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  TextFormField(
                      initialValue: auth.user.address1,
                      decoration: InputDecoration(labelText: 'Address *'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter an address';
                        }

                        return null;
                      },
                      onSaved: (val) => auth.user.address1 = val),
                  TextFormField(
                      initialValue: auth.user.address2,
                      decoration: InputDecoration(labelText: 'Address 2'),
                      onSaved: (val) => auth.user.address2 = val),
                  TextFormField(
                      initialValue: auth.user.city,
                      decoration: InputDecoration(labelText: 'City *'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a city';
                        }

                        return null;
                      },
                      onSaved: (val) => auth.user.city = val),
                  DropdownButtonFormField<int>(
                    key: _stateKey,
                    value: auth.user.state,
                    decoration: InputDecoration(labelText: 'State *'),
                    validator: (value) {
                      return (value == null) ? 'Please select a state' : null;
                    },
                    isExpanded: true,
                    onChanged: (int state) {
                      auth.user.state = state;
                    },
                    items: fetchedStates
                        .map((USState state) => DropdownMenuItem(
                            value: state.id, child: Text(state.name)))
                        .toList(),
                  ),
                  TextFormField(
                      initialValue: auth.user.zipcode,
                      decoration: InputDecoration(labelText: 'Zipcode *'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a zipcode';
                        }

                        return null;
                      },
                      onSaved: (val) => auth.user.zipcode = val),
                  TextFormField(
                      enabled: false,
                      initialValue: 'United States',
                      decoration: InputDecoration(labelText: 'Country *'),
                      onSaved: (val) => auth.user.country = val),
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
                                    await auth.updateUser(auth.user);
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
              );
            },
          ),
        ));
  }

  Widget errorSnackBar() {
    return SnackBar(
        backgroundColor: LloudTheme.red,
        content: Text('Failed to update shipping info.'));
  }
}
