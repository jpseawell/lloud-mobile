import 'package:flutter/material.dart' hide Notification;

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/components/activities_list.dart';
import 'package:lloud_mobile/views/components/h1.dart';
import 'package:lloud_mobile/views/templates/base.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    return BaseTemplate(
      backgroundColor: LloudTheme.white2,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 56,
                        width: 40,
                        child: FlatButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: LloudTheme.whiteDark,
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 12),
                        child: H1('Activity'),
                      ),
                    ],
                  ),
                ],
              )),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero,
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(right: 14),
                  child: Icon(
                    Icons.favorite,
                    color: LloudTheme.red,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            height: 0,
          ),
          ActivitiesList()
        ],
      ),
    );
  }
}
