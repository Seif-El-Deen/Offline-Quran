import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:quran_kareem/services/audio_player.dart';
import 'package:quran_kareem/shared/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Audio.stopAudio();
    try {
      Audio.player.onPlayerStateChanged.listen((state) {
        setState(() {
          Audio.audioIsPlaying = state == AudioPlayerState.PLAYING;
        });
      });

      Audio.player.onDurationChanged.listen((newDuration) async {
        // print("audio Length: ${audioLength / 1000}");
        setState(() {
          Audio.duration = newDuration;
          // print(newDuration.inSeconds);
        });
      });
      Audio.player.onAudioPositionChanged.listen((newPosition) {
        setState(() {
          Audio.position = newPosition;
          // print(newPosition);
        });
      });
    } catch (e) {
      //
    }

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

  // @override
  // void dispose() {
  //   // Audio.player.dispose();
  //   // super.dispose();
  // }

  bool singleAudioScreen = false;

  @override
  Widget build(BuildContext context) {
    return singleAudioScreen
        ? Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  singleAudioScreen = false;
                  setState(() {});
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
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
                        value: Audio.position.inSeconds.toDouble() <
                                Audio.duration.inSeconds.toDouble()
                            ? Audio.position.inSeconds.toDouble()
                            : 0,
                        onChanged: (value) async {
                          Audio.position =
                              Duration(seconds: value.toInt().floor());

                          await Audio.player.seek(Audio.position);
                          await Audio.player.resume();

                          // setState(() {});
                        }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(formatTime(Audio.position)),
                          Text(formatTime(Audio.duration)),
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
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text(
                "القران الكريم",
                style: TextStyle(fontSize: 24),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                        padding: const EdgeInsets.all(15),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    border: Border.all(
                                      color: Colors.blueGrey,
                                      width: 4,
                                    ),
                                    shape: BoxShape.circle,
                                    // borderRadius: BorderRadius.circular(35),
                                  ),
                                  child: Text(
                                    "${index + 1}",
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text(
                                  audios[index],
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                IconButton(
                                    padding: const EdgeInsets.only(right: 10),
                                    onPressed: () {
                                      // playing audio from beginning
                                      if (Audio.audioIsPlaying &&
                                          Audio.currentAudioIndex == index) {
                                        Audio.pauseAudio();
                                      } // stopping a playing audio and playing another one
                                      else if (Audio.audioIsPlaying &&
                                          Audio.currentAudioIndex != index) {
                                        Audio.stopAudio();
                                        Audio.currentAudioIndex = index;
                                        Audio.playAudio();
                                      } //
                                      else {
                                        Audio.currentAudioIndex = index;
                                        Audio.playAudio();
                                      }
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Audio.currentAudioIndex == index &&
                                              Audio.audioIsPlaying
                                          ? Icons.pause
                                          : Icons.play_circle_fill,
                                      color: Colors.green,
                                      size: 50,
                                    ))
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            height: 2,
                            thickness: 2,
                            color: Colors.grey,
                          );
                        },
                        itemCount: audios.length),
                  ),
                  GestureDetector(
                    onTap: () {
                      singleAudioScreen = true;
                      setState(() {});
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const SingleAudioScreen(),
                      //   ),
                      // );
                    },
                    child: Container(
                      // height: 80,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        border: Border.all(width: 5, color: Colors.blueGrey),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "سورة ${audios[Audio.currentAudioIndex]}",
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w600),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Audio.playBefore();
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.skip_previous,
                                  size: 40,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (Audio.audioIsPlaying) {
                                    Audio.pauseAudio();
                                  } else {
                                    Audio.playAudio();
                                  }
                                  setState(() {});
                                },
                                icon: Icon(
                                  Audio.audioIsPlaying
                                      ? Icons.pause
                                      : Icons.play_circle_fill,
                                  size: 40,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Audio.playNext();
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.skip_next,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
