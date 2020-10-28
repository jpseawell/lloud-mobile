import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/util/activity.dart';
import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/views/components/search_bar.dart';
import 'package:lloud_mobile/views/components/search_result.dart';
import 'package:lloud_mobile/views/components/showcase.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  bool isSearching = false;
  bool isRequesting = false;
  Map<String, dynamic> searchResults = {};
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    // TODO: Setup API endpoint
    Activity.reportPageView(Routes.explore);
  }

  Future<Map<String, dynamic>> sendRequest(String searchTerm) async {
    setState(() {
      isRequesting = true;
      _searchTerm = searchTerm;
    });

    final response =
        await DAL.instance().post('search', {'searchTerm': searchTerm});
    Map<String, dynamic> decodedResponse = json.decode(response.body);

    setState(() {
      searchResults = decodedResponse['data'];
      isRequesting = false;
    });
  }

  Widget searchResultList() {
    if (!isSearching) {
      return Container();
    }

    List<Widget> builtResults = buildResults(searchResults);

    return Expanded(
        child: SingleChildScrollView(
      child: Column(
        children: builtResults.length > 0
            ? builtResults
            : [
                _searchTerm.isEmpty
                    ? Container()
                    : Container(
                        padding: EdgeInsets.only(top: 12),
                        child: Text('No Results Found'),
                      )
              ],
      ),
    ));
  }

  List<Widget> buildResults(Map<String, dynamic> input) {
    List<Widget> results = [];

    if (input == null) {
      return [Container()];
    }

    List<dynamic> artists = input['artists'] ?? [];
    List<dynamic> songs = input['songs'] ?? [];
    List<dynamic> users = input['users'] ?? [];

    artists.forEach((artist) {
      if (artist['likes'] == null) {
        return;
      }

      if (artist['imageFile'] == null) {
        return;
      }

      String description = '${artist['likes']} likes';
      if (artist['city'] != null && artist['state'] != null) {
        description += ' | ${artist['city']}, ${artist['state']}';
      }

      results.add(SearchResult(
        type: 1,
        subjectId: artist['id'],
        title: artist['name'],
        description: description,
        imgLocation: artist['imageFile']['location'],
      ));
    });

    songs.forEach((song) {
      results.add(SearchResult(
        type: 3,
        subjectId: song['id'],
        title: song['title'],
        description: song['artists'][0]['name'],
        imgLocation: song['imageFile']['location'],
      ));
    });

    users.forEach((user) {
      results.add(SearchResult(
          type: 2,
          subjectId: user['id'],
          title: '@' + user['username'],
          description: '',
          imgLocation: user['profileImg'] != null
              ? user['profileImg']['location']
              : ''));
    });

    return results;
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
            onChanged: (value) => sendRequest(value),
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
          searchResultList(),
          showCase()
        ],
      )),
    );
  }
}
