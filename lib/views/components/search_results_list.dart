import 'package:flutter/material.dart';
import 'package:lloud_mobile/views/components/search_result.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/providers/search.dart';

class SearchResultsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<Search>(context);
    final artists = searchProvider.artists;
    final users = searchProvider.users;
    final songs = searchProvider.songs;
    return SingleChildScrollView(
      child: Column(
        children: [
          if ((artists.length + users.length + songs.length) == 0)
            Container(
              padding: EdgeInsets.only(top: 12),
              child: Text('No Results Found'),
            ),
          for (var artist in artists)
            SearchResult(
              type: 1,
              subjectId: artist['id'],
              title: artist['name'],
              description: artistDescription(artist),
              imgLocation: (artist['imageFile'] != null)
                  ? artist['imageFile']['location']
                  : '',
            ),
          for (var song in songs)
            SearchResult(
              type: 3,
              subjectId: song['id'],
              title: song['title'],
              description: song['artists'][0]['name'],
              imgLocation: song['imageFile']['location'],
            ),
          for (var user in users)
            SearchResult(
                type: 2,
                subjectId: user['id'],
                title: '@' + user['username'],
                description: '',
                imgLocation: (user['profileImg'] != null)
                    ? user['profileImg']['location']
                    : '')
        ],
      ),
    );
  }

  String artistDescription(dynamic artist) {
    String description = '';

    if (artist['likes'] != null) description += '${artist['likes']} likes';

    if (artist['city'] != null && artist['state'] != null) {
      description += ' | ${artist['city']}, ${artist['state']}';
    }

    return description;
  }
}
