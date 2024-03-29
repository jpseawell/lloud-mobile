import 'package:flutter/cupertino.dart';

class ImageFile {
  int id;
  String name;
  String location;
  String s3Bucket;

  ImageFile({
    @required this.id,
    @required this.name,
    @required this.location,
    @required this.s3Bucket,
  });

  factory ImageFile.fromJson(Map<String, dynamic> json) {
    return ImageFile(
        id: json['id'],
        name: json['name'],
        location: json['location'],
        s3Bucket: json['s3_bucket']);
  }

  factory ImageFile.empty() {
    return ImageFile(id: 0, name: '', location: '', s3Bucket: '');
  }
}
