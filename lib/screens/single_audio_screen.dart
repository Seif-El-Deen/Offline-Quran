import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:quran_kareem/services/audio_player.dart';
import 'package:quran_kareem/shared/constants.dart';

class SingleAudioScreen extends StatefulWidget {
  const SingleAudioScreen({Key? key}) : super(key: key);

  // final int currentAudioIndex;

  @override
  State<SingleAudioScreen> createState() => _SingleAudioScreenState();
}

class _SingleAudioScreenState extends State<SingleAudioScreen> {
  // dynamic url = "";
  double audioLength = 0;
  @override
  void initState() {
    super.initState();

    // setAudio();

    Audio.player.onPlayerStateChanged.listen((state) {
      setState(() {
        Audio.audioIsPlaying = state == AudioPlayerState.PLAYING;
      });
    });

    Audio.player.onDurationChanged.listen((newDuration) async {
      audioLength = await Audio.player.getDuration() / (1000 * 60);
      // print("audio Length: ${audioLength / 1000}");
      setState(() {
        Audio.duration = newDuration;
        // print(newDuration);
      });
    });
    Audio.player.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        Audio.position = newPosition;
        // print(newPosition);
      });
    });

    Audio.player.onPlayerCompletion.listen((event) {
      Audio.playNext();
    });
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(":");
  }

  @override
  void dispose() {
    // Audio.player.dispose();
    // super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Hero(
        tag: "Single Audio Screen",
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Center(
                child: CircleAvatar(
                  radius: 150,
                  child: Text(
                    "سورة\n${audios[Audio.currentAudioIndex]}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 78,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Slider(
                  min: 0,
                  max: Audio.duration.inSeconds.toDouble(),
                  value: Audio.position.inSeconds.toDouble(),
                  onChanged: (value) async {
                    Audio.position = Duration(seconds: value.toInt().floor());
                    await Audio.player.seek(Audio.position);
                    // print(
                    //     "Max Duration: ${Audio.duration.inSeconds.toDouble()}");
                    // print(
                    //     "Slide Value: ${Audio.position.inSeconds.toDouble()}");
                    await Audio.player.resume();

                    setState(() {});
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(formatTime(Audio.position)),
                    Text(formatTime(Audio.duration - Audio.position)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                    onTap: () {
                      Audio.playBefore();
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.skip_previous,
                      size: 70,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (Audio.audioIsPlaying) {
                        await Audio.pauseAudio();
                      } else {
                        await Audio.playAudio();
                      }
                      // audioIsPlaying = !audioIsPlaying;
                      // await setAudio();
                      setState(() {});
                    },
                    child: Icon(
                      Audio.audioIsPlaying
                          ? Icons.pause
                          : Icons.play_circle_fill,
                      size: 70,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Audio.playNext();
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.skip_next,
                      size: 70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
