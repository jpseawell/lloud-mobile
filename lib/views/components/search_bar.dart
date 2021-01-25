import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/providers/search.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    _controller.addListener(_handleChange);
  }

  Future<void> _handleChange() async {
    final searchProvider = Provider.of<Search>(context, listen: false);
    searchProvider.isFetching = true;
    await searchProvider.fetchAndSetSearchResults(_controller.text);
    searchProvider.isFetching = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<Search>(context);
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: TextField(
                  controller: _controller,
                  onTap: () {
                    if (!searchProvider.isSearching)
                      searchProvider.isSearching = true;
                  },
                  cursorColor: LloudTheme.red,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusColor: LloudTheme.red,
                      icon: Icon(
                        Icons.search,
                      ),
                      hintText: 'Search'),
                )),
            if (searchProvider.isSearching)
              Container(
                width: 48,
                child: FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () {
                    FocusScope.of(context).unfocus(); // close keyboard
                    searchProvider.clear();
                    _controller.clear();
                  },
                  child: Icon(
                    Icons.cancel,
                    color: LloudTheme.whiteDark,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
