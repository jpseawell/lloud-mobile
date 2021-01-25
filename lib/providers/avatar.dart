import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:lloud_mobile/models/image_file.dart';
import 'package:lloud_mobile/util/network.dart';

class Avatar with ChangeNotifier {
  ImageFile image;
  final String authToken;
  final int userId;

  Avatar(this.authToken, this.userId);

  Future<void> fetchAndSetImage() async {
    final url = '${Network.host}/api/v2/user/$userId/image-files';
    final res = await http.get(url, headers: Network.headers(token: authToken));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (res.statusCode != 200) {
      throw Exception('Fetch profile image failed.');
    }

    image = decodedRes['data']['imageFile'] == null
        ? ImageFile.empty()
        : ImageFile.fromJson(decodedRes['data']['imageFile']);

    notifyListeners();
  }

  Future<void> postProfileImg(String filename) async {
    final url = '${Network.host}/api/v2/user/$userId/image-files';

    final req = http.MultipartRequest('POST', Uri.parse(url));
    req.headers['Accept'] = 'application/json';
    req.headers['Authorization'] = 'Bearer $authToken';

    req.files.add(await http.MultipartFile.fromPath('image', filename,
        contentType: MediaType('image', 'jpg')));

    final streamedRes = await req.send();
    final res = await http.Response.fromStream(streamedRes);
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (decodedRes['status'] != 'success')
      throw Exception('Profile image upload failed.');

    image = decodedRes['data']['imageFile'] == null
        ? ImageFile.empty()
        : ImageFile.fromJson(decodedRes['data']['imageFile']);

    notifyListeners();
  }
}
