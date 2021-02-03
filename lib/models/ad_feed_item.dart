import 'package:flutter/material.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';

import 'package:lloud_mobile/models/feed_item.dart';
import 'package:lloud_mobile/views/components/ad.dart';

class AdFeedItem implements FeedItem {
  final String adUnitID;
  final NativeAdmobController controller;

  AdFeedItem(this.adUnitID, this.controller);

  Widget build(BuildContext context) {
    controller.reloadAd(forceRefresh: true, numberAds: 1);
    return Ad(
      adUnitID: adUnitID,
      controller: controller,
    );
  }
}
