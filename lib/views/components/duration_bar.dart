import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:lloud_mobile/views/components/duration_slider.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/providers/audio_player.dart';

class DurationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioPlayer = Provider.of<AudioPlayer>(context);

    return Column(children: [
      StreamBuilder<PlaybackDisposition>(
        stream: audioPlayer.streamController.stream,
        initialData: PlaybackDisposition(duration: Duration(milliseconds: 0)),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.data.duration.isNegative ||
              snapshot.connectionState == ConnectionState.waiting) {
            return DurationSlider(Duration.zero, Duration.zero);
          }

          return DurationSlider(snapshot.data.position, snapshot.data.duration);
        },
      )
    ]);
  }
}
