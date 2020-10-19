import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:lloud_mobile/providers/user.dart';
import 'package:lloud_mobile/models/user.dart';
import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/util/auth.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/components/h2.dart';
import 'package:lloud_mobile/views/templates/base.dart';

class OptionsPage extends StatelessWidget {
  Future<void> launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> logout(BuildContext context) async {
    await Auth.clearToken();
    // await Purchases.reset();
    // await Provider.of<SongPlayer>(context, listen: false).stopSong();
    return Navigator.pushNamed(context, Routes.login);
  }

  Widget successSnackBar(String message) {
    return SnackBar(content: Text(message ?? 'Update operation successful!'));
  }

  @override
  Widget build(BuildContext context) {
    return BaseTemplate(
      backgroundColor: LloudTheme.white2,
      child: Builder(
          builder: (snackCtx) => ListView(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 40,
                        child: FlatButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.clear,
                              color: LloudTheme.whiteDark,
                            )),
                      ),
                      Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            alignment: Alignment.center,
                            height: 56,
                            child: H2('Options'),
                          )),
                      SizedBox(
                        width: 40,
                      )
                    ],
                  ),
                  header('Account'),
                  div(),
                  Ink(
                    color: LloudTheme.white,
                    child: ListTile(
                      title: Text('Edit Profile'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () async {
                        var result = await Navigator.pushNamed(
                            context, Routes.edit_profile);
                        if (result == 'success') {
                          Scaffold.of(snackCtx).showSnackBar(successSnackBar(
                              'User profile successfully updated!'));
                        }
                      },
                    ),
                  ),
                  div(),
                  Ink(
                    color: LloudTheme.white,
                    child: ListTile(
                      title: Text('Shipping Info'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () async {
                        var result = await Navigator.pushNamed(
                            context, Routes.shipping_info);
                        if (result == 'success') {
                          Scaffold.of(snackCtx).showSnackBar(successSnackBar(
                              'Shipping info successfully updated!'));
                        }
                      },
                    ),
                  ),
                  div(),
                  SizedBox(
                    height: 16,
                  ),
                  header('Support'),
                  div(),
                  Ink(
                    color: LloudTheme.white,
                    child: ListTile(
                      title: Text('Contact'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        launchUrl('https://lloudapp.com/contact');
                      },
                    ),
                  ),
                  div(),
                  Ink(
                    color: LloudTheme.white,
                    child: ListTile(
                      title: Text('Help'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        launchUrl('https://lloudapp.com/help');
                      },
                    ),
                  ),
                  div(),
                  Ink(
                    color: LloudTheme.white,
                    child: ListTile(
                      title: Text('Terms of Service'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        launchUrl('https://lloudapp.com/terms');
                      },
                    ),
                  ),
                  div(),
                  Ink(
                    color: LloudTheme.white,
                    child: ListTile(
                      title: Text('Privacy Policy'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        launchUrl('https://lloudapp.com/privacy');
                      },
                    ),
                  ),
                  div(),
                  SizedBox(
                    height: 24,
                  ),
                  header('Artists'),
                  div(),
                  Ink(
                    color: LloudTheme.white,
                    child: ListTile(
                      title: Text('Upload Music'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        launchUrl('https://lloudapp.com/artists/apply');
                      },
                    ),
                  ),
                  div(),
                  SizedBox(
                    height: 24,
                  ),
                  div(),
                  Ink(
                    color: LloudTheme.white,
                    child: ListTile(
                      title: Text(
                        'Log Out',
                        style: TextStyle(color: LloudTheme.red),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () async {
                        await logout(context);
                      },
                    ),
                  ),
                  div(),
                  SizedBox(
                    height: 24,
                  ),
                ],
              )),
    );
  }

  Widget div() {
    return Divider(
      height: 0,
    );
  }

  Widget header(String txt) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        txt,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
      ),
    );
  }
}
