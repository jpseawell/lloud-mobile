import 'package:flutter/material.dart';
import 'package:lloud_mobile/views/components/duration_slider.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/providers/audio_player.dart';

class DurationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final player = Provider.of<AudioPlayer>(context).player;
    return Column(children: [
      StreamBuilder<Duration>(
        stream: player.currentPosition,
        initialData: Duration(milliseconds: 0),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.data.isNegative ||
              !player.current.hasValue ||
              snapshot.connectionState == ConnectionState.waiting) {
            return DurationSlider(Duration.zero, Duration.zero);
          }

          return DurationSlider(
              snapshot.data, player.current.value.audio.duration);
        },
      )
    ]);
  }
}
