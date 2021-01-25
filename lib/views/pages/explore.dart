import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/views/components/search_results_list.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/providers/search.dart';
import 'package:lloud_mobile/views/components/search_bar.dart';
import 'package:lloud_mobile/views/components/showcase.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    final isSearching = Provider.of<Search>(context).isSearching;
    return Scaffold(
      backgroundColor: LloudTheme.white2,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          child: Column(children: [
            SearchBar(),
            if (isSearching) Expanded(child: SearchResultsList()),
            if (!isSearching)
              Expanded(
                child: Showcase(),
              )
          ]),
        ),
      ),
    );
  }
}
