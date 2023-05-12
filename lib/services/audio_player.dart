import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:quran_kareem/shared/constants.dart';

class Audio {
  // static String playingAudio = "الفاتحة";
  static bool audioIsPlaying = false;
  static int currentAudioIndex = 0;
  static AudioPlayer player = AudioPlayer();
  static AudioCache audioCache =
      AudioCache(prefix: "assets/audios/", fixedPlayer: player);
  static Duration duration = Duration.zero;
  static Duration position = Duration.zero;

  static double audioLength = 0;

  static Future<void> playAudio() async {
    audioIsPlaying = true;
    await audioCache.play('${audios[currentAudioIndex]}.mp3');
  }

  static Future<void> pauseAudio() async {
    audioIsPlaying = false;
    await player.pause();
  }

  static Future<void> stopAudio() async {
    audioIsPlaying = false;
    await player.stop();
  }

  static Future<void> playNext() async {
    currentAudioIndex++;
    if (currentAudioIndex == audios.length) {
      currentAudioIndex = 0;
    }
    await playAudio();
  }

  static Future<void> playBefore() async {
    currentAudioIndex--;
    if (currentAudioIndex == -1) {
      currentAudioIndex = audios.length - 1;
    }
    await playAudio();
  }

  static Future<void> loopOnAudio() async {
    await player.setReleaseMode(ReleaseMode.LOOP);
  }

  static Future<void> stopLoopOnAudio() async {
    await player.setReleaseMode(ReleaseMode.RELEASE);
  }
}
