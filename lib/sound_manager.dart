import 'package:just_audio/just_audio.dart';

class SoundManager {
  static final _player = AudioPlayer();

  static String? _url;
  static String? get url => _url;

  static Future<void> playUrl(
    String url, {
    Function()? onStart,
  }) async {
    try {
      _url = url;
      if (_player.playing) await _player.stop();
      await _player.setUrl(url);
      onStart?.call();
      await _player.play();
      _url = null;
    } catch (e) {
      print(e);
    }
  }
}
