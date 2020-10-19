import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/util/activity.dart';
import 'package:lloud_mobile/views/components/search_bar.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    // TODO: Setup API endpoint
    Activity.reportPageView(Routes.explore);
  }

  Widget showCase() {
    if (isSearching) {
      return Container();
    }

    return Expanded(child: Showcase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: LloudTheme.white2,
      body: SafeArea(
          child: Column(
        children: [
          SearchBar(
            onChanged: (value) => print('changed: $value'),
            onOpen: () {
              setState(() {
                isSearching = true;
              });
            },
            onClose: () {
              setState(() {
                isSearching = false;
              });
            },
          ),
          showCase()
        ],
      )),
    );
  }
}

class Showcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: Card(
                  color: LloudTheme.red,
                  child: Stack(
                    children: [
                      Image.network(
                        'https://images.lloudapp.com/1596589130367-democover2.jpg',
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ))
              ],
            )),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Card(
                  child: Stack(
                    children: [
                      Image.network(
                        'https://images.lloudapp.com/1596589130367-democover2.jpg',
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                )),
            Expanded(
                flex: 1,
                child: Card(
                  child: Stack(
                    children: [
                      Image.network(
                        'https://images.lloudapp.com/1596589130367-democover2.jpg',
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                )),
            Expanded(
                flex: 1,
                child: Card(
                  child: Stack(
                    children: [
                      Image.network(
                        'https://images.lloudapp.com/1596589130367-democover2.jpg',
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                )),
            Expanded(
                flex: 1,
                child: Card(
                  child: Stack(
                    children: [
                      Image.network(
                        'https://images.lloudapp.com/1596589130367-democover2.jpg',
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                )),
          ],
        ),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Card(
                  child: Stack(
                    children: [
                      Image.network(
                        'https://images.lloudapp.com/1596589130367-democover2.jpg',
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                )),
            Expanded(
                flex: 1,
                child: Card(
                  child: Stack(
                    children: [
                      Image.network(
                        'https://images.lloudapp.com/1596589130367-democover2.jpg',
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                )),
            Expanded(
                flex: 1,
                child: Card(
                  child: Stack(
                    children: [
                      Image.network(
                        'https://images.lloudapp.com/1596589130367-democover2.jpg',
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                )),
            Expanded(
                flex: 1,
                child: Card(
                  child: Stack(
                    children: [
                      Image.network(
                        'https://images.lloudapp.com/1596589130367-democover2.jpg',
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ],
    );
  }
}
