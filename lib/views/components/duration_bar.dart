import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/views/components/duration_slider.dart';
import 'package:lloud_mobile/providers/audio_player.dart';

class DurationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioPlayer = Provider.of<AudioPlayer>(context);

    return Column(children: [
      DurationSlider(Duration(seconds: audioPlayer.positionSeconds.round()),
          Duration(seconds: audioPlayer.durationSeconds.round()))
    ]);
  }
}
