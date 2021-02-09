import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/views/components/notification_widget.dart';
import 'package:lloud_mobile/views/templates/base.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/components/h1.dart';
import 'package:lloud_mobile/providers/notifications.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  ScrollController _scrollController;
  bool _isFetching = true;
  int _currentPage = 1;

  @override
  void initState() {
    Provider.of<Notifications>(context, listen: false).reset().then((_) {
      setState(() {
        _isFetching = false;
      });
    });
    _scrollController = ScrollController();
    _scrollController.addListener(shouldFetch);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(shouldFetch);
    _scrollController.dispose();
    super.dispose();
  }

  void shouldFetch() {
    if (_isFetching) return;

    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 160 &&
        !_scrollController.position.outOfRange) {
      fetchItems();
    }
  }

  Future<void> fetchItems() async {
    setState(() {
      _isFetching = true;
      _currentPage = _currentPage + 1;
    });

    await Provider.of<Notifications>(context, listen: false)
        .fetchAndSetNotifications(page: _currentPage);

    setState(() {
      _isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifications = Provider.of<Notifications>(context).notifications;

    return BaseTemplate(
        backgroundColor: LloudTheme.white2,
        child: Container(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
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
                ]),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                return NotificationWidget(notification: notifications[index]);
              }, childCount: notifications.length)),
              if (_isFetching)
                SliverList(
                    delegate: SliverChildListDelegate([
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(LloudTheme.red),
                    ),
                  )
                ]))
            ],
          ),
        ));
  }
}
