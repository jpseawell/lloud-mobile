import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/providers/audio_player.dart';

class DurationSlider extends StatelessWidget {
  Duration currPosition;
  Duration totalDuration;

  DurationSlider(this.currPosition, this.totalDuration);

  double getValue(Duration currPos, Duration totDur) {
    if (currPos == null || currPos.isNegative || currPos == Duration.zero)
      return 0;

    return currPosition.inMilliseconds / totalDuration.inMilliseconds;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      Slider(
        activeColor: LloudTheme.white,
        inactiveColor: LloudTheme.whiteDark,
        value: getValue(currPosition, totalDuration),
        min: 0,
        max: 1,
        label: null,
        onChanged: (double value) {
          double newPos = value * totalDuration.inMilliseconds.toDouble();
          Provider.of<AudioPlayer>(context, listen: false)
              .player
              .seek(new Duration(milliseconds: newPos.toInt()));
        },
      ),
      Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              currPosition.toString().substring(2, 7),
              textAlign: TextAlign.left,
              style: TextStyle(color: LloudTheme.white, fontSize: 12),
            ),
            Text(
              totalDuration.toString().substring(2, 7),
              textAlign: TextAlign.right,
              style: TextStyle(color: LloudTheme.white, fontSize: 12),
            )
          ],
        ),
      )
    ]);
  }
}
