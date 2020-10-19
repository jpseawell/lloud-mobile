import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';

class SearchBar extends StatefulWidget {
  final Function(String value) onChanged;
  final Function() onOpen;
  final Function() onClose;

  SearchBar({this.onChanged, this.onOpen, this.onClose});

  @override
  _SearchBarState createState() => _SearchBarState(
      onChanged: this.onChanged, onOpen: this.onOpen, onClose: this.onClose);
}

class _SearchBarState extends State<SearchBar> {
  final Function(String value) onChanged;
  final Function() onOpen;
  final Function() onClose;
  bool isSearching = false;

  _SearchBarState({this.onChanged, this.onOpen, this.onClose});

  Widget textField() {
    return TextField(
      onChanged: (value) {
        onChanged(value);
      },
      onTap: () {
        if (!isSearching) {
          onOpen();
          setState(() {
            isSearching = true;
          });
        }
      },
      cursorColor: LloudTheme.red,
      decoration: InputDecoration(
          border: InputBorder.none,
          focusColor: LloudTheme.red,
          icon: Icon(
            Icons.search,
          ),
          hintText: 'Search'),
    );
  }

  Widget cancelBtn(BuildContext ctx) {
    if (!isSearching) {
      return Container();
    }

    return Container(
      width: 48,
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () {
          onClose();
          setState(() {
            isSearching = false;
          });
          FocusScope.of(ctx).unfocus(); // close keyboard
        },
        child: Icon(
          Icons.cancel,
          color: LloudTheme.whiteDark,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [Expanded(flex: 1, child: textField()), cancelBtn(context)],
        ),
      ),
    );
  }
}
