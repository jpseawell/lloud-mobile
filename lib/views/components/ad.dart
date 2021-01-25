import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

class Ad extends StatelessWidget {
  final String adUnitID;
  final NativeAdmobController controller;

  Ad({this.adUnitID, this.controller});

  final NativeAdmobOptions _options = NativeAdmobOptions(
      adLabelTextStyle: NativeTextStyle(
          backgroundColor: LloudTheme.whiteDark.withOpacity(.4)),
      headlineTextStyle: NativeTextStyle(color: LloudTheme.white),
      advertiserTextStyle: NativeTextStyle(color: LloudTheme.white2),
      storeTextStyle: NativeTextStyle(color: LloudTheme.white2),
      priceTextStyle: NativeTextStyle(color: LloudTheme.white2),
      callToActionStyle: NativeTextStyle(
          color: LloudTheme.white, backgroundColor: LloudTheme.red));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      padding: EdgeInsets.only(left: 4, top: 4, right: 4),
      child: Card(
        color: LloudTheme.black,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.all(8),
          child: NativeAdmob(
            adUnitID: adUnitID,
            numberAds: 1,
            controller: controller,
            loading: Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(LloudTheme.red),
            )),
            error: Text(
              'FAILED',
              style: TextStyle(color: LloudTheme.white),
            ),
            type: NativeAdmobType.full,
            options: _options,
          ),
        ),
      ),
    );
  }
}
