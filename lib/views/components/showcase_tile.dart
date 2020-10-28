import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/showcase_item.dart';
import 'package:lloud_mobile/routes.dart';

class ShowcaseTile extends StatelessWidget {
  final ShowcaseItem item;

  ShowcaseTile({this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
          if (item.entityTypeId == 1) {
            Navigator.of(context)
                .pushNamed(Routes.artist, arguments: item.subject['id']);
          }
        },
        child: Row(
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          NetworkImage(item.subject['imageFile']['location']),
                      fit: BoxFit.cover)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: Container(
                  color: LloudTheme.black.withOpacity(.1),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
